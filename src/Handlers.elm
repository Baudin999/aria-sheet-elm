module Handlers exposing (..)

import Components
import Models
import Dict exposing (Dict)


init : ( Models.PageModel, Cmd Models.Actions )
init =
    ( { appState = Models.defaultApplicationState, character = Models.defaultCharacter }, Cmd.none )


update : Models.Actions -> Models.PageModel -> ( Models.PageModel, Cmd Models.Actions )
update action pageModel =
    case action of
        Models.CharacterMiscActions miscAction ->
            updateMiscActions miscAction pageModel

        Models.CharacterFeatActions featAction ->
            updateFeatActions featAction pageModel

        Models.EditFeats ->
            let
                oldAppState =
                    pageModel.appState

                oldDialogData =
                    pageModel.appState.dialogData

                newDialogData =
                    { oldDialogData | feats = (List.map identity pageModel.character.feats) }

                newAppState =
                    { oldAppState
                        | dialogState = Models.DialogShown
                        , dialogHeader = "Edit you feats"
                        , dialogContent = Components.editFeatDialogContent
                        , dialogData = newDialogData
                        , dialogApplicationPart = Models.ApplicationPartFeats
                    }
            in
                ( { pageModel | appState = newAppState }, Cmd.none )

        Models.DialogDone ->
            case pageModel.appState.dialogApplicationPart of
                Models.ApplicationPartFeats ->
                    let
                        oldAppState =
                            pageModel.appState

                        newCharacterFeats =
                            (List.map identity pageModel.appState.dialogData.feats)

                        oldCharacter =
                            pageModel.character

                        newCharacter =
                            calculate { oldCharacter | feats = newCharacterFeats }

                        newAppState =
                            { oldAppState
                                | dialogState = Models.DialogHidden
                                , dialogHeader = "Dialog"
                                , dialogApplicationPart = Models.ApplicationPartNone
                            }
                    in
                        ( { pageModel | appState = newAppState, character = newCharacter }, Cmd.none )

                _ ->
                    ( pageModel, Cmd.none )

        Models.BuyFeatWithXP feat s ->
            let
                newValue =
                    String.toInt s |> Result.toMaybe |> Maybe.withDefault 0

                oldAppState =
                    pageModel.appState

                oldDialogData =
                    pageModel.appState.dialogData

                newFeats =
                    pageModel.appState.dialogData.feats
                        |> List.map
                            (\f ->
                                if f.name == feat.name then
                                    { f | xp = newValue }
                                else
                                    f
                            )

                newDialogData =
                    { oldDialogData | feats = newFeats }

                newAppState =
                    { oldAppState | dialogData = newDialogData }

                newModel =
                    { pageModel | appState = newAppState }
            in
                ( newModel, Cmd.none )

        Models.ChangeName name ->
            let
                oldCharacter =
                    pageModel.character

                newCharacter =
                    { oldCharacter | name = name }
            in
                ( { pageModel | character = newCharacter }, Cmd.none )

        _ ->
            ( pageModel, Cmd.none )


updateMiscActions : Models.MiscActions -> Models.PageModel -> ( Models.PageModel, Cmd Models.Actions )
updateMiscActions miscAction pageModel =
    case miscAction of
        Models.CloseDialog ->
            let
                oldAppState =
                    pageModel.appState

                newAppState =
                    { oldAppState | dialogState = Models.DialogHidden }
            in
                ( { pageModel | appState = newAppState }, Cmd.none )

        _ ->
            ( pageModel, Cmd.none )


updateFeatActions : Models.FeatActions -> Models.PageModel -> ( Models.PageModel, Cmd Models.Actions )
updateFeatActions featActionsModel pageModel =
    case featActionsModel of
        Models.BuyFeat selectedFeat calculatableField ->
            let
                character =
                    pageModel.character

                feats =
                    character.feats
                        |> List.map
                            (\f ->
                                if f.name == selectedFeat.name then
                                    case calculatableField of
                                        Models.BaseField i ->
                                            { f | base = i }

                                        Models.RaceField i ->
                                            { f | race = i }

                                        Models.ClassField i ->
                                            { f | class = i }

                                        Models.BonusField i ->
                                            { f | bonus = i }

                                        _ ->
                                            f
                                else
                                    f
                            )

                newCharacter =
                    calculate { character | feats = feats }
            in
                ( { pageModel | character = newCharacter }, Cmd.none )

        _ ->
            ( pageModel, Cmd.none )


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
    { appState | dialogContent = Components.editFeatDialogContent }


setNewState : Models.PageModel -> Models.ApplicationStateModel -> Models.PageModel
setNewState pageModel newState =
    { pageModel | appState = newState }



{- Calculate the character -}


calculate : Models.CharacterModel -> Models.CharacterModel
calculate character =
    let
        newFeats =
            List.map (\feat -> (calculateFeat feat character)) character.feats
    in
        { character | feats = newFeats }



{- Calcualte the character -}


calculateFeat : Models.CharacterFeatModel -> Models.CharacterModel -> Models.CharacterFeatModel
calculateFeat feat character =
    let
        race =
            feat.race

        equipment =
            character.equipment
                |> List.map (\eq -> Dict.get feat.name eq.feats)
                |> List.map (\eq -> (Maybe.withDefault 0 eq))
                |> List.foldl (+) 0

        newTotal =
            feat.base + race + feat.xp + feat.class + feat.bonus + equipment + feat.weapons + feat.specials + feat.statistics

        total =
            (toFloat newTotal) * feat.factor
    in
        { feat | total = total, equipment = equipment, race = race }
