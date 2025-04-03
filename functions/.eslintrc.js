module.exports = {
  env: {
    es6: true,
    node: true,
  },
  extends: ["eslint:recommended"],
  rules: {
    quotes: ["error", "double"],
    "max-len": ["warn", {code: 120}],
    "no-unused-vars": "warn",
    "object-curly-spacing": ["error", "never"],
    "comma-dangle": ["error", "always-multiline"],
    indent: ["error", 2],
    "valid-jsdoc": "off",
  },
  parserOptions: {
    ecmaVersion: 2020,
  },
}; 