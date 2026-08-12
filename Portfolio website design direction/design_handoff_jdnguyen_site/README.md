# Handoff: jdnguyen.tech portfolio and freelance landing

## Overview
A four-page personal site for Jonathan Nguyen: portfolio plus landing page for freelance web
development aimed at small businesses. Pages: Home, Work, About, Contact. The design leads with
credibility (Navy IT, Disney show systems, Security+ and AWS Solutions Architect) rather than with
a client list, because there is not a public one yet.

Priority when the two jobs conflict: win small-business clients first, impress developers second.

## About the design files
The files in this bundle are **design references created in HTML**. They are prototypes showing
intended look, copy and behavior, not production code to lift wholesale. `jonathan-nguyen-site.dc.html`
in particular is authored in a proprietary component runtime (`<x-dc>`, `<sc-if>`, `<sc-for>`,
`{{ }}` holes, `support.js`) that will not exist in the target codebase.

The task is to **recreate this design in the target environment** (React/Next.js, Astro, whatever the
repo already uses) with that repo's own patterns. Two things port directly and should be reused
verbatim: `_ds/modernist-.../styles.css` (the token sheet and component classes) and the copy.

## Fidelity
**High fidelity.** Final colors, type, spacing, copy and interaction states. Recreate it closely.
Everything visual comes from the Modernist design system's CSS custom properties, so port the
stylesheet first and the rest follows.

