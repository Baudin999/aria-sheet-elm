module Handlers exposing (..)

import Components
import Models


init : ( Models.PageModel, Cmd Models.Actions )
init =
    ( { appState = Models.defaultApplicationState, character = Models.defaultCharacter }, Cmd.none )


update : Models.Actions -> Models.PageModel -> ( Models.PageModel, Cmd Models.Actions )
update msg model =
    case msg of
        Models.ShowDialog ->
            let
                newDialogState : Models.DialogState
                newDialogState =
                    case model.appState.dialogState of
                        Models.Show ->
                            Models.Hide

                        Models.Hide ->
                            Models.Show

                newAppState =
                    (newDialogState
                        |> setShowDialog model.appState Models.Medium
                        |> setDialogHeaderText "Dialog"
                    )
            in
                generateNewModel newAppState model.character

        Models.EditFeat feat ->
            let
                newAppState : Models.ApplicationStateModel
                newAppState =
                    Models.Show
                        |> setShowDialog model.appState Models.Medium
                        |> setShowDialogFeatContent feat
                        |> setDialogHeaderText "Edit feats"
            in
                generateNewModel newAppState model.character

        _ ->
            ( model, Cmd.none )


generateNewModel : Models.ApplicationStateModel -> Models.CharacterModel -> ( Models.PageModel, Cmd Models.Actions )
generateNewModel appState character =
    let
        newCharacter =
            calculate character
    in
        ( { appState = appState, character = newCharacter }
        , Cmd.none
        )


setShowDialog : Models.ApplicationStateModel -> Models.DialogSize -> Models.DialogState -> Models.ApplicationStateModel
setShowDialog appState dialogSize dialogState =
    { appState | dialogState = dialogState, dialogSize = dialogSize }


setDialogHeaderText : String -> Models.ApplicationStateModel -> Models.ApplicationStateModel
setDialogHeaderText text appState =
    { appState | dialogHeader = text }


setShowDialogFeatContent : Models.CharacterFeatModel -> Models.ApplicationStateModel -> Models.ApplicationStateModel
setShowDialogFeatContent feat appState =
    { appState | content = Components.renderFeat feat False }


setNewState : Models.PageModel -> Models.ApplicationStateModel -> Models.PageModel
setNewState pageModel newState =
    { pageModel | appState = newState }



{- Calculate the character -}


calculate : Models.CharacterModel -> Models.CharacterModel
calculate character =
    let
        newFeats =
            (character.feats |> List.map (\feat -> calculateFeat feat))
    in
        { character | feats = newFeats }


calculateFeat : Models.CharacterFeatModel -> Models.CharacterFeatModel
calculateFeat feat =
    let
        race =
            if feat.race > 0 then
                feat.race
            else
                1

        newTotal =
            feat.base + race + feat.class + feat.bonus + feat.equipment + feat.weapons + feat.specials + feat.statistics

        total =
            (toFloat newTotal) * feat.factor
    in
        { feat | total = total }
