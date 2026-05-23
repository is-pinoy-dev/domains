# is-pinoy.dev

Free `*.is-pinoy.dev` subdomains for Filipino developers.

Point your portfolio, side project, or open source work at a subdomain that represents where you're from.

## Register a Subdomain

1. **Fork** this repository
2. **Create** a file at `subdomains/<your-subdomain>.json`
3. **Open a pull request** — your subdomain is live once it's merged and synced

> **Want a faster review?** Post your PR link in our [Discord](https://discord.com/channels/1507758007218471062/1507758194624299039) and a maintainer will pick it up sooner.

## JSON Format

```json
{
  "subdomain": "yourname",
  "owner": {
    "github": "your-github-username",
    "email": "you@example.com"
  },
  "records": {
    "CNAME": {
      "value": "yoursite.vercel.app."
    }
  }
}
```

The `email` field is optional. The filename must match the `subdomain` field exactly (e.g. `yourname.json`).

## Supported Records

| Type | Use case | Example value |
|------|----------|---------------|
| `CNAME` | Hosted platforms (Vercel, Netlify, GitHub Pages) | `yoursite.vercel.app.` |
| `A` | Custom server / VPS | `203.0.113.1` |
| `TXT` | Domain verification (Google, email providers) | `google-site-verification=...` |

You can combine record types. For example, use `CNAME` for your site and `TXT` for verification.

### CNAME example

```json
{
  "subdomain": "yourname",
  "owner": { "github": "your-github-username" },
  "records": {
    "CNAME": { "value": "yoursite.vercel.app." }
  }
}
```

### A record example

```json
{
  "subdomain": "yourname",
  "owner": { "github": "your-github-username" },
  "records": {
    "A": { "value": "203.0.113.1" }
  }
}
```

### TXT + CNAME example

```json
{
  "subdomain": "yourname",
  "owner": { "github": "your-github-username" },
  "records": {
    "CNAME": { "value": "yoursite.vercel.app." },
    "TXT": { "value": "google-site-verification=abc123", "provider": "vercel" }
  }
}
```

## Rules

- Subdomain must be lowercase alphanumeric and hyphens only (`a-z`, `0-9`, `-`)
- Length: 1–63 characters
- One subdomain per person
- Must point to something real — no squatting
- `owner.github` must match your GitHub username

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

[MIT](LICENSE)
