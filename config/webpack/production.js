process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const { merge } = require('shakapacker');
const TerserPlugin = require('terser-webpack-plugin');
const environment = require('./environment');

module.exports = merge(environment, {
    mode: 'production',
    optimization: {
        minimize: true,
        minimizer: [
            new TerserPlugin({
                exclude: /.*[a-zA-Z]+Component[.]js$/gm,
                terserOptions: {
                    mangle: false,
                    keep_classnames: true,
                    keep_fnames: true
                }
            })
        ]
    }
});
