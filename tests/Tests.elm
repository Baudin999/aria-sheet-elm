module Tests exposing (..)

import Models
import Components
import Handlers
import Test exposing (..)
import Expect
import String
import Test.Html.Query as Query
import Test.Html.Selector as Selector exposing (text, tag)


all : Test
all =
    describe "A Test Suite"
        [ test "Addition" <|
            \() ->
                Expect.equal (3 + 7) 10
        , test "String.left" <|
            \() ->
                Expect.equal "a" (String.left 1 "abcdefg")
        , test "Button has the expected text" <|
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
        , test "calculate the feat" <|
            \() ->
                let
                    {-
                                           name -> description -> factor -> prefix -> unit -> feat
                       defaultCharacterFeat : String -> String -> Float -> String -> String -> CharacterFeatModel
                    -}
                    feat =
                        Models.defaultCharacterFeat "test" "the test feat" 2.0 "-" "%"

                    newFeat =
                        { feat | base = 2 }
                in
                    Expect.equal (Handlers.calculateFeat newFeat).total 6.0
        ]



--
--
-- statistics : Test
-- statistics =
--     describe "Testing the character statistics"
--         [ test "Render the statistics" <|
--             \() ->
--                 let
--                     view =
--                         Components.statistics Models.defaultCharacter
--                 in
--                     Expect.equal "a" "a"
--         ]
--
--
-- calculations : Test
-- calculations =
--     describe "Testing the character calculations"
--         [ test "calculate the feat" <|
--             \() ->
--                 let
--                     {-
--                                            name -> description -> factor -> prefix -> unit -> feat
--                        defaultCharacterFeat : String -> String -> Float -> String -> String -> CharacterFeatModel
--                     -}
--                     feat =
--                         Models.defaultCharacterFeat "test" "the test feat" 2.0 "-" "%"
--
--                     newFeat =
--                         { feat | base = 2 }
--                 in
--                     Expect.equal (Handlers.calculateFeat newFeat).total 4.0
--         ]
