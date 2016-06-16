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
import Time

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
  , time : Int
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
    , time = 0
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
  | Tick Time.Time


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Next ->
      (Model model.chapter (cycleCards model.wordList) (getNextWord model) "hidden" model.time, Cmd.none)

    Show ->
      (Model model.chapter model.wordList model.card "visible" model.time, Cmd.none)

    FetchSucceed newList ->
      (Model model.chapter (shuffle (Model model.chapter newList model.card "hidden" model.time)) model.card "hidden" model.time, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)

    SetChapter ch ->
      (Model ch model.wordList ({ id = 0, word = "", definition = "", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }) "hidden" model.time, getWordList ch)

    Shuffle ->
      (Model model.chapter (shuffle model) model.card model.showDef model.time, Cmd.none)

    Tick newTime ->
      (Model model.chapter model.wordList model.card model.showDef (round newTime), Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div [mainStyle, textCenter]
    [ select [ textCenter, selectList, onInput SetChapter] [
      optgroup [attribute "label" "Grammar"] [
        option [Html.Attributes.value "Nouns"] [text "Nouns"]
        , option [Html.Attributes.value "Verbs"] [text "Verbs"]
      ]
      , optgroup [attribute "label" "Mounce Chapter Vocab"] [
        option [selected True, Html.Attributes.value "Ch4"] [text "Ch 4"]
        , option [Html.Attributes.value "Ch6"] [text "Ch 6"]
        , option [Html.Attributes.value "Ch7"] [text "Ch 7"]
      ]
      {--, optgroup [attribute "label" "Cognate Vocab Lists"] [
        option [Html.Attributes.value "Ch4"] [text "agathos"]
        , option [Html.Attributes.value "Ch6"] [text "Ch 6"]
      ]--}
    ],
    div [flashcard] [
      h5 [size2, pullRight, style [ ("display", "none") ]] [text (toString model.card.numOfTimesInNT)]
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
  Time.every Time.millisecond Tick



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


shuffle : Model -> List Word
shuffle model =
  let
    randomlist = Random.step (Random.list (List.length model.wordList) (Random.int 1 100)) (Random.initialSeed model.time) |> fst
    zippedList  = List.map2 (,) randomlist model.wordList
    sorted = zippedList |> List.sortBy fst
    unzipped = List.unzip sorted |> snd
  in
   unzipped
