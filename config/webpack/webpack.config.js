const { generateWebpackConfig, merge } = require("shakapacker");
const webpack = require("webpack");

const webpackConfig = generateWebpackConfig();

const vegaLiteConfig = {
  resolve: {
    alias: {
      "vega-lite$": "vega-lite/build/vega-lite",
    },
  },
  module: {
    rules: [
      {
        test: /vega-lite\/build\/src\/index\.js$/,
        resolve: {
          fullySpecified: false,
        },
      },
    ],
  },
  plugins: [
    new webpack.DefinePlugin({
      global: "window",
    }),
  ],
};

module.exports = merge(webpackConfig, vegaLiteConfig);
