module Models exposing (..)

-- MODEL


type alias Word =
    { id : Int
    , word : String
    , definition : String
    , definiteArticle : String
    , numOfTimesInNT : Int
    , otherWordForms : String
    }


type alias Model =
    { chapter : String
    , wordList : List Word
    , card : Word
    , showDef : String
    , time : Int
    }
