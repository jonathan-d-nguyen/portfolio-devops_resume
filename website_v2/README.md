# jdnguyen.tech — Modernist site (v2)

Four-page static site recreated from the prototype in the repo's existing
zero-build style: plain HTML, one ported stylesheet, a little vanilla JS. No
framework, no build step. Deploys by syncing this folder to S3 + CloudFront.

**Authoritative design source:**
`Portfolio website design direction/design_handoff_jdnguyen_site/jonathan-nguyen-site.dc.html`
(there is an older sibling bundle `design_handoff_jdnguyen_site 2/` that is RED —
do not use it). The design system is Modernist, but the **accent is blue
(`#0b5fd0`)**, remapped from the sheet's default red via `:root` overrides in
`assets/site.css`. `assets/styles.css` is the ported design-system sheet and
still carries the original red ramp; the site.css overrides win.

## Structure

```
website_v2/
  index.html          # Home
  work/index.html      # Work        -> /work/
  about/index.html     # About       -> /about/
  contact/index.html   # Contact     -> /contact/
  assets/
    styles.css         # Modernist design-system sheet, ported verbatim
    site.css           # dark theme, grid patterns, nav/container helpers
    theme.js           # Light/Dark/Auto toggle (persists to localStorage)
    form.js            # contact form progressive enhancement
```

Asset and nav links are root-absolute (`/assets/...`, `/work/`), so preview with
a local server from this directory, not `file://`:

```bash
cd website_v2 && python3 -m http.server 8000   # then open http://localhost:8000/
```

## Design fidelity

- Copy is verbatim from the prototype (no em dashes, by design — do not add any).
- Zero corner radius, 2px dividers, flush-left everything, grayscale imagery only.
- Dark mode via `data-theme` set by a blocking inline script in each `<head>`,
  ahead of the stylesheet, to avoid a white flash. Default `system`.

## Known follow-ups (not blocking review)

- **Contact backend**: `form.js` posts to `CONTACT_ENDPOINT` (currently empty →
  falls back to the mailto). Wire it to a Lambda + API Gateway or Cloudflare
  Worker → SES, kept in Terraform. SPF/DKIM/DMARC on jdnguyen.tech.
- **Fonts**: `styles.css` hotlinks Archivo from Google Fonts. Self-host for
  Lighthouse and privacy.
- **Images**: About portrait (4:5) and case-study thumbnails (4:3) are flat
  `.imgslot` placeholders. Drop real grayscale images in when available.
- **Booking**: "Book a call" / "Book the call" redirect to
  https://cal.com/jonathan-nguyen/qc (new tab). No embed, to protect Lighthouse.
- **Deploy swap**: point `scripts/deploy_website.sh` at this folder once approved.
