function initBackToTop(selector = "#backToTop", threshold = 100) {
  const backToTop = document.querySelector(selector);
  if (!backToTop) return function () {};

  const toggleBackToTop = () => {
    if (document.body.scrollHeight <= window.innerHeight) {
      backToTop.parentElement.style.display = "none";
      return;
    }
    backToTop.parentElement.style.display = window.scrollY > threshold ? "flex" : "none";
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
