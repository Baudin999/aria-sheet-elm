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
