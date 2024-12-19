process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')
const TerserPlugin = require('terser-webpack-plugin')

environment.config.optimization = {
    minimize: true,
    minimizer: [
        new TerserPlugin({
            terserOptions: {
                mangle: false,
                keep_classnames: true,
                keep_fnames: true,
            },
        }),
    ],
}

module.exports = environment.toWebpackConfig()
