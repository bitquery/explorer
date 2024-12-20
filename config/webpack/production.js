process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const baseConfig = require('./environment')

module.exports = {
    ...baseConfig,
    mode: 'none',
    optimization: {
        minimize: false
    }
}
