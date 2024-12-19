process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')
environment.config.optimization.minimize = false;

module.exports = environment.toWebpackConfig()
