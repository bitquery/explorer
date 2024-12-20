const { generateWebpackConfig, merge } = require("shakapacker");
const baseConfig = require('./environment')
const webpack = require("webpack");

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

module.exports = merge(baseConfig, vegaLiteConfig);
