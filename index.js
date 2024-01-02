document.addEventListener('DOMContentLoaded', function () {
    const burgerIcon = document.getElementById('navburger');
    const navbarMenu = document.getElementById('navMenu');
  
    burgerIcon.addEventListener('click', function () {
      navbarMenu.classList.toggle('is-active');
    });
  });  