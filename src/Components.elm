module Components exposing (..)

import Html exposing (Html, button, div, span, text, input)
import Html.Attributes exposing (class, type_, classList, placeholder, value)
import Html.Events exposing (onClick, onInput)
import List
import Models exposing (..)
import Svg exposing (circle, svg)
import Svg.Attributes exposing (cx, cy, fill, height, r, stroke, strokeWidth, width)


{- This is the initial container of the pages and should be seen as the root of the application. -}


root : PageModel -> Html Actions
root props =
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
        dialogClass =
            case appState.dialogState of
                DialogShown ->
                    "dialog show"

                _ ->
                    "dialog"
    in
        div [ class dialogClass ]
            [ div [ class "dialog__content" ]
                [ div [ class "dialog__content__header" ] [ text appState.dialogHeader ]
                , div [ class "dialog__content__body" ] [ appState.dialogContent appState.dialogData character ]
                , div [ class "dialog__content__commands" ]
                    [ button [ onClick DialogDone ] [ text "OK" ]
                    , button [ onClick (CharacterMiscActions CloseDialog) ] [ text "Cancel" ]
                    ]
                ]
            ]


editFeatDialogContent : ApplicationStateDialogData -> CharacterModel -> Html Actions
editFeatDialogContent dialogData character =
    let
        createFeatRow : CharacterFeatModel -> Html Actions
        createFeatRow feat =
            div []
                [ input [ type_ "number", onInput (BuyFeatWithXP feat), value (toString feat.xp) ] []
                , text feat.name
                ]
    in
        div []
            (List.map createFeatRow dialogData.feats)



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
            , professions character
            , skills character
            , resistances character
            , equipment character
            ]
        ]


header : CharacterModel -> Html Actions
header character =
    div [ class "header" ]
        [ div [ class "header__name" ]
            [ input [ placeholder "Name your character", onInput Models.ChangeName, value character.name ] []
            ]
        , div [ class "header__race" ] [ text "Your race" ]
        , div [ class "header__class" ] [ text "Your class" ]
        , div [ class "header__xp" ] [ text "Your xp" ]
        , div [ class "header__sub-class" ] [ text "Your sub-class" ]
        , div [ class "header__player" ] [ text "Your player name" ]
        , div [ class "header__race" ] [ text "Your race" ]
        ]


statistics : CharacterModel -> Html Actions
statistics character =
    div [ class "statistics" ]
        [ character.statistics
            |> List.map (\s -> div [ class "statistics__statistic" ] [ text s.name ])
            |> div []
        ]


feats : CharacterModel -> Html Actions
feats character =
    div [ class "container feats" ]
        [ character.feats
            |> List.map (\feat -> renderFeat feat True character)
            |> div []
        , div [ class "container__title", onClick EditFeats ]
            [ text "feats"
            ]
        ]


renderFeat : CharacterFeatModel -> Bool -> CharacterModel -> Html Actions
renderFeat feat allowEditFeat character =
    div ([ class "row feats__feat size--100" ] ++ [])
        [ span [ class "sticky" ] [ text feat.prefix ]
        , span [ class "sticky" ] [ text (toString feat.total) ]
        , span [] [ text feat.unit ]
        , span [ class "align-right" ] [ text feat.name ] -- Alternative syntax for getting a field value out of a record
        ]


skills : CharacterModel -> Html Actions
skills character =
    div [ class "container skills" ]
        [ character.skills
            |> List.map (\skill -> renderSkill skill character)
            |> div []
        , div [ class "container__title" ]
            [ text "skills"
            ]
        ]


renderSkill : CharacterSkillModel -> CharacterModel -> Html Actions
renderSkill skill character =
    div ([ class "row skills__skill" ] ++ [])
        [ span [] [ skillCircle skill.bought ]
        , span [] [ skillCircle skill.expertise ]
        , span [] [ text (skill |> .name) ] -- Alternative syntax for getting a field value out of a record
        ]


resistances : CharacterModel -> Html Actions
resistances character =
    div [ class "container skills" ]
        [ character.resistances
            |> List.map (\resistance -> renderResistances resistance character)
            |> div []
        , div [ class "container__title" ]
            [ text "resistances"
            ]
        ]


renderResistances : CharacterResistanceModel -> CharacterModel -> Html Actions
renderResistances resistance character =
    div ([ class "row resistances__resistance" ] ++ [])
        [ span [] [ skillCircle resistance.bought ]
        , span [] [ skillCircle resistance.expertise ]
        , span [] [ text resistance.name ] -- Alternative syntax for getting a field value out of a record
        ]


professions : CharacterModel -> Html Actions
professions character =
    div [ class "container professions" ]
        [ character.professions
            |> List.map (\profession -> renderProfession profession character)
            |> div []
        , div [ class "container__title" ]
            [ text "professions"
            ]
        ]


renderProfession : CharacterProfessionModel -> CharacterModel -> Html Actions
renderProfession profession character =
    div ([ class "row professions__profession" ] ++ [])
        [ span [] [ skillCircle profession.bought ]
        , span [] [ skillCircle profession.expertise ]
        , span [] [ text (profession |> .name) ] -- Alternative syntax for getting a field value out of a record
        ]


equipment : CharacterModel -> Html Actions
equipment character =
    div [ class "container equipment" ]
        [ character.equipment
            |> List.map
                (\eq ->
                    (div []
                        [ div [ class "row equipment__slot" ]
                            [ div [ class "equipment__slot__title" ] [ text eq.name ]
                            , div [] [ text eq.location ]
                            , div [] [ text eq.description ]
                            ]
                        ]
                    )
                )
            |> div []
        , div [ class "container__title" ]
            [ text "equipment"
            ]
        ]


skillCircle : SourceModel -> Html Actions
skillCircle sourceModel =
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
        svg [ width "10", height "10" ]
            [ circle [ Svg.Attributes.class (createClassFromBoughtSource sourceModel.source), cx "5", cy "5", r "4" ] []
            ]



{- HELPERS -}


last : List a -> Maybe a
last =
    List.foldl (Just >> always) Nothing


atIndex : List a -> Int -> Maybe a
atIndex lst i =
    last (List.take i lst)
