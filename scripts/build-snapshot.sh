#!/usr/bin/env bash
#
# Assemble the full registry snapshot the dashboard's /api/registry/events
# endpoint expects, from the subdomains/*.json files plus git-derived dates.
#
# The dashboard's D1 table is a read model of this repo, and the handler
# reconciles it against whatever this produces: a name present here is
# upserted, a row absent from here is deleted. That makes the snapshot a
# complete picture every time — a lost or replayed delivery heals on the next
# run — but it also means an entry wrongly omitted here disappears from the
# dashboard. Only `destroy: true` entries are omitted, and only because their
# records are on their way out of the zone.
#
# Usage: build-snapshot.sh [subdomains-dir] [output-file]
#   SNAPSHOT_STATUS  synced | failed | pending   (default: synced)
#   SNAPSHOT_ERROR   error text when status=failed
set -euo pipefail

DIR="${1:-subdomains}"
OUT="${2:-snapshot.json}"
STATUS="${SNAPSHOT_STATUS:-synced}"
ERROR="${SNAPSHOT_ERROR:-}"

case "$STATUS" in
  synced | failed | pending) ;;
  *)
    echo "build-snapshot: invalid SNAPSHOT_STATUS '$STATUS'" >&2
    exit 1
    ;;
esac

if [ ! -d "$DIR" ]; then
  echo "build-snapshot: no such directory: $DIR" >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
: > "$tmp/domains.ndjson"

skipped=0
for file in "$DIR"/*.json; do
  [ -e "$file" ] || continue

  if [ "$(jq -r '.destroy // false' "$file")" = "true" ]; then
    skipped=$((skipped + 1))
    continue
  fi

  # First and last commit to touch the file. Forced to UTC with a literal Z
  # rather than %cI's numeric offset: the endpoint validates these with Zod's
  # z.iso.datetime(), which rejects an offset unless it is exactly Z.
  #
  # Deliberately without --follow. A subdomain file is usually created by
  # copying a neighbour, and git's rename detection scores that as a rename of
  # whichever file it most resembles: bosquejun.json traces back through
  # mee.json and reports a registration date from before the subdomain
  # existed. The D1 row is keyed by subdomain name, so even a real rename is a
  # new row rather than a continuation, and the plain history of this exact
  # path is the one that matches what the dashboard shows.
  dates="$(TZ=UTC git log --format=%cd \
    --date=format-local:%Y-%m-%dT%H:%M:%SZ -- "$file")"
  updated="$(printf '%s\n' "$dates" | head -n 1)"
  created="$(printf '%s\n' "$dates" | tail -n 1)"

  jq -c \
    --arg status "$STATUS" \
    --arg error "$ERROR" \
    --arg created "$created" \
    --arg updated "$updated" \
    '{
       subdomain: .subdomain,
       owner: (.owner | {github, id, email} | with_entries(select(.value != null))),
       records: .records,
       features: (.features // null),
       status: $status,
       error: (if $error == "" then null else $error end)
     }
     + (if $created == "" then {} else { createdAt: $created } end)
     + (if $updated == "" then {} else { updatedAt: $updated } end)' \
    "$file" >> "$tmp/domains.ndjson"
done

jq -s \
  --arg syncedAt "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{ syncedAt: $syncedAt, domains: . }' \
  "$tmp/domains.ndjson" > "$OUT"

echo "build-snapshot: $(jq '.domains | length' "$OUT") domain(s), ${skipped} destroyed entry/entries omitted, status=${STATUS}" >&2
