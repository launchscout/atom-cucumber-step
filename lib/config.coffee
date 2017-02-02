module.exports =
  searchPaths:
    description: "For looking up Cucumber step definition files (comma-separated list of glob patters)"
    type: "array"
    default: [
      "*.js",
      "*.rb",
    ]
    items:
      type: "string"
