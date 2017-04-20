# Setting up our development prerequisites.


So, here we are, we have our [setup](page_01.md) and we're ready to start writing software. If you are like me and have a lot of baggage you'll want to dive in and start applying all of these patterns you've learned over the years. This is how I ran into my first wall. Elm is very strict. It comes with a [style-guide](http://elm-lang.org/docs/style-guide) and the community really doesn't appreciate any deviation from this style-guide. I can respect that. It stimulates a style and makes code readable. I sometimes find it very verbose but also comforting that it is something which is [_out of my hands_](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Coding_Style).

I usually work in a team and writing code in a team is very different than writing code at home on a Sunday. There are three major factors when writing code in a team:

 * Code conventions (including styles)
 * Unit Testing
 * Documentation

I believe that these three pillars are fundamental to a successful software project. If you lack one of these your project might as well be doomed from the start. As we've already discussed Elm has very strict Code Conventions. Unit testing examples are in the `create-elm-app` template which it scaffolds but we'll take a look at examples in this chapter. The last part, the documentation I find a bit convoluted in Elm.

## Documentation

We'll start with documentation. There is a [spec](http://package.elm-lang.org/help/documentation-format) for documenting your code. And a [tool](https://github.com/ento/elm-doc) for parsing the documentation. This is great, there is a way to proceed. I do find the way to generate the documentation frustrating. First I need to install [yarn](https://yarnpkg.com/en/docs/install) which of course has dependencies; but eventually you'll end up with something which can output your documentation.

Apart from documenting your code I'd advice you to document your process, setup and deployment strategies as well. You can use something simple as [markdown](https://daringfireball.net/projects/markdown/) which you can transpile to HTML using [pandoc](http://pandoc.org/) or you can use, that which I prefer, [LaTeX](https://www.latex-project.org/). It doesn't really matter as long as you document!

## Unit Testing

Elm is a functional language and as such you really have to take actions to create side effects. Because of this purity it is rather easy to test your code rigorously. For example:

(I use the [elm-html-test](https://github.com/eeue56/elm-html-test) library here)

```elm
module Tests exposing (..)

import Models
import Components
import Test exposing (..)


statistics : Test
statistics =
    describe "Testing the character statistics"
        [ test "Render the statistics" <|
            \() ->
                let
                    view =
                        Components.statistics Models.defaultCharacter
                in
                    view
                        |> Query.fromHtml
                        |> Query.children []
                        |> Query.first
                        |> Query.children []
                        |> Query.first
                        |> Query.has [ text "STR" ]
        ]
```

> Later on in this tutorial we'll build this application and we'll see part by part, piece by piece what these components are and how the models are build.

Unit Testing calculations and other pure functions is even easier:

```elm
test "calculate the feat" <|
    \() ->
        let
            feat =
                Models.defaultCharacterFeat "test" "the test feat" 2.0 "-" "%"

            newFeat =
                { feat | base = 2 }
        in
            Expect.equal (Handlers.calculateFeat newFeat).total 6.0
```

For now it is good enough to know that we can test our components and our functions rigorously. During the next few chapters I'll write more tests and we'll see how we can test our entire application.

## Continuous Integration

CI is a very important part of quality assurance. I would like to simply state that running `npm run build` will compile/transpile everything into the `output` (or `dist`) folder and using something like [GitHub pages](https://pages.github.com/) can serve your static site.

If you want to build a more complex application; like connecting to a backend or retrieving data from a database you'll still have to `build` your application but you must also try and get it to run somewhere on a dedicated server or with something like FireBase as a database. I am not going to explain how to run a web server. We'll be pushing our application to GitHub and we'll be using gh-pages to serve the application.

In order to easily push to GitHub pages I have added the following script to my `package.json`:

```bash
"pages": "npm run build && \
         git add . && \
         git commit -m \"pushing to gh-pages\" && \
         git subtree push --prefix output origin gh-pages "
```

As you can see I use the `subtree` command in git to push the `output` folder to a `gh-pages` branch in our GitHub repository.

For this tutorial and these examples we're not going to create webhooks to listen and react to changes on GitHub, we're going to manually push our changes to GitHub.

# To Be Continued

In the next chapters we'll continue to work on the application until we have a big Elm example.

[previous](page_01.md)
[next](page_03.md)
