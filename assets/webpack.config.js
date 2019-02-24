const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');

const resolve = file => path.resolve(__dirname, file);

const Env = process.env.MIX_ENV || 'dev';
const isProd = Env === 'prod';

const plugins = (() => {
  const base = [
    new VueLoaderPlugin(),
    new MiniCssExtractPlugin({
      filename: 'css/[name].css',
      allChunks: true,
    }),
    new CopyWebpackPlugin([
      {
        from: './static',
        to: resolve('../priv/static'),
        ignore: ['.*'],
      },
    ]),
  ];

  if (isProd) {
    return [
      ...base,
      new UglifyJsPlugin({
        compress: {
          warnings: false,
        },
        sourceMap: true,
        beautify: false,
        comments: false,
      }),
      new OptimizeCSSAssetsPlugin({}),
    ];
  }

  return base;
})();

module.exports = () => ({
  devtool: isProd ? '#source-map' : '#cheap-module-eval-source-map',
  entry: {
    app: './js/app.js',
  },
  output: {
    path: resolve('../priv/static'),
    filename: 'js/[name].js',
  },
  resolve: {
    extensions: ['.js', '.vue', '.json', '.css', '.scss', '.styl'],
    alias: {
      vue$: 'vue/dist/vue.esm.js',
      '@': resolve('js'),
    },
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            css: ExtractTextPlugin.extract({
              use: ['css-loader', 'sass-loader', 'stylus-loader'],
              fallback: 'vue-style-loader',
            }),
          },
        },
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        include: [resolve('src'), resolve('vendor')],
      },
      {
        test: /\.s?[ac]ss$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
    ],
  },
  plugins,
});
