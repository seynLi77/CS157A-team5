// ==========================================================================
// LockedIn — Home Page Interactions
// The search bar and job category links navigate to the real /jobs page.
// Other promotional links are placeholders until those features are ready.
// ==========================================================================

document.addEventListener('DOMContentLoaded', function () {

  // -------------------------------------------------------------
  // Nav blends into hero on load, becomes solid once scrolled
  // -------------------------------------------------------------
  var navbar = document.querySelector('.navbar');
  if (navbar) {
    var scrollThreshold = 40;

    function updateNavState() {
      if (window.scrollY > scrollThreshold) {
        navbar.classList.add('scrolled');
      } else {
        navbar.classList.remove('scrolled');
      }
    }

    updateNavState();
    window.addEventListener('scroll', updateNavState, { passive: true });
  }

  // -------------------------------------------------------------
  // Mobile hamburger menu
  // -------------------------------------------------------------
  var hamburgerBtn = document.getElementById('hamburger-btn');
  var mobileMenu = document.getElementById('mobile-menu');
  if (hamburgerBtn && mobileMenu) {
    hamburgerBtn.addEventListener('click', function (e) {
      e.preventDefault();
      var isOpen = mobileMenu.classList.toggle('open');
      hamburgerBtn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    });

    mobileMenu.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        mobileMenu.classList.remove('open');
        hamburgerBtn.setAttribute('aria-expanded', 'false');
      });
    });
  }

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