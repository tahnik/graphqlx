const path = require("path");

module.exports = {
  entry: path.resolve(__dirname, "../test/github.js"),
  mode: 'development',
  output: {
    path: path.resolve(__dirname, "../dist/test"),
    filename: "github.js"
  },
  target: "node"
};