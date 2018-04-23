const path = require("path");
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')

let clientConfig = {
  target: 'web',
  entry: path.resolve(__dirname, "../src/main.js"),
  mode: "production",
  output: {
    path: path.resolve(__dirname, "../dist"),
    filename: "graphqlx.js",
    library: "graphqlx",
    libraryTarget: "umd"
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['env'],
            plugins: ["transform-object-rest-spread"]
          }
        }
      }
    ]
  },
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


let serverConfig = {
  target: "node",
  entry: path.resolve(__dirname, "../src/main.js"),
  mode: "production",
  output: {
    path: path.resolve(__dirname, "../dist"),
    filename: "graphqlx.node.js",
    library: "graphqlx",
    libraryTarget: "umd"
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['env'],
            plugins: ["transform-object-rest-spread"]
          }
        }
      }
    ]
  },
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

module.exports = [ serverConfig, clientConfig ];