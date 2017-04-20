require('./main.css');
var Elm = require('./../src/Main.elm');

var root = document.getElementById('root');

Elm.Main.embed(root);
