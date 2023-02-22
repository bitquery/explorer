const { environment,  } = require('@rails/webpacker')
const EsmWebpackPlugin = require("@purtuga/esm-webpack-plugin");

// const customConfig = {
//     plugins: [ new EsmWebpackPlugin() ]
// }

// module.exports = merge(webpackConfig, customConfig)
/* Fix a bug for file inclusion like <img :src="require()"/> */
environment.loaders.get('file').use.find(item => item.loader === 'file-loader').options.esModule = false
environment.config.merge({
    /* module: {
        rules: [
          {
            test: /\.mjs$/,
            include: /node_modules/,
            type: "javascript/auto"
          }
        ]
      }, */
    plugins: [ new EsmWebpackPlugin() ]
  })
module.exports = environment

const webpack = require('webpack')
environment.plugins.append(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
    })
)
