const {generateWebpackConfig, merge} = require("shakapacker");
const webpack = require("webpack");
const TerserPlugin = require("terser-webpack-plugin");

const webpackConfig = generateWebpackConfig();

const customConfig = {
    resolve: {
        fallback: {
            buffer: require.resolve("buffer/"),
        },
    },
    optimization: {
        minimize: false,
        minimizer: [
            new TerserPlugin({
                exclude: [
                    /.*[a-zA-Z]+Component[.]js$/gm,
                    /WidgetConfig\.js$/
                ],
                terserOptions: {
                    keep_classnames: true,
                    keep_fnames: true,
                    mangle: false
                }
            })
        ]
    },
    module: {
        rules: [
            {
                test: require.resolve("jquery"),
                loader: "expose-loader",
                options: {exposes: ["$", "jQuery"]},
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
        new webpack.ProvidePlugin({
            $: "jquery",
            jQuery: "jquery",
            Popper: ["popper.js", "default"],
        })
    ],
    node: {
        __dirname: true,
        __filename: true,
        global: true,
    },
};

module.exports = merge(webpackConfig, customConfig);
