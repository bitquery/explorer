process.env.NODE_ENV = process.env.NODE_ENV || 'production';
const config = require('./environment');
const merge = require("webpack-merge");
const {baseConfig} = require("shakapacker");
module.exports = merge(baseConfig, {
    mode: 'none',
    optimization: {
        minimize: false
    }
});

