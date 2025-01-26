// Check if the user is on a Mac and update the shortcut key for search accordingly
document.addEventListener("readystatechange", () => {
  if (document.readyState === "interactive") {
    let shortcutKeyElement = document.querySelector("#search-toggle .nav-link");
    if (!shortcutKeyElement) return;
    shortcutKeyElement.style.minWidth = `${shortcutKeyElement.offsetWidth}px`;
    let isMac = navigator.platform.toUpperCase().indexOf("MAC") >= 0;
    const isMobile = /android|iphone|ipad|ipod|windows phone|mobile/i.test(navigator.userAgent);
    if (isMac) {
      // use the unicode for command key
      shortcutKeyElement.innerHTML = '&#x2318; K <i class="ti ti-search"></i>';
    } else if (isMobile) {
      shortcutKeyElement.innerHTML = '<i class="ti ti-search"></i>';
    }
  }
});
