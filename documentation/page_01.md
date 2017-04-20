

# Why I wanted to learn Elm

Back in the day I used to be a C# developer writing big Enterprise applications. Big enterprise applications seem to come with their own set of ideas and rules. I've done almost everything, from CQRS, Micro Services to "Just do it" applications. I've build applications with _good_ OOP designs and I've build applications using a more functional style but I've never found it interesting; it was always "more of the same".

That is when I discovered User Interfaces! User Interfaces are difficult to build, the results are exciting and the best part is that you get to write JavaScript! JavaScript lets you write everything you want in a truly minimalistic set of language rules and it still manages to perform quite well!

The downside of writing JavaScript is that maintaining an old application is really hard. You practically need to have written the code yourself and you need to be able to _think_ the way you _thought_ when writing that original code. I wanted something more. [TypeScript](https://www.typescriptlang.org/) led me down the same path as C# and I truly dislike OOP, especially inheritance. I've tried [Fable](http://fable.io/), [PureScript](http://www.purescript.org/), [Haskell](https://www.haskell.org/) and many other languages until I reached [Elm](http://elm-lang.org/).

Elm is easy enough to get started with, easy to set up but really hard to master. And this brings me to why I'm writing these tutorials. If you are like me and want to get started with Elm but want to do it in such a way that you can write big enterprisy applications you will slam agains brick walls. My hope is that these tutorials will help you pass through those walls with less _slammin'_.


# Installing Elm

I'm not going to write a lot on installing Elm. There are plenty of tutorials on how to do that. What I _am_ going to do is write about my setup and the tools I use to work with Elm. Elm is like other functional programming languages. It has a _platform_ just like Haskell. And contrary to something like PureScript you can use the Elm compiler any way you want. I didn't like the dependency on [pulp](http://pulpproject.org/) and [bower](https://bower.io/). I liked the fact that Elm has it's own package manager which "just works".

What I think makes Elm really powerful are the REPL and the dev server (elm-reactor) although I personally like a more traditional style of developing.

I usually use [Visual Studio Code](https://code.visualstudio.com/) when programming, but, I'm not happy with how it behaved working with Elm so I've decided after some questions in the [Slack](https://elmlang.slack.com) community to try out [Atom](https://atom.io/). So far I haven't looked back. Atom works smoothly and it's a pleasure to set up. I use the following elm packages:

 * [elm-format](https://atom.io/packages/elm-format)
 * [elmjutsu](https://atom.io/packages/elmjutsu)
 * [language-elm](https://atom.io/packages/language-elm)
 * [linter-elm-make](https://atom.io/packages/linter-elm-make)


## create-elm-app

For development I use [create-elm-app](https://www.npmjs.com/package/create-elm-app) which, if you know [create-react-app](https://github.com/facebookincubator/create-react-app) works about the same. I did run into a few functional issues which I will explain.

I chose the `create-elm-app` tool because I wanted to use Elm in combination with [webpack](https://webpack.github.io/). WebPack is _the_ module bundler for the web and once you know how it works (and that is a completely different multi-page tutorial) you'll find that it is really powerful and a great help when building applications. Setting up WebPack to work with your Elm application is tedious and `create-elm-app` helps to set all of this up. What I didn't like was the way everything was mushed together into the `src` directory. I like things separated and so I had to `eject` the app and tweak things manually. My setup is the following:


```bash
├── config
├── documentation
├── output
│   ├── css
│   └── js
├── public
├── scripts
├── src
├── styles
└── tests
```

As you can see, I've changed `dist` to `output` and added `documentation`, `styles` and the important `public` folders. The other folders are there because of the `eject`. In order to get these configurations I changed the `config/paths.js` file to:

```js
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
```

The other scripts use these paths to generate the content which is exactly what I wanted. The public folder is now a folder which serves to contain the templates which are build into the actual files served by the production server when you eventually create a build. I think it's important to have all of your _application logic_ in the `src` folder and all of the _template_ in the `public` folder.

I've also changed the `package.json` scripts; my `start` script now looks like:

```js
"start": "webpack-dev-server --config './config/webpack.config.dev.js' --port 4444",
```

which is still a bit hacky and once I find the time to tweak this I will create a proper fork of `create-elm-app` based on these configurations but for now it works and I can develop using this setup. Running `npm run build` generates the right output in the `output` folder with proper `css` and `js` subfolders.

## Styling the application

I use less for my day-to-day development. I've found it to be fast and more than enough for my mediocre styling skills. You can install less by running `npm install --save-dev less` and I use [nodemon](https://github.com/remy/nodemon) to watch for file changes and recompile my `*.less` files to the right css file. I do this with the following simple little npm script:

```js
"less": "nodemon --exec \"lessc ./styles/main.less ./public/main.css\" -e less"
```

I output the `main.css` file to the public directory because as a static asset we'll want it to be build and bundled into our eventual output package. I have no styling cluttering my `src` folder because styles should be separate from your code in almost every way except for classes defined on your HTML elements.

I import the `main.css` file in the `./public/index.js` file through webpack's require functions:

```js
// import the styles
require('./main.css');

// Elm stuff...
```

## semantic css & BEM

Always try and be semantic when working with css. This is a good [article](https://css-tricks.com/semantic-class-names/) explaining what you should and shouldn't do. I use semantic css in combination with the [BEM](http://getbem.com/introduction/) notation. I've also found `less` to be really helpful when writing BEM style classes. Here's an example:

### HTML
```html
<div class="character">
  <div class="character__statistics-list">
    <div class="character__statistics-list__statistic">21</div>
    <div class="character__statistics-list__statistic">13</div>
    <div class="character__statistics-list__statistic">8</div>
    <div class="character__statistics-list__statistic">18</div>
  </div>
</div>
```

### less
```scss
.character {
  // the root
  &__statistics-list {
    // do something
    &__statistic {
      background: 'orange';
    }
  }
}
```

As you can see, the long names do not have to be as tedious as you would expect using the BEM notation. I would advice to always write your styling after you've created your content. This will make it easier to maintain your styles and your code. I always start with three files:


```
.
├── components.less
├── main.less
└── reset.less
```

The `reset.less` can be found [here](https://github.com/kuatsure/Eric-Meyer-Reset---less--). I usually add a few more things like a reset for `ul` etc etc. Your `reset.less` file resets all the styling before you start building.

My `main.less` file is the files which gets transpiled into a `.css` file and contains all the references and imports to the other less files in the project. The other file I start with is the `components.less` which I use to start building/scaffolding styles while creating the app. Later on I'll pull this file apart and create other files in other directory structures until the `components.less` file is empty.

# To Be Continued

In the next chapters we'll continue to work on the application until we have a big Elm example.

[page 02](page_02.md)
