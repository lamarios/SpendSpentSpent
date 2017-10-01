var webpack = require('webpack');
var path = require('path');
var CopyWebpackPlugin = require('copy-webpack-plugin');


var BUILD_DIR = path.resolve(__dirname, 'public');
var APP_DIR = path.resolve(__dirname, 'src');


var API_ROOT = "";
var API_URL = API_ROOT + '/API';

var constants = {
    CATEGORY: {
        ALL: JSON.stringify(API_URL + '/Category'),
        AVAILABLE: JSON.stringify(API_URL + '/Category/Available'),
        ADD: JSON.stringify(API_URL + '/Category'),
        GET: JSON.stringify(API_URL + '/Category/ById/{0}'),
        DELETE: JSON.stringify(API_URL + '/Category/{0}')
    },
    EXPENSE: {
        ADD: JSON.stringify(API_URL + '/Expense'),
        BY_MONTH: JSON.stringify(API_URL + '/Expense/ByDay?month={0}'),
        GET_MONTHS: JSON.stringify(API_URL + '/Expense/GetMonths'),
        DELETE: JSON.stringify(API_URL + '/Expense/{0}'),
    },
    HISTORY: {
        OVERALL: {
            MONTH: JSON.stringify(API_URL + "/History/CurrentMonth"),
            YEAR: JSON.stringify(API_URL + "/History/CurrentYear"),
        },
        YEARLY: JSON.stringify(API_URL+"/History/Yearly/{0}/{1}"),
        MONTHLY: JSON.stringify(API_URL+"/History/Monthly/{0}/{1}"),
    },
    RECURRING: {
        GET: JSON.stringify(API_URL + '/RecurringExpense'),
        ADD: JSON.stringify(API_URL + '/RecurringExpense'),
        DELETE: JSON.stringify(API_URL + '/RecurringExpense/{0}')
    },
    SESSION: {
        LOGIN: JSON.stringify(API_ROOT + '/Login')
    },
    SETTINGS: {
        UPDATE: JSON.stringify(API_URL + '/Setting'),
        ALL: JSON.stringify(API_URL + '/Setting'),
        GET: JSON.stringify(API_URL+'/Setting/{0}'),
    }

}

var config = {
    entry: [APP_DIR + '/jsx/index.jsx', APP_DIR + '/less/main.less'],
    output: {
        path: BUILD_DIR,
        filename: 'bundle.js'
    },
    plugins: [
        new webpack.DefinePlugin({
            'API': constants
        }),

        new CopyWebpackPlugin([
            {from: APP_DIR + '/index.html'}
        ], {
            copyUnmodified: true
        })
    ],
    module: {
        rules: [
            {
                test: /\.(png|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000'
            },
            {
                test: /\.jsx?/,
                include: APP_DIR,
                loader: 'babel-loader'
            },
            {test: /\.css$/, loader: 'style-loader!css-loader',},
            {
                test: /main.less$/,
                use: [{
                    loader: "style-loader" // creates style nodes from JS strings
                }, {
                    loader: "css-loader" // translates CSS into CommonJS
                }, {
                    loader: "less-loader"
                }]
            }
        ]
    }
};

module.exports = config;