## Design system
Modernist: flat, architectural, set entirely in Archivo. Near-mono accent on a light ground (the system ships red #ec3013; this design overrides it to blue #0b5fd0),
visible modular grid, **zero corner radius anywhere**, strong 2px dividers, everything flush left
(including labels inside buttons), photography in pure black and white via the `.grayscale` wrapper.

Rules that are easy to break by accident:
- Do not round a corner. `--radius-*` is 0 on purpose.
- Do not center headings, hero copy or button labels.
- Do not soften the 2px rules into hairlines.
- Do not tint imagery. Grayscale only.
- The accent is for the primary action, small emphasis, and the one full-bleed closing banner.
- Body-size text in the accent uses `--color-accent-700`, never `--color-accent` (contrast).

## Design tokens
From `_ds/modernist-8962f109-2fcd-48d3-ab56-0c7fad438113/styles.css`. Take them from that file
rather than retyping.

Light ground
- `--color-bg` #f3f2f2
- `--color-surface` #eae9e9
- `--color-text` #201e1d
- `--color-accent` #0b5fd0 (the design overrides the system's red with a blue of the same weight)
- `--color-divider` color-mix(in srgb, #201e1d 40%, transparent)
- Accent ramp (overridden): 100 #eef4ff, 200 #d9e6ff, 300 #bcd2ff, 400 #85adff, 500 #3d82f5,
  600 #1a5fd6, 700 #0b47a8, 800 #063077, 900 #10254d. `--color-accent-2-*` is set to the same
  values, since the system is mono and treats both as one role. The overrides live in the page's
  own `:root` block, not in `styles.css`, so the design system file stays pristine.
- Neutral ramp: 100 #f8f4f4 through 900 #2d2b2b

Dark ground (added by this design, not in the system sheet; applied on `html[data-theme="dark"]`)
- `--color-bg` #1a1918
- `--color-surface` #262423
- `--color-text` #f3f2f2
- `--color-divider` color-mix(in srgb, #f3f2f2 35%, transparent)
- `--color-accent-700` remapped to #85adff so small accent text stays legible
- `--color-paper` #f3f2f2 is a mode-independent token, defined once on `:root`, used so the accent
  closing banner keeps paper-white type in both modes instead of flipping to near-black

Type: Archivo for headings and body. `--font-heading-weight` 800.
Spacing: 4 / 8 / 12 / 16 / 24 / 32px (`--space-1..8`).
Radius: 0 at every step.
Shadows: `--shadow-sm/md/lg` exist but this design uses none. Nothing floats.

Type scale as used in the page
- h1 hero: clamp(42px, 6.2vw, 84px), weight 800, line-height 1.06, letter-spacing -0.02em,
  negative left margin -0.058em for optical flush-left alignment
- h1 secondary pages: clamp(38px, 5vw, 68px), same treatment
- Section h2: 32px / 42px, letter-spacing -0.015em
- Row h2 and card h3: 24px / 28px, letter-spacing -0.01em
- Stat figure: clamp(34px, 3.4vw, 48px) / 56px, weight 800, color `--color-accent`
- Lead paragraph: 17px / 28px, max-width 58-60ch
- Body: 15.5px / 28px, max-width 52ch, color color-mix(in srgb, var(--color-text) 78%, transparent)
- Eyebrow/label: 13px / 14px, letter-spacing 0.08em, uppercase; accent-700 for section kickers,
  70% text for captions

## Layout
- Container: max-width 1200px, centered, padding-inline clamp(20px, 5vw, 72px)
- Sections separated by `<hr>` at height 2px, `--color-divider`, no margin
- Section padding: 84px top / 70px bottom for interior sections, 112px for page-opening sections
- Three repeating grid patterns, defined as classes because they need media queries:
  - `.statrow` — repeat(auto-fit, minmax(140px, 1fr)), gap 42px / clamp(24px,4vw,56px)
  - `.rowgrid` — numbered rows. Single column under 900px with the numeral hidden;
    at 900px+ becomes `64px repeat(auto-fit, minmax(300px, 1fr))`
  - `.split` — asymmetric two-column. Single column under 900px; at 900px+ takes its ratio from a
    `--split` custom property set inline per instance (5fr/7fr on Home, 7fr/5fr on About, 1fr/1fr
    on Contact)
- Breakpoint: one, at 900px. Everything is single column below it and the nav wraps.

## Screens

### Home
Purpose: convince a small-business owner to make contact.
1. Hero. h1 "From the wire / to the web." on two lines, lead paragraph, primary button
   "Start a project" and ghost button "See the work".
2. Stat row, four cells: **10 yr** / Navy IT and secure networks; **Disney** / Show systems
   engineering; **AWS SA** / Solutions Architect, plus Security+; **1** / Person, start to finish.
   Figures in the accent.
3. "What I do", three numbered rows (01/02/03): Websites and front-end applications; Networks and
   infrastructure; Hosting, security and upkeep. Each has a body paragraph and an optional
   uppercase pricing line in accent-700 (currently qualitative, no numbers).
4. Split section, "Why it matters to you" / "Most developers stop at the code", two paragraphs and
   a primary button.
5. Full-bleed accent closing banner ( `--color-accent` background, paper-white type): heading,
   paragraph, ghost "Book a call" button and a mailto link styled as a ghost button.
6. Footer: name line, email and GitHub links.

### Work
Purpose: substitute credibility for a client list without apologising for the lack of one.
1. Page title and intro.
2. "Selected engagements", three columns, no images: The Walt Disney Company (show systems for
   Galaxy's Edge and Runaway Railway); United States Navy (a decade of secure IT networks);
   Built and run myself (Git on Synology NAS, ZeroTier, Docker, Unifi controllers).
3. "How a project runs", four numbered rows: conversation, fixed quote and date, build in the open,
   handover.

### About
Purpose: the person behind the work.
Split hero, four biography paragraphs beside a 4:5 grayscale portrait, then "What I work with" in
four columns: Front end; Networks; Servers and deployment; Security and cloud.

### Contact
Purpose: capture an enquiry.
Two columns. Left: heading, lead, "Or just email me" -> hello@jdnguyen.tech, "Or look at the code"
-> github.com/jonathan-d-nguyen, plus a one-working-day response promise. Right: form with fields
Your name, Business, Email, What you need (textarea, 5 rows), and a primary "Send it" button.
The accent closing banner is suppressed on this page.

## Interactions and behavior
- **Navigation**: four in-page views switched by client state in the prototype. In production make
  these **real routes** (`/`, `/work`, `/about`, `/contact`) for SEO and shareable links. Scroll
  resets to top on change. The active item shows an 8x8px solid accent square before its label.
- **Theme toggle**: Light / Dark / Auto in the nav, active option marked with a 6x6px accent square.
  Writes `data-theme` on `<html>`, persists to `localStorage` under key `jn-theme`, defaults to
  `system`. Auto follows `prefers-color-scheme`. The prototype sets the attribute from a blocking inline
  script that runs before render; keep that pattern in `<head>` in production, ahead of the
  stylesheet, or dark-mode visitors get a white flash on every page load.
- **Hover / active / focus**: inherited from the design system. Do not restyle. Focus is a 2px
  accent `:focus-visible` outline with 2px offset.
- **Form**: static in the prototype. Needs real submission, validation and a success/error state.
- **No animation anywhere.** The system does not want it.

## State
- `page`: 'home' | 'work' | 'about' | 'contact' (replace with the router)
- `theme`: 'light' | 'dark' | 'system', persisted to localStorage
- Prototype prop worth keeping as a content flag: `showPricing` (boolean, shows the pricing lines
  under each service on Home)

## Assets
None shipped. One image placeholder to fill:
- About portrait, 4:5, wrapped in `.grayscale`
Icons: the system specifies Lucide. The current design uses no icons.
Font: Archivo. Self-host it rather than hotlinking, given the stack below.

## Copy
Take the copy verbatim from the prototype. It was written in Jonathan's voice across several passes:
dry, understated, operational, no em dashes anywhere (deliberate). Do not "improve" it and do not
reintroduce em dashes.

## Stack notes for this deployment
Cloudflare DNS, AWS hosting, Terraform, Claude Code.
- Four pages of mostly static content. A static site generator (Astro, Next.js static export,
  or plain HTML with a build step) is the right weight. Nothing here needs a server at request time
  except the contact form.
- Contact form: a small serverless function (Lambda + API Gateway, or Cloudflare Worker) posting to
  SES or an email API. Keep the endpoint in Terraform alongside the rest.
- The site sells the developer's infrastructure competence, so the deployment is part of the
  portfolio: Lighthouse near 100, correct cache headers, SPF/DKIM/DMARC configured on the domain,
  HTTPS and HSTS. The About page claims "email that does not land in spam." Make that true for
  jdnguyen.tech first.
- The GitHub link is a load-bearing part of the pitch. The repo for this site should be public and
  tidy, since prospective clients and developers will both click it.

## Files in this bundle
- `jonathan-nguyen-site.dc.html` — the full four-page design (component-runtime HTML, reference only)
- `styles.css` — the Modernist token sheet and component classes. **Port this.**
- `modernist-readme.md` — the design system's own guide, including rules and component list
- `image-slot.js` — the drag-and-drop image placeholder used by the prototype. Not needed in production.
- `screenshots/` — the four pages plus Home in dark mode, captured at desktop width. Reference only,
  and stale the moment the design changes. Trust the HTML over these.
