/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["selector", '[data-theme="dark"]'],
  theme: {
    extend: {
      colors: {
        theme: "var(--global-theme-color)",
        text: "var(--global-text-color)",
        background: "var(--global-bg-color)",
        divider: "var(--global-divider-color)",
        card: "var(--global-card-bg-color)",
      },
    },
  },
  plugins: [],
};
