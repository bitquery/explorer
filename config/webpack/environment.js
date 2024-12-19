const { webpackConfig, merge } = require("shakapacker");
const webpack = require("webpack");

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

if (envConfig.optimization) {
  envConfig.optimization.minimizer[0].options.terserOptions.keep_classnames = true;
  envConfig.optimization.minimizer[0].options.terserOptions.keep_fnames = true;
  envConfig.optimization.minimizer[0].options.terserOptions.mangle = false;
  envConfig.optimization.minimizer[0].options.exclude =
    /.*[a-zA-Z]+Component[.]js$/gm;
}

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

module.exports = envConfig;
