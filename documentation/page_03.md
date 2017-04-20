# Creating the application

In this chapter we're going to scaffold the application. It took me a long time to actually get things _right_. I hope that my lessons can help you avoid some of the pitfalls when trying to build a big application. First things first. Let's talk about what we are going to be building.

We're going to build a single page application which can be used to create character sheets for Pen and Paper RPG games. We are going to model the entire character structure and the application in going to have a layout like pages so that we can easily print the sheet once we're done tweaking our character.

Like I said, in this part of the tutorial we're going to scaffold the application. In the next chapter we're going to define our types and learn a little bit about [Type Driven Development](http://blog.ploeh.dk/2015/08/10/type-driven-development/).

## A program

There are lots of tutorials out there which focus on building simple applications and programs. _This_ tutorial is written specifically in order to understand writing _big_ applications. This is why I won't spend time working on small examples but will try and integrate everything into a big example.

Let's look at some code:

```elm
module Main exposing (main)

import Html exposing (Html)
import Models
import Components exposing (root)
import Handlers exposing (update, init)


main : Program Never Models.PageModel Models.Actions
main =
    Html.program
        { view = root
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
```

This is my `Main.elm` file. I wanted to keep this file short and sweet. There is nothing strange or mysterious about this file. We create a module:

```elm
module Main exposing (main)
```

and we only expose the `main` function to the world. Everything else is internal to the application. We import a few modules:

```elm
import Html exposing (Html)
import Models
import Components exposing (root)
import Handlers exposing (update, init)
```

The `Html` module exposes our application to the [Virtual DOM](https://github.com/elm-lang/virtual-dom) Elm is talking to. In Elm applications you never manipulate the DOM yourself. You only build a model of the entire DOM with virtual elements and the runtime compared this to the actual DOM and updated the DOM where needed.

I also import my `Models`, my `Components` and my `Handlers`. These three modules will become quite large, and if we ever need to we can split them up into smaller files. My `Models` file contains all of the domain models we'll be using. The `Components` file (which I could have named `Views` but didn't because even though I'm not using the Elm components I still think of UI parts as components) which contains all of my little UI snippets for rendering my models. And my `Handlers` file which contains my business logic.

An Elm program runs like this:

```elm
Event -> Generate View Model -> Render View Model -> Wait for Event
```


<img src='https://g.gravizo.com/svg?
 digraph G {
   Start -> "Rebuild ViewModel";
   "Rebuild ViewModel" -> "Render View";
   "Render View" -> "Event";
   "Event" -> "Rebuild ViewModel";
 }
'/>

This loop is what is called [The Elm Architecture](https://guide.elm-lang.org/architecture/) and it has been wildly praised. React can do more or less the same thing with libraries like [Reflux](https://github.com/reflux/refluxjs) which is a library for uni-directional data flow as designed and described by [flux](https://github.com/facebook/flux/tree/master/examples/flux-concepts).

To be honest about it. I've build applications with [AngularJS](https://angularjs.org/) and plain old ASP.NET, both forms and MVC and it really doesn't matter what you choose. If you are diligent and keep documenting/unit testing your applications will always work quite well. That said, uni-directional data flow solves a few problems. You don't have to think about where state is changed in the application. You can just write your code and send events to a _handler_ update your view model and presto, the changes are being drawn on the screen.

So, back to our Elm application, we now have a better understanding of what the parts in our program do. We have
