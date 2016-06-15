module Flashcards exposing (..)
import Array exposing (..)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)
import Task
import Random
import Debug
import MyStyles exposing (..)
import String
import Result

main =
  Html.program
    { init = init "Ch4"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Word =
  {
    id: Int
  , word: String
  , definition: String
  , definiteArticle: String
  , numOfTimesInNT: Int
  , otherWordForms: String
}

type alias Model =
  { chapter: String
  , wordList : List Word
  , card : Word
  , showDef : String
  }


--(Model, Cmd Msg)
init : String -> (Model, Cmd Msg)
init ch =
  let model =
    {
    chapter = ch
    , wordList = []
    , card = { id = 0, word = "", definition = "", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }
    , showDef = "hidden"
  }
  in
    (model, getWordList ch)




-- UPDATE

type Msg
  = Next
  | Show
  | FetchSucceed (List Word)
  | FetchFail Http.Error
  | SetChapter String
  | Shuffle


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Next ->
      (Model model.chapter (cycleCards model.wordList) (getNextWord model) "hidden", Cmd.none)

    Show ->
      (Model model.chapter model.wordList model.card "visible", Cmd.none)

    FetchSucceed newList ->
      (Model model.chapter (shuffle newList) model.card "hidden", Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)

    SetChapter ch ->
      (Model ch model.wordList ({ id = 0, word = "", definition = "", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }) "hidden", getWordList ch)

    Shuffle ->
      (Model model.chapter (shuffle model.wordList) model.card model.showDef, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div [mainStyle, textCenter]
    [ select [ textCenter, selectList, onInput SetChapter] [
      option [] [text "Ch4"],
      option [] [text "Ch6"]
    ],
    div [flashcard] [
      h5 [size2, pullRight] [text (toString model.card.numOfTimesInNT)]
      , div [clearFloats] []
      , h1 [size3, textCenter] [text model.card.word]
      , h2 [size3, textCenter, style [ ("visibility", model.showDef) ]] [text model.card.definition]
      , h2 [size3, textCenter, style [ ("visibility", model.showDef) ]] [text model.card.definiteArticle]
      , h2 [size3, textCenter, style [ ("visibility", model.showDef) ]] [text model.card.otherWordForms]
    ]
    , div []
    [ button [ btn, btnBlue, onClick Show ] [ text "Show Definition" ]
    , button [ btn, btnBlue, onClick Next ] [ text "Next Word" ]
    , button [ btn, btnBlue, onClick Shuffle ] [ text "Shuffle" ]
    ]
    ]



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP

getWordList : String -> Cmd Msg
getWordList ch =
  let
    url =
      "data/" ++ ch ++ ".json"
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeDataFile url)

decodeWord : Decoder Word
decodeWord =
  object6 Word
    ("id" := int)
    ("word" := string)
    ("definition" := string)
    ("definiteArticle" := string)
    ("numOfTimesInNT" := int)
    ("otherWordForms" := string)

decodeDataFile : Decoder (List Word)
decodeDataFile = "data" := Json.Decode.list decodeWord

{--}
getNextWord : Model -> Word
getNextWord m =
  if List.length m.wordList > 0 then
    m.wordList
    |> List.take 1
    |> List.head
    |> getCardValue
    else
      {id = 0, word = "error", definition = "error", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = ""}


getCardValue item =
    case item of
      Just i
        -> i
      Nothing
        -> {id = 0, word = "error", definition = "error", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = ""}

cycleCards : List Word -> List Word
cycleCards wList =
  (List.drop 1 wList) ++ (List.take 1 wList)


shuffle : List Word -> List Word
shuffle wList =
   List.map randomID wList
   |>List.sortBy .id

randomID : Word -> Word
randomID word =
    { word | id = Random.step (Random.int 0 100) (Random.initialSeed ((String.length word.definition) * (String.length word.word) // word.id)) |> fst }
