/* form.js — progressive enhancement for the contact form.
   The form is a real <form> with native required/validation, so it degrades to
   a plain mailto fallback with no JS. With JS, it posts JSON to CONTACT_ENDPOINT
   and shows an inline success/error state. Wire CONTACT_ENDPOINT to the
   serverless contact function (Lambda + API Gateway or a Cloudflare Worker) when
   it exists; until then the form points people at the mailto. */
(function () {
  // Set after deploying the Cloudflare Worker in workers/contact/ — either
  // 'https://api.jdnguyen.tech/contact' or the printed *.workers.dev URL.
  // While empty, the form falls back to the mailto message below.
  var CONTACT_ENDPOINT = '';

  var form = document.getElementById('jn-form');
  if (!form) return;
  var status = document.getElementById('jn-form-status');

  function show(msg, ok) {
    status.textContent = msg;
    status.style.color = ok
      ? 'var(--color-text)'
      : 'var(--color-accent-700)';
    status.hidden = false;
  }

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    if (!form.checkValidity()) { form.reportValidity(); return; }

    var payload = {};
    new FormData(form).forEach(function (value, key) { payload[key] = value; });

    if (!CONTACT_ENDPOINT) {
      show('The form is not wired to a mailbox yet. Email hello@jdnguyen.tech directly and I will reply within one working day.', false);
      return;
    }

    var btn = form.querySelector('button[type="submit"]');
    btn.disabled = true;
    fetch(CONTACT_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })
      .then(function (r) {
        if (!r.ok) throw new Error('bad status');
        show('Thanks. I will reply within one working day.', true);
        form.reset();
      })
      .catch(function () {
        show('Something went wrong sending that. Email hello@jdnguyen.tech instead and it will still reach me.', false);
      })
      .then(function () { btn.disabled = false; });
  });
})();
