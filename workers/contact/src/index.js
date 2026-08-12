/* Cloudflare Worker — contact form handler for jdnguyen.tech.
 *
 * Accepts a JSON POST from the site's contact form, validates it, drops
 * obvious bots (honeypot + basic checks), and emails the enquiry via Resend so
 * it is DKIM-signed from the domain and stays out of spam. Returns JSON.
 *
 * Secrets / vars (set with `wrangler secret put` or in the dashboard):
 *   RESEND_API_KEY  — Resend API key (secret)
 *   TO_EMAIL        — where enquiries land (e.g. hello@jdnguyen.tech)
 *   FROM_EMAIL      — verified sender on the domain (e.g. site@jdnguyen.tech)
 *   ALLOW_ORIGIN    — the site origin allowed to call this (e.g. https://www.jdnguyen.tech)
 */

function cors(origin) {
  return {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '86400',
    'Vary': 'Origin',
  };
}

function json(body, status, headers) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...headers },
  });
}

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default {
  async fetch(request, env) {
    const allow = env.ALLOW_ORIGIN || '*';
    const headers = cors(allow);

    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers });
    }
    if (request.method !== 'POST') {
      return json({ error: 'Method not allowed' }, 405, headers);
    }

    let data;
    try {
      data = await request.json();
    } catch (e) {
      return json({ error: 'Invalid JSON' }, 400, headers);
    }

    // Honeypot: real users leave this hidden field empty.
    if (data.company_website) {
      return json({ ok: true }, 200, headers); // silently accept, drop
    }

    const name = (data.name || '').toString().trim();
    const email = (data.email || '').toString().trim();
    const business = (data.business || '').toString().trim();
    const message = (data.message || '').toString().trim();

    if (!name || !EMAIL_RE.test(email) || !message) {
      return json({ error: 'Please provide your name, a valid email, and a message.' }, 422, headers);
    }
    if (name.length > 200 || email.length > 200 || business.length > 200 || message.length > 5000) {
      return json({ error: 'One of the fields is too long.' }, 422, headers);
    }

    const text =
      `New enquiry from jdnguyen.tech\n\n` +
      `Name:     ${name}\n` +
      `Business: ${business || '(not given)'}\n` +
      `Email:    ${email}\n\n` +
      `${message}\n`;

    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${env.RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: `jdnguyen.tech <${env.FROM_EMAIL}>`,
        to: [env.TO_EMAIL],
        reply_to: email,
        subject: `New enquiry: ${name}${business ? ' — ' + business : ''}`,
        text,
      }),
    });

    if (!res.ok) {
      return json({ error: 'Could not send right now. Please email hello@jdnguyen.tech directly.' }, 502, headers);
    }

    return json({ ok: true }, 200, headers);
  },
};
