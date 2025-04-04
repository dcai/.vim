export default {
  trailingComma: "all",
  tabWidth: 2,
  semi: true,
  endOfLine: "lf",
  singleQuote: false,
  jsxSingleQuote: false,
  printWidth: 80,
  useTabs: false,
  quoteProps: "preserve",
  overrides: [
    {
      files: ["*.json5", ".jsonc"],
      options: {
        parser: "json5",
        tabWidth: 2,
      },
    },
    {
      files: ["*.json", ".prettierrc"],
      options: {
        parser: "json",
        tabWidth: 2,
      },
    },
    {
      files: ["*.gql", "*.graphql"],
      options: {
        parser: "graphql",
        tabWidth: 2,
      },
    },
    {
      files: ["*.yaml", "*.yml"],
      options: {
        parser: "yaml",
        singleQuote: false,
        tabWidth: 2,
      },
    },
  ],
};
