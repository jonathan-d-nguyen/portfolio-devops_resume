# Contact form Worker (jdnguyen.tech)

Cloudflare Worker that receives the contact form POST, validates + de-bots it,
and emails the enquiry via [Resend](https://resend.com) (DKIM-signed from the
domain so it doesn't land in spam). The Lambda + SES alternative is tracked in
beads.

## One-time setup

1. **Resend**: create an account, add and verify `jdnguyen.tech` (adds the DKIM
   records to Cloudflare DNS), and create an API key.
2. **Install tooling**: `npm i -g wrangler` and `wrangler login`.
3. **Set the secret**: `wrangler secret put RESEND_API_KEY` (paste the key).
4. Adjust `TO_EMAIL` / `FROM_EMAIL` / `ALLOW_ORIGIN` in `wrangler.toml` if needed.
   `FROM_EMAIL` must be on a Resend-verified domain.

## Deploy

```bash
cd workers/contact
wrangler deploy
```

`wrangler deploy` prints the Worker URL. Two ways to expose it:

- **Own hostname (recommended, works with the AWS/CloudFront origin):** create a
  proxied `api.jdnguyen.tech` record in Cloudflare, uncomment the `[[routes]]`
  block, redeploy. Endpoint → `https://api.jdnguyen.tech/contact`.
- **Quick start:** use the printed `https://jdnguyen-contact.<subdomain>.workers.dev`
  URL directly.

## Wire the site

Set `CONTACT_ENDPOINT` in `website_v2/assets/form.js` to that URL. CORS is
handled by the Worker via `ALLOW_ORIGIN`. Until it's set, the form falls back to
the mailto message — nothing breaks.

## Expected request

`POST` JSON: `{ name, business, email, message, company_website }`.
`company_website` is a honeypot — the form keeps it hidden and empty; anything
filling it is dropped.
