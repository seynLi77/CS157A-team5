// ==========================================================================
// LockedIn — Home Page Interactions
// Everything here is intentionally "dummy": buttons/search have hover and
// focus states but don't navigate or filter anything real.
// ==========================================================================

document.addEventListener('DOMContentLoaded', function () {

  // -------------------------------------------------------------
  // Typewriter placeholder animation on the search bar
  // -------------------------------------------------------------
  var examples = [
    'Software Engineer Intern',
    'Remote Data Analyst',
    'Product Designer, New Grad',
    'Part-time jobs for students',
    'Backend Developer, Entry Level'
  ];

  var placeholderEl = document.getElementById('search-placeholder-anim');
  var searchInput = document.getElementById('search-input');

  if (placeholderEl) {
    var exampleIndex = 0;
    var charIndex = 0;
    var deleting = false;
    var typeSpeed = 55;
    var deleteSpeed = 30;
    var pauseAtFull = 1400;
    var pauseAtEmpty = 400;

    function tick() {
      var current = examples[exampleIndex];

      if (!deleting) {
        charIndex++;
        placeholderEl.textContent = current.slice(0, charIndex);

        if (charIndex === current.length) {
          deleting = true;
          setTimeout(tick, pauseAtFull);
          return;
        }
        setTimeout(tick, typeSpeed);
      } else {
        charIndex--;
        placeholderEl.textContent = current.slice(0, charIndex);

        if (charIndex === 0) {
          deleting = false;
          exampleIndex = (exampleIndex + 1) % examples.length;
          setTimeout(tick, pauseAtEmpty);
          return;
        }
        setTimeout(tick, deleteSpeed);
      }
    }

    tick();
  }

  // Track whether the real input has a value, so the animated
  // placeholder hides behind whatever the user actually types.
  if (searchInput) {
    searchInput.addEventListener('input', function () {
      if (searchInput.value.length > 0) {
        searchInput.classList.add('has-value');
      } else {
        searchInput.classList.remove('has-value');
      }
    });
  }

  // Dummy search submit — does nothing but doesn't error either
  var searchForm = document.getElementById('dummy-search-form');
  if (searchForm) {
    searchForm.addEventListener('submit', function (e) {
      e.preventDefault();
    });
  }

  // -------------------------------------------------------------
  // Dummy tag filter buttons — toggle visual state only
  // -------------------------------------------------------------
  var tagButtons = document.querySelectorAll('.tag-btn');
  tagButtons.forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      e.preventDefault();
      btn.classList.toggle('active');
    });
  });

  // -------------------------------------------------------------
  // Dummy CTA buttons (log in / sign up / explore) — hover state
  // only, intentionally don't navigate anywhere yet
  // -------------------------------------------------------------
  var dummyButtons = document.querySelectorAll('[data-dummy-link]');
  dummyButtons.forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      e.preventDefault();
    });
  });

});