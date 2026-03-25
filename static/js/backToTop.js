function initBackToTop(selector = "#backToTop", threshold = 100) {
  const backToTop = document.querySelector(selector);
  if (!backToTop) return function () {};
  const backToTopContainer = backToTop.parentElement;

  const toggleBackToTop = () => {
    if (!backToTopContainer) return;
    if (document.body.scrollHeight <= window.innerHeight) {
      backToTopContainer.style.display = "none";
      return;
    }
    backToTopContainer.style.display = window.scrollY > threshold ? "flex" : "none";
  };

  const handleBackToTop = () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  toggleBackToTop();
  window.addEventListener("scroll", toggleBackToTop);
  window.addEventListener("resize", toggleBackToTop);
  backToTop.addEventListener("click", handleBackToTop);

  return () => {
    window.removeEventListener("scroll", toggleBackToTop);
    window.removeEventListener("resize", toggleBackToTop);
    backToTop.removeEventListener("click", handleBackToTop);
  };
}

document.addEventListener("DOMContentLoaded", () => {
  initBackToTop();
});
