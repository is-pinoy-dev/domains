# Deploying with GitHub Pages

This guide walks you through registering a `*.is-pinoy.dev` subdomain for a site hosted on GitHub Pages, and configuring GitHub Pages so it serves a valid HTTPS certificate for your subdomain.

## Prerequisites

- Your site is already deployed to GitHub Pages (e.g. `https://your-github-username.github.io`)
- You have chosen a subdomain (e.g. `yourname.is-pinoy.dev`)

---

## Step 1: Find your CNAME value

Your CNAME value is your GitHub Pages hostname:

```
your-github-username.github.io
```

This is the same value for both user sites (`your-github-username.github.io`) and project sites (`your-github-username.github.io/my-project`) — the repository path is never part of the CNAME.

---

## Step 2: Create your subdomain JSON file

Create a file at `subdomains/yourname.json` in your fork of the repository:

```json
{
  "$schema": "https://raw.githubusercontent.com/is-pinoy-dev/ecosystem/main/packages/schemas/schema/v1/subdomain.schema.json",
  "subdomain": "yourname",
  "owner": {
    "github": "your-github-username"
  },
  "records": {
    "CNAME": {
      "value": "your-github-username.github.io"
    }
  }
}
```

Replace `yourname` and `your-github-username` with your actual information, then follow the main [registration steps](../../README.md#register-a-subdomain) to open a pull request.

> Do **not** set `"proxied": true` for GitHub Pages. The record must stay DNS-only so GitHub can verify your domain and issue the HTTPS certificate.

---

## Step 3: Add the custom domain in your Pages settings

Do this **after your PR is merged** and the DNS record is live.

1. Go to the repository that serves your Pages site (e.g. `your-github-username.github.io`)
2. Click **Settings**, then **Pages** in the left sidebar
3. Under **Custom domain**, enter your full subdomain: `yourname.is-pinoy.dev`
4. Click **Save**

GitHub will run a DNS check and then start provisioning a TLS certificate for your subdomain.

> **This step is required.** Until you add the custom domain here, GitHub serves its default `*.github.io` certificate for your subdomain, and browsers will show an **invalid certificate** error when visiting `https://yourname.is-pinoy.dev`.

---

## Step 4: Wait for the certificate to be provisioned

After saving the custom domain, the Pages settings page shows the certificate status (e.g. "TLS certificate is being provisioned"). This usually completes within an hour, but can take up to 24 hours.

If it seems stuck after 24 hours, remove the custom domain, save, then add it back — this re-triggers provisioning.

---

## Step 5: Enable "Enforce HTTPS"

Once the certificate is issued, the **Enforce HTTPS** checkbox in **Settings → Pages** becomes clickable (it stays greyed out while the certificate is provisioning).

Tick it. This makes GitHub redirect all `http://` visitors to `https://` automatically.

---

## Important notes

- **The order matters** — the DNS record (your merged PR) must be live *before* GitHub can verify the custom domain and issue a certificate. If you added the custom domain before your PR was merged, remove it and add it again.
- **Invalid certificate errors** on `https://yourname.is-pinoy.dev` almost always mean the custom domain hasn't been added in your Pages settings yet (Step 3), or the certificate is still provisioning (Step 4).
- **A `CNAME` file appears in your repository** — GitHub commits a file named `CNAME` containing your subdomain to the branch that serves your site. This is normal; don't delete it. If you deploy with a GitHub Actions workflow or a static site generator, make sure your build doesn't wipe it out (for Jekyll it's preserved automatically; for other setups keep a `CNAME` file in your output directory).
- **One custom domain per repository** — the custom domain applies to the specific repository serving the site. Project sites need their own custom domain configured in their own repository's Pages settings.
- **DNS propagation** takes a few minutes after merge but can take up to 48 hours depending on your DNS resolver.

---

## Next steps

Once your site loads at `https://yourname.is-pinoy.dev` with a valid certificate, you're done! See GitHub's own docs on [securing your site with HTTPS](https://docs.github.com/en/pages/getting-started-with-github-pages/securing-your-github-pages-site-with-https) if you run into trouble.
