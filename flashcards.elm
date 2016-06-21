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
    , showDef = "visible"
    , time = 0
  }
  in
    (model, getWordList ch)




-- UPDATE

type Msg
  = Next String
  | FetchSucceed (List Word)
  | FetchFail Http.Error
  | SetChapter String
  | Shuffle
  | Tick Time.Time


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Next vis ->
      case vis of
      "hidden" ->
        (Model model.chapter model.wordList model.card "visible" model.time, Cmd.none)
      _ ->
        (Model model.chapter (cycleCards model.wordList) (getNextWord model) "hidden" model.time, Cmd.none)

    FetchSucceed newList ->
      (Model model.chapter (shuffle (Model model.chapter newList model.card "hidden" model.time)) model.card "visible" model.time, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)

    SetChapter ch ->
      (Model ch model.wordList ({ id = 0, word = "", definition = "", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }) "visible" model.time, getWordList ch)

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
        , option [Html.Attributes.value "Ch8"] [text "Ch 8"]
        , option [Html.Attributes.value "Ch9"] [text "Ch 9"]
        , option [Html.Attributes.value "Ch10"] [text "Ch 10"]
        , option [Html.Attributes.value "Ch11"] [text "Ch 11"]
        , option [Html.Attributes.value "Ch12"] [text "Ch 12"]
        , option [Html.Attributes.value "Ch13"] [text "Ch 13"]
        , option [Html.Attributes.value "Ch14"] [text "Ch 14"]
        , option [Html.Attributes.value "Ch16"] [text "Ch 16"]
        , option [Html.Attributes.value "Ch17"] [text "Ch 17"]
        , option [Html.Attributes.value "Ch18"] [text "Ch 18"]
        , option [Html.Attributes.value "Ch19"] [text "Ch 19"]
        , option [Html.Attributes.value "Ch20"] [text "Ch 20"]
        , option [Html.Attributes.value "Ch21"] [text "Ch 21"]
        , option [Html.Attributes.value "Ch22"] [text "Ch 22"]
        , option [Html.Attributes.value "Ch23"] [text "Ch 23"]
        , option [Html.Attributes.value "Ch24"] [text "Ch 24"]
        , option [Html.Attributes.value "Ch25"] [text "Ch 25"]
        , option [Html.Attributes.value "Ch27"] [text "Ch 27"]
        , option [Html.Attributes.value "Ch28"] [text "Ch 28"]
        , option [Html.Attributes.value "Ch29"] [text "Ch 29"]
        , option [Html.Attributes.value "Ch30-35"] [text "Ch 30-35"]
        , option [Html.Attributes.value "Additional"] [text "Additional"]
      ]
      {--, optgroup [attribute "label" "Cognate Vocab Lists"] [
        option [Html.Attributes.value "Ch4"] [text "agathos"]
        , option [Html.Attributes.value "Ch6"] [text "Ch 6"]
      ]--}
    ],
    div [flashcard] [
      h5 [size2, pullRight, style [ ("visibility", "hidden") ]] [text (toString model.card.numOfTimesInNT)]
      , div [clearFloats] []
      , h1 [size3, textCenter] [text model.card.word]
      , h2 [size3, textCenter, style [ ("visibility", model.showDef) ]] [text model.card.definition]
      , h2 [size3, textCenter, style [ ("visibility", model.showDef) ]] [text model.card.definiteArticle]
      , h2 [size3, textCenter, style [ ("visibility", model.showDef) ]] [text model.card.otherWordForms]
    ]
    , div []
    [ button [ btn, btnBlue, onClick Shuffle ] [ text "Shuffle" ]
    , button [ btn, btnBlue, onClick (Next model.showDef) ] [ text "Next Word" ]
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
