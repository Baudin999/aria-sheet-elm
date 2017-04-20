module Main exposing (..)

import Html exposing (Html)
import Models exposing (..)
import Components exposing (..)
import Handlers exposing (update, init)


main : Program Never PageModel Actions
main =
    Html.program
        { view = Components.pageContainer
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
