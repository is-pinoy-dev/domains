<div align="center">

<img src="https://raw.githubusercontent.com/is-pinoy-dev/.github/main/assets/banner.gif" alt="is-pinoy.dev banner" width="100%" />

# 🇵🇭 is-pinoy.dev — Subdomain Registry

**Free `*.is-pinoy.dev` subdomains for Filipino developers.**

Point your portfolio at a subdomain that represents where you're from.

[![Registered Subdomains](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fis-pinoy-dev%2Fdomains%2Fmain%2Fstats.json&style=for-the-badge&color=FFD700&labelColor=1a1a2e&logoColor=FFD700)](https://github.com/is-pinoy-dev/domains/tree/main/subdomains)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square)](https://github.com/is-pinoy-dev/domains/pulls)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Community](https://img.shields.io/badge/community-discord-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.com/channels/1507758007218471062/1507758194624299039)

</div>

> **Note:** We are currently only accepting **portfolio websites** for the meantime. Side projects and other use cases will be open in the future.

---

## 🚀 Register a Subdomain

1. **Fork** this repository
2. **Find your DNS values** — see the [provider guides](#-provider-guides)
3. **Create** a file at `subdomains/<your-subdomain>.json`
4. **Validate** your file before opening a PR:
   ```bash
   npx @is-pinoy-dev/validate ./subdomains/<your-subdomain>.json
   ```
5. **Open a pull request** — your subdomain is live once it's merged and synced 🎉

For the full step-by-step walkthrough including the PR template, see [CONTRIBUTING.md](CONTRIBUTING.md).

> **Not sure where to find your CNAME or TXT values?** See the [provider guides](#-provider-guides) below.

> 💬 **Want a faster review?** Post your PR link in our [Discord](https://discord.com/channels/1507758007218471062/1507758194624299039) and a maintainer will pick it up sooner.

---

## 📄 JSON Format

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

---

## 🌐 Supported Records

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

---

## 📋 Rules

- Subdomain must be lowercase alphanumeric and hyphens only (`a-z`, `0-9`, `-`)
- Length: 1–63 characters
- One subdomain per person
- Must be a **portfolio website** (side projects and other use cases are not accepted for now)
- Must point to something real — no squatting
- `owner.github` must match your GitHub username

---

## 🗺️ Provider Guides

Step-by-step instructions for finding your DNS values on popular hosting platforms:

- [Vercel](docs/providers/vercel.md)

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

Please also read our [Code of Conduct](CODE_OF_CONDUCT.md) before getting started.

---

<div align="center">

Made with 🤍 by Filipino developers, for Filipino developers.

**[is-pinoy.dev](https://is-pinoy.dev)**

</div>
