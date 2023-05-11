const { environment } = require('@rails/webpacker')

environment.config.optimization.minimizer[0].options.exclude = /render[A-Z].*.js/
environment.config.optimization.minimizer[0].options.terserOptions.keep_classnames = true
environment.config.optimization.minimizer[0].options.terserOptions.keep_fnames = true
environment.config.optimization.minimizer[0].options.terserOptions.module = true
const babelLoader = environment.loaders.get('babel')
babelLoader.use[0].options.presets = [
    ['@babel/preset-env', { targets: "defaults" }]
]

const webpack = require('webpack')
environment.plugins.append(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
    })
)

module.exports = environment
