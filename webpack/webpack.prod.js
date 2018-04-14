const path = require("path");

module.exports = {
  entry: path.resolve(__dirname, "../src/main.js"),
  mode: 'development',
  output: {
    path: path.resolve(__dirname, "../dist"),
    filename: "graphqlx.js",
    library: "graphqlx",
    libraryTarget: "umd"
  },
  target: "node"
};