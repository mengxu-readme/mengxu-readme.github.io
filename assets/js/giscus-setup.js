function determineGiscusTheme() {
  
    let theme =
      localStorage.getItem("theme") ||
      document.documentElement.getAttribute("data-theme") ||
      "system";

    if (theme === "dark") return "";
    if (theme === "light") return "";

    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    return prefersDark ? "" : "";
  
}

(function setupGiscus() {
  let giscusTheme = determineGiscusTheme();

  let giscusAttributes = {
    src: "https://giscus.app/client.js",
    "data-repo": "mengxu-readme/mengxu-readme.github.io",
    "data-repo-id": "",
    "data-category": "",
    "data-category-id": "",
    "data-mapping": "",
    "data-strict": "",
    "data-reactions-enabled": "",
    "data-emit-metadata": "",
    "data-input-position": "",
    "data-theme": giscusTheme,
    "data-lang": "",
    crossorigin: "anonymous",
    async: true,
  };

  let giscusScript = document.createElement("script");
  Object.entries(giscusAttributes).forEach(([key, value]) =>
    giscusScript.setAttribute(key, value)
  );
  document.getElementById("giscus_thread").appendChild(giscusScript);
})();

