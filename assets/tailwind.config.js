const plugin = require("tailwindcss/plugin");

module.exports = {
  purge: {
    mode: "all",
    content: [
      "**/*.html.eex",
      "**/*.html.leex",
      "**/views/**/*.ex",
      "**/live/**/*.ex",
      "**/js/**/*.js",
    ],
    options: {
      whitelist: ["mode-dark"],
    },
  },
  theme: {
    extend: {

    },
  },
  variants: {},
  plugins: [],
};