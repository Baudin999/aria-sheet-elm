module Components exposing (..)

import Html exposing (Html, div, span, text, button)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Svg exposing (svg, circle)
import Svg.Attributes exposing (width, height, cx, cy, r, fill, stroke, strokeWidth)
import List
import Models exposing (..)


{- This is the initial container of the pages and should be seen as the root of the application. -}


pageContainer : PageModel -> Html Actions
pageContainer props =
    div []
        [ dialog props.appState props.character
        , div [ class "page-container" ]
            [ pageOne props.character
            , page "page two"
            , page "page three and changed"
            ]
        ]



{- A simple dialog -}


dialog : ApplicationStateModel -> CharacterModel -> Html Actions
dialog appState character =
    let
        class_ =
            case appState.dialogState of
                Show ->
                    "dialog show"

                _ ->
                    "dialog"
    in
        div [ class class_ ]
            [ div [ class "dialog__content" ]
                [ div [ class "dialog__content__header" ] [ text appState.dialogHeader ]
                , appState.content character
                , div [ class "dialog__content__commands" ]
                    [ button [] [ text "OK" ]
                    , button [ onClick ShowDialog ] [ text "Cancel" ]
                    ]
                ]
            ]



{- A Page in this silly little character sheet. -}


page : String -> Html Actions
page name =
    div [ class "page-container__page" ]
        [ div [ class "page-container__page__content" ]
            [ text ("This is a page with changed: " ++ name)
            ]
        ]



{- The first Page -}


pageOne : CharacterModel -> Html Actions
pageOne character =
    div [ class "page-container__page" ]
        [ div [ class "page-container__page__content" ]
            [ header character
            , statistics character
            , feats character
            ]
        ]


header : CharacterModel -> Html Actions
header character =
    div [ class "header" ]
        [ div [ class "header__name", onClick ShowDialog ]
            [ text character.name
            ]
        ]


statistics : CharacterModel -> Html Actions
statistics character =
    div [ class "statistics" ]
        [ character.statistics
            |> List.map (\s -> div [] [ text s.name ])
            |> div []
        ]


feats : CharacterModel -> Html Actions
feats character =
    div [ class "feats" ]
        [ character.feats
            |> List.map (\feat -> renderFeat feat True character)
            |> div []
        ]


renderFeat : CharacterFeatModel -> Bool -> CharacterModel -> Html Actions
renderFeat feat allowEditFeat character =
    let
        events =
            if allowEditFeat then
                [ onClick (EditFeat feat) ]
            else
                []
    in
        div ([ class "row feat-row" ] ++ events)
            [ span [] [ skillCircle Models.Class ]
            , span [] [ skillCircle Models.Race ]
            , span [] [ skillCircle Models.Xp ]
            , span [] [ text feat.name ]
            , span [ class "sticky" ] [ text feat.prefix ]
            , span [ class "sticky" ] [ text (toString feat.total) ]
            , span [] [ text feat.unit ]
            ]


skillCircle : BoughtFrom -> Html Actions
skillCircle boughtFrom =
    let
        createClassFromBoughtSource boughtFrom =
            case boughtFrom of
                Xp ->
                    "xp"

                Race ->
                    "race"

                Class ->
                    "class"

                _ ->
                    ""
    in
        svg [ width "12", height "12" ]
            [ circle [ Svg.Attributes.class (createClassFromBoughtSource boughtFrom), cx "6", cy "6", r "5" ] []
            ]
