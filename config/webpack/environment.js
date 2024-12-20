const { webpackConfig, merge } = require("shakapacker");
const webpack = require("webpack");
const TerserPlugin = require("terser-webpack-plugin");

const customConfig = {
  resolve: {
    fallback: {
      buffer: require.resolve("buffer/"),
    },
  },
  module: {
    rules: [
      {
        test: require.resolve("jquery"),
        loader: "expose-loader",
        options: {
          exposes: ["$", "jQuery"],
        },
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        type: "asset/resource",
        generator: {
          filename: "fonts/[name][ext]",
        },
      },
    ],
  },
  plugins: [
    new webpack.ProvidePlugin({
      Buffer: ["buffer", "Buffer"],
    }),
  ],
};

const envConfig = merge(webpackConfig, customConfig);

envConfig.optimization = envConfig.optimization || {};

envConfig.optimization.minimize = true;
envConfig.optimization.minimizer = [
  new TerserPlugin({
    exclude: /.*[a-zA-Z]+Component[.]js$/gm,
    terserOptions: {
      keep_classnames: true,
      keep_fnames: true,
    },
  })
];

envConfig.plugins.push(
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      Popper: ["popper.js", "default"],
    })
);

envConfig.node = {
  __dirname: true,
  __filename: true,
  global: true,
};

console.log('===========>', envConfig);

module.exports = envConfig;
