const path = require('path');

module.exports = {
  entry: path.resolve('./public/index'),
  dist: path.resolve('./output'),
  template: path.resolve('./public/index.html'),
  favicon: path.resolve('./public/favicon.ico'),
  ownModules: path.resolve(__dirname, '../node_modules'),
  scripts: path.resolve(__dirname, '../scripts'),
  elmMake: path.resolve(__dirname, '../node_modules/.bin/elm-make')
};
