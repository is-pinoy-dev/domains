# Discord forum threads for subdomain pull requests

**Date:** 2026-08-17
**Status:** Approved

## Problem

Contributors are told in the README to paste their PR link into Discord so a
maintainer picks it up sooner. That is a manual step contributors forget and
maintainers cannot rely on. The review queue lives in someone's memory rather
than anywhere visible.

## Goal

Every human subdomain registration PR gets a thread in a Discord forum channel
when it opens, and that thread reflects the PR's outcome when it closes. The
forum channel's active thread list becomes an accurate review queue.

## Scope

A PR gets a thread only when all of these hold:

- it changes at least one `subdomains/*.json`
- the author is not a bot (`pull_request.user.type != 'Bot'`) — excludes Dependabot
- it is not the repo's own `chore/vercel-txt-cleanup` branch, which the scheduled
  Vercel TXT cleanup opens against `subdomains/` with a PAT (so it authors as a
  human and the bot check alone does not catch it)
- it is not a draft — drafts post when marked ready for review instead

Out of scope: reacting to review state, validation results, or comments. The
thread tracks open → closed, nothing finer.

## Trigger

One workflow, `.github/workflows/discord-forum.yml`, on `pull_request_target`
with types `[opened, reopened, ready_for_review, closed]`, plus
`workflow_dispatch` for testing.

`pull_request_target` is required because nearly every PR here comes from a
fork, and fork PRs on plain `pull_request` receive no secrets. It is safe for
this job because the workflow never checks out or executes PR content — it
reads subdomain JSON through the API as data only. This matches the posture
already established in `validate.yml`.

## Data flow

1. Fetch the PR object once (`gh api repos/OWNER/REPO/pulls/N`) and read every
   gating and display value from it. Nothing untrusted is interpolated into
   shell via `${{ }}`; values move through env vars and `jq --arg`.
2. Fetch the PR's changed files, keep `subdomains/*.json`.
3. For each kept file, fetch its content at the PR head sha with the
   `application/vnd.github.raw` accept header, then read `subdomain`,
   `owner.github`, and the first record type and value. A file with
   `"destroy": true`, or a `removed` file status, renders as a removal.
4. Build the embed and call Discord.

A PR touching several subdomains produces **one** thread listing each entry,
capped at 5 with a "+N more" line.

## Card

Discord embed, one thread per PR:

- **Thread name** — `#158 · joel-santos`, truncated to Discord's 100-char limit.
  The PR number leads so threads are searchable by it.
- **Author line** — `<login> wants to register a subdomain`, with avatar
- **Title** — `joel-santos.is-pinoy.dev`, linked to the PR
- **Description** — the PR title
- **Fields** — Owner, Record, Target, File (inline)
- **Footer** — `is-pinoy-dev/domains · PR #158`, with the PR's timestamp

Colors follow state: amber while open, green on merge, red on close-unmerged.

## Lifecycle

| Event | Forum tag | Action |
| --- | --- | --- |
| opened / ready for review | `Needs review` | create thread |
| reopened | `Needs review` | unarchive and retag the existing thread |
| closed, merged | `Live` | retag, reply, archive |
| closed, unmerged | `Closed` | retag, reply, archive |

Order on close matters: **retag → reply → archive**. An archived thread cannot
be posted into without reviving it first.

Retagging preserves non-status tags. Discord's `applied_tags` is a full
replacement rather than a merge, so writing the status tag alone would silently
wipe any tag a human applied — the forum already carries a `Portfolio` tag. The
workflow reads the thread's current tags, drops only the three status tags, and
prepends the new one. Discord caps a thread at 5 tags, so the result is sliced
to 5 with the status tag first, guaranteeing status survives and the oldest
extras are shed instead.

Archiving keeps the active list an accurate queue. It does not lock the thread,
so a contributor returning with a question revives it by replying.

The merge reply reads "Merged — live shortly at https://x.is-pinoy.dev" rather
than claiming it is already live, because the DNS sync workflow runs after the
merge.

## Finding the thread on close

Stateless. Search `GET /guilds/{guild}/threads/active`, filter to threads whose
`parent_id` is the forum channel and whose name starts with `#158 ·`. If Discord
auto-archived the thread for inactivity, fall back to
`GET /channels/{forum}/threads/archived/public`, paginating on
`archive_timestamp` for up to 5 pages.

The `#158 ·` prefix cannot collide across PR numbers: `#158 · x` does not start
with `#15 ·`.

Nothing is stored on the GitHub side — no marker comments, no state branch.

## Configuration

Secret:

- `DISCORD_BOT_TOKEN`

Repository variables (not sensitive, so not secrets):

- `DISCORD_GUILD_ID`
- `DISCORD_FORUM_CHANNEL_ID`
- `DISCORD_TAG_NEEDS_REVIEW`
- `DISCORD_TAG_LIVE`
- `DISCORD_TAG_CLOSED`

The three forum tags are created by hand in Discord channel settings; the
workflow does not create them. If any value is missing the workflow logs a
notice and exits 0, so the repo stays green before the Discord side is set up.

The bot needs `Send Messages`, `Create Posts`, and `Manage Threads` in the forum
channel.

## Failure handling

The job is `continue-on-error`. A Discord outage, a revoked token, or a rate
limit must never put a red X on a contributor's PR. Failures write a warning to
the step summary and exit 0. HTTP 429 gets one retry honoring `retry_after`.

## Testing

`workflow_dispatch` takes a `pr_number` and a `dry_run` flag. With `dry_run`,
every payload is printed to the step summary and nothing is sent, so the card
can be verified against a real PR before pointing the workflow at the live
forum.

## Rejected alternatives

**Incoming webhook instead of a bot token.** A webhook can create a forum thread
and can apply tags at creation, but cannot retag, archive, or lock afterward —
the merged state would only be visible by opening the thread. Rejected because
the status lifecycle is the point. The trade-off accepted in exchange: a bot
token is a heavier credential than a single-channel webhook URL.

**Storing the thread id in a sticky PR comment.** Robust, and it matches the
existing `<!-- pareng-gar:safe-browsing -->` pattern, but it adds a comment to
every PR purely for bookkeeping. The stateless search covers the same ground.
