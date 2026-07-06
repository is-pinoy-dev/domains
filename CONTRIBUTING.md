# Contributing

Thanks for wanting to register a subdomain! This guide walks you through the entire process — from forking the repository to getting your PR merged.

---

## Registering a Subdomain

### Step 1: Fork the repository

1. Go to [github.com/is-pinoy-dev/domains](https://github.com/is-pinoy-dev/domains)
2. Click the **Fork** button in the top-right corner
3. Select your GitHub account as the destination

You now have your own copy of the repository at `https://github.com/your-username/domains`.

---

### Step 2: Clone your fork

```bash
git clone https://github.com/your-username/domains.git
cd domains
```

---

### Step 3: Find your DNS values

Before creating your JSON file, you need the CNAME (and optionally TXT) record values from your hosting provider.

**Not sure where to find them?** Follow the guide for your platform:

- [Vercel](docs/providers/vercel.md)
- [GitHub Pages](docs/providers/github-pages.md)

---

### Step 4: Create your subdomain file

Create a new file at `subdomains/<your-subdomain>.json`. The filename must exactly match the `subdomain` field inside the file.

```bash
# Example: registering "yourname.is-pinoy.dev"
touch subdomains/yourname.json
```

Fill it in using the following format:

```json
{
  "$schema": "https://raw.githubusercontent.com/is-pinoy-dev/ecosystem/main/packages/schemas/schema/v1/subdomain.schema.json",
  "subdomain": "yourname",
  "owner": {
    "github": "your-github-username"
  },
  "records": {
    "CNAME": {
      "value": "xxxxxxxxxxxxxxxx.vercel-dns-017.com."
    }
  }
}
```

If your provider also gave you a TXT verification record, include it too:

```json
{
  "$schema": "https://raw.githubusercontent.com/is-pinoy-dev/ecosystem/main/packages/schemas/schema/v1/subdomain.schema.json",
  "subdomain": "yourname",
  "owner": {
    "github": "your-github-username"
  },
  "records": {
    "CNAME": {
      "value": "xxxxxxxxxxxxxxxx.vercel-dns-017.com."
    },
    "TXT": {
      "value": "vc-domain-verify=yourname.is-pinoy.dev,<hash>",
      "provider": "vercel"
    }
  }
}
```

**Things to double-check:**
- The filename (`yourname.json`) matches the `subdomain` field (`"yourname"`)
- `owner.github` matches your GitHub username exactly
- The CNAME value ends with a trailing dot (`.`)

---

### Step 5: Validate your file locally

Run the validator to catch any errors before opening a PR:

```bash
npx @is-pinoy-dev/validate ./subdomains/yourname.json
```

Fix any errors it reports before continuing.

---

### Step 6: Commit and push

```bash
git add subdomains/yourname.json
git commit -m "Add yourname.is-pinoy.dev"
git push origin main
```

---

### Step 7: Open a pull request

1. Go to your fork on GitHub: `https://github.com/your-username/domains`
2. Click the **Compare & pull request** button (GitHub shows this automatically after a push)
3. Make sure the base repository is `is-pinoy-dev/domains` and the base branch is `main`
4. Fill in the PR using the template below

#### PR title

```
Add yourname.is-pinoy.dev
```

#### PR body template

```
## Subdomain Registration

**Subdomain:** `yourname.is-pinoy.dev`

### Website Screenshot

<!-- Attach a screenshot of your portfolio website here -->

### Technical Checklist

- [x] Filename and `subdomain` field in JSON both match your subdomain
- [x] `owner.github` matches my GitHub username
- [x] At least one valid record (`CNAME`, `A`, or `TXT`)
- [x] CNAME value ends with a trailing dot (e.g. `yoursite.vercel.app.`)
- [x] The subdomain points to something real and active

### Terms

- [x] My subdomain points to a **portfolio website**
- [x] I agree to the Terms of Service
- [x] I have read and understood the Privacy Policy
- [x] I have read the contributing guidelines
```

5. Click **Create pull request**

> **Want a faster review?** Post your PR link in our [Discord](https://discord.com/channels/1507758007218471062/1507758194624299039) and a maintainer will pick it up sooner.

---

### Step 8: Wait for CI and review

After you open the PR:

- **CI runs automatically** — it validates your JSON file and checks that `owner.github` matches your GitHub username. If it fails, read the error comment on the PR and push a fix.
- **A maintainer reviews** — once CI passes, a maintainer will review and merge your PR.
- **DNS goes live** — after merge, your subdomain is synced to Cloudflare. Propagation usually takes a few minutes but can take up to 48 hours.

---

## Naming Rules

- Lowercase alphanumeric and hyphens only: `a-z`, `0-9`, `-`
- Between 1 and 63 characters
- No leading or trailing hyphens

## What Gets Rejected

- **Not a portfolio** — only portfolio websites are accepted for now
- **Squatting** — registering a subdomain you don't intend to use
- **Impersonation** — using someone else's name or brand
- **Invalid records** — values that don't pass schema validation
- **Mismatched owner** — `owner.github` must match the GitHub account opening the PR
- **Reserved names** — certain subdomains are reserved by maintainers

## Reporting Issues

Open a GitHub issue for bugs, questions, or requests to update or remove a subdomain.
