/* theme.js — wires the Light / Dark / Auto toggle in the nav.
   A blocking inline script in each page's <head> already sets data-theme before
   first paint (so dark-mode visitors get no white flash); this deferred script
   only marks the active option and handles clicks. Persists to localStorage
   under 'jn-theme', defaulting to 'system'. No framework, no animation. */
(function () {
  var VALID = ['light', 'dark', 'system'];

  function current() {
    try {
      var t = localStorage.getItem('jn-theme');
      return VALID.indexOf(t) >= 0 ? t : 'system';
    } catch (e) {
      return 'system';
    }
  }

  function apply(theme) {
    document.documentElement.dataset.theme = theme;
    var buttons = document.querySelectorAll('[data-theme-set]');
    for (var i = 0; i < buttons.length; i++) {
      var btn = buttons[i];
      var active = btn.getAttribute('data-theme-set') === theme;
      btn.setAttribute('aria-pressed', active ? 'true' : 'false');
      var sq = btn.querySelector('.square6');
      if (active && !sq) {
        sq = document.createElement('span');
        sq.className = 'square6';
        btn.insertBefore(sq, btn.firstChild);
      } else if (!active && sq) {
        sq.parentNode.removeChild(sq);
      }
    }
  }

  function set(theme) {
    try { localStorage.setItem('jn-theme', theme); } catch (e) {}
    apply(theme);
  }

  document.addEventListener('click', function (e) {
    var btn = e.target.closest ? e.target.closest('[data-theme-set]') : null;
    if (!btn) return;
    set(btn.getAttribute('data-theme-set'));
  });

  apply(current());
})();
