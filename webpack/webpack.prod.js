const path = require("path");
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')

module.exports = {
  entry: path.resolve(__dirname, "../src/main.js"),
  mode: "production",
  output: {
    path: path.resolve(__dirname, "../dist"),
    filename: "graphqlx.js",
    library: "graphqlx",
    libraryTarget: "umd"
  },
  target: "node",
  plugins: [
    new UglifyJsPlugin({
      sourceMap: true,
      parallel: true,
      uglifyOptions: {
        compress: {
          drop_console: true,
        }
      }
    })
  ]
};