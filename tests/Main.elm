port module Main exposing (..)

import Tests
import Test.Runner.Node exposing (run)
import Json.Encode exposing (Value)


ignore : a -> b -> b
ignore a b =
    b


main : Test.Runner.Node.TestProgram
main =
    run emit Tests.all


port emit : ( String, Value ) -> Cmd msg
