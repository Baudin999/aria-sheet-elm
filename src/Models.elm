module Models exposing (..)

import Html as Html exposing (div)


type Actions
    = NewCharacter
    | SaveCharacter
    | ShowDialog
    | EditFeat CharacterFeatModel
    | DoNothing


type alias PageModel =
    { character : CharacterModel
    , appState : ApplicationStateModel
    }


type alias CharacterModel =
    { name : String
    , player : String
    , class : ClassModel
    , feats : List CharacterFeatModel
    , statistics : List CharacterStatisticModel
    }


type alias ClassModel =
    { name : String
    , feats : List FeatModel
    }


type alias SourceModel =
    { source : BoughtFrom
    , key : String
    }


type alias Buyable a =
    { a
        | sources : List SourceModel
    }


type alias Nameble a =
    { a
        | name : String
        , title : String
        , description : String
        , notes : String
    }


type alias Calculatable a =
    { a
        | total : Float
        , base : Int
        , race : Int
        , class : Int
        , bonus : Int
        , equipment : Int
        , weapons : Int
        , specials : Int
        , statistics : Int
    }


type alias ValueModel a =
    { a | key : String, value : Int }


type alias CharacterStatisticModel =
    Nameble (Calculatable {})


type alias CharacterFeatModel =
    Nameble
        (Calculatable
            { factor : Float
            , prefix : String
            , unit : String
            }
        )


type alias FeatModel =
    ValueModel {}


type alias StatisticModel =
    ValueModel {}


type alias WeaponModel =
    ValueModel {}


type alias EquipmentModel =
    ValueModel {}


type alias ApplicationStateModel =
    { dialogState : DialogState
    , dialogSize : DialogSize
    , dialogHeader : String
    , content : CharacterModel -> Html.Html Actions
    }


type BoughtFrom
    = Race
    | Class
    | Xp
    | None


type DialogState
    = Show
    | Hide


type DialogSize
    = Small
    | Medium
    | Large


defaultApplicationState : ApplicationStateModel
defaultApplicationState =
    { dialogState = Hide
    , dialogSize = Medium
    , dialogHeader = "Dialog"
    , content = \c -> (div [] [])
    }


defaultCharacter : CharacterModel
defaultCharacter =
    { name = "New Character"
    , player = "New Player"
    , class = defaultClassModel
    , feats =
        [ defaultCharacterFeat "Expertise" "How well you can perform the skill" 1 "" ""
        , defaultCharacterFeat "WS Expertise" "How well you can use martial weapons" 2 "" ""
        , defaultCharacterFeat "BS Expertise" "How well you can use ranged weapons" 2 "" ""
        , defaultCharacterFeat "Crit." "You chance at a critical strike" 2.5 "" "%"
        ]
    , statistics =
        [ defaultCharacterStatistic "STR"
        , defaultCharacterStatistic "AGI"
        , defaultCharacterStatistic "INU"
        , defaultCharacterStatistic "PER"
        ]
    }


defaultClassModel : ClassModel
defaultClassModel =
    { name = "unknown"
    , feats = []
    }


defaultCharacterStatistic : String -> CharacterStatisticModel
defaultCharacterStatistic name =
    { name = name
    , title = name
    , description = ""
    , notes = ""
    , total = 0.0
    , base = 0
    , race = 0
    , class = 0
    , bonus = 0
    , equipment = 0
    , weapons = 0
    , specials = 0
    , statistics = 0
    }


defaultCharacterFeat : String -> String -> Float -> String -> String -> CharacterFeatModel
defaultCharacterFeat name description factor prefix unit =
    { name = name
    , title = name
    , description = description
    , notes = ""
    , total = 0.0
    , base = 0
    , race = 0
    , class = 0
    , bonus = 0
    , equipment = 0
    , weapons = 0
    , specials = 0
    , statistics = 0
    , factor = factor
    , prefix = prefix
    , unit = unit
    }
