process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const { merge } = require('shakapacker');
const environment = require('./environment');

module.exports = merge(environment, {
    mode: 'production',
    optimization: {
        minimize: false
    }
});
