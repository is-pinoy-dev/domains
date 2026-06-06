# Deploying with Vercel

This guide walks you through finding the DNS values you need to register a `*.is-pinoy.dev` subdomain for a portfolio hosted on Vercel.

## Prerequisites

- Your portfolio is already deployed to Vercel
- You have chosen a subdomain (e.g. `yourname.is-pinoy.dev`)

---

## Step 1: Open your project's Domain settings

1. Go to [vercel.com/dashboard](https://vercel.com/dashboard) and sign in
2. Click on your portfolio project
3. Click the **Settings** tab at the top
4. In the left sidebar, click **Domains**

---

## Step 2: Add your is-pinoy.dev subdomain

1. In the domain input field, type your full subdomain: `yourname.is-pinoy.dev`
2. Click **Add**

Vercel will display a panel showing the DNS records you need to configure.

---

## Step 3: Copy your CNAME value

Vercel will show a **CNAME** record that looks like this:

```
xxxxxxxxxxxxxxxx.vercel-dns-017.com.
```

This value is unique to your project. Copy it exactly — you'll paste it into your JSON file.

> The value always ends with a dot (`.`). Make sure to include it when filling in your JSON.

---

## Step 4: Copy your TXT verification value (if shown)

Vercel sometimes also shows a **TXT** record for domain verification:

```
vc-domain-verify=yourname.is-pinoy.dev,<hash>
```

If Vercel shows this record, copy the full value. If it doesn't appear, you can skip this step.

---

## Step 5: Create your subdomain JSON file

Create a file at `subdomains/yourname.json` in your fork of the repository.

### CNAME only (most common)

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

### CNAME + TXT verification

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

Replace `yourname`, `your-github-username`, and the record values with your actual information.

---

## Important notes

- **Trailing dot** — the CNAME value must end with a `.` (e.g. `xxxxxxxxxxxxxxxx.vercel-dns-017.com.`). Vercel shows it this way; keep it as-is.
- **`"provider": "vercel"`** — required whenever you include a TXT record from Vercel. The field will fail validation without it.
- **Vercel will show "Invalid Configuration"** on its dashboard until your PR is merged and DNS has propagated. This is expected — Vercel can't verify the record until it's live.
- **DNS propagation** takes a few minutes after merge but can take up to 48 hours depending on your DNS resolver.

---

## Next steps

Once your JSON file is ready, follow the main [registration steps](../../README.md#register-a-subdomain) to open a pull request.
