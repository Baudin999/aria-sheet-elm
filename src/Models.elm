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
    , professions : List CharacterProfessionModel
    , resistances : List CharacterResistanceModel
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
    { a | bought : SourceModel, expertise : SourceModel }


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
            (Buyable
                { factor : Float
                , prefix : String
                , unit : String
                }
            )
        )


type alias CharacterProfessionModel =
    { bought : SourceModel
    , expertise : SourceModel
    , name : String
    }


type alias CharacterResistanceModel =
    { bought : SourceModel
    , expertise : SourceModel
    , name : String
    }


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
    , resistances =
        [ CharacterResistanceModel defaultSourceModel defaultSourceModel "Fire & Heat"
        , CharacterResistanceModel defaultSourceModel defaultSourceModel "Cold & Ice"
        , CharacterResistanceModel defaultSourceModel defaultSourceModel "Holy"
        , CharacterResistanceModel defaultSourceModel defaultSourceModel "Mental"
        , CharacterResistanceModel defaultSourceModel defaultSourceModel "Magic"
        , CharacterResistanceModel defaultSourceModel defaultSourceModel "Poison & Disease"
        , CharacterResistanceModel defaultSourceModel defaultSourceModel "Strength"
        , CharacterResistanceModel defaultSourceModel defaultSourceModel "Intelligence"
        ]
    , feats =
        [ defaultCharacterFeat "Expertise" "How well you can perform the skill" 1 "" ""
        , defaultCharacterFeat "WS Expertise" "How well you can use martial weapons" 2 "" ""
        , defaultCharacterFeat "BS Expertise" "How well you can use ranged weapons" 2 "" ""
        , defaultCharacterFeat "Extra Attack" "Chance to gain an extra attack" 20 "" "%"
        , defaultCharacterFeat "Crit" "You chance at a critical strike" 2.5 "" "%"
        , defaultCharacterFeat "Crit DMG" "Increase your critical strike DMG by 1d4 per rank" 1 "" "d4"
        , defaultCharacterFeat "DMG Adjstm." "Increase DMG with 1 per rank" 1 "+" ""
        , defaultCharacterFeat "Toughness" "Increase your armor with 1 per rank" 1 "+" ""
        , defaultCharacterFeat "Regenerate" "Regenerate +1 HP per recuperate" 1 "+" ""
        , defaultCharacterFeat "Spec. Offense" "10% per rank to refund all AP of that attack" 10 "" "%"
        , defaultCharacterFeat "Spec. Defense" "10% per rank to refund all AP of that defensive action" 10 "" "%"
        , defaultCharacterFeat "Endurance" "+1 AP per recuperation" 1 "+" ""
        , defaultCharacterFeat "Directed Strike" "You can call hit locations with increasing accuracy. See directed strike for more information" 1 "+" ""
        , defaultCharacterFeat "Aura" "All magic does -1 DMG" 1 "-" ""
        , defaultCharacterFeat "Spash" "You have 20% chance per rank to automatically hit another target for 50% of your DMG. This DMG can be dodged." 20 "" "%"
        , defaultCharacterFeat "Roll modifier" "Per rank you get 1 point which you can use to modify your world die. These points are restored after you sleep." 1 "" ""
        , defaultCharacterFeat "Break Armor" "On each successful hit reduce the target's armor with 1 per rank" 1 "" ""
        , defaultCharacterFeat "Unbreakable" "20% chance per recuperate to regain all of your lost armor" 20 "" "%"
        , defaultCharacterFeat "Movement" "Increase movement rate with 4ft per rank." 4 "" "ft"
        , defaultCharacterFeat "Hit Points" "Increase HP rank rating by 1" 1 "" ""
        , defaultCharacterFeat "Merchant" "+3 per rank on your merchant rolls" 3 "" "+"
        , defaultCharacterFeat "Artist" "+3 per rank on your artist rolls" 3 "" "+"
        , defaultCharacterFeat "Scholar" "+3 per rank on your scholar rolls" 3 "" "+"
        ]
    , professions =
        [ CharacterProfessionModel defaultSourceModel defaultSourceModel "Craftsman"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Miner"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Medic"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Stagehand"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Merchant"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Tinkerer"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Farmer"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Sailor"
        , CharacterProfessionModel defaultSourceModel defaultSourceModel "Lawyer"
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


defaultSourceModel : SourceModel
defaultSourceModel =
    { source = None, key = "" }


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
    , bought = defaultSourceModel
    , expertise = defaultSourceModel
    }


defaultBuyable =
    [ { source = None
      , key = ""
      }
    , { source = None
      , key = ""
      }
    ]
