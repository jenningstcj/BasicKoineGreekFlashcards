module Main exposing (..)

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Task
import Http
import Random
import Debug
import String
import Time
import Process
import Models exposing (Model, Word)
import View exposing (view)
import Msgs exposing (Msg(..))


main =
    Html.program
        { init = init "Ch4"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



--(Model, Cmd Msg)


init : String -> ( Model, Cmd Msg )
init ch =
    let
        model =
            { chapter = ch
            , wordList = []
            , card = { id = 0, word = "", definition = "", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }
            , showDef = "visible"
            , time = 0
            }
    in
        ( model, getWordList ch )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Next vis ->
            case vis of
                "hidden" ->
                    ( Model model.chapter model.wordList model.card "visible" model.time, Cmd.none )

                _ ->
                    ( Model model.chapter (cycleCards model.wordList) (getNextWord model) "hidden" model.time, Cmd.none )

        Fetch (Ok newList) ->
            ( Model model.chapter (shuffle (Model model.chapter newList model.card "hidden" model.time)) model.card "visible" model.time, Cmd.none )

        Fetch (Err _) ->
            ( model, Cmd.none )

        SetChapter ch ->
            ( Model ch model.wordList ({ id = 0, word = "", definition = "", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }) "visible" model.time, getWordList ch )

        Shuffle ->
            ( Model model.chapter (shuffle model) model.card model.showDef model.time, Cmd.none )

        Tick newTime ->
            ( Model model.chapter model.wordList model.card model.showDef (round newTime), Cmd.none )



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
        Http.send Fetch (Http.get url decodeDataFile)


decodeWord : Decoder Word
decodeWord =
    Json.Decode.map6 Word
        (field "id" int)
        (field "word" string)
        (field "definition" string)
        (field "definiteArticle" string)
        (field "numOfTimesInNT" int)
        (field "otherWordForms" string)


decodeDataFile : Decoder (List Word)
decodeDataFile =
    (field "data" (Json.Decode.list decodeWord))


{--}
getNextWord : Model -> Word
getNextWord m =
    if List.length m.wordList > 0 then
        m.wordList
            |> List.take 1
            |> List.head
            |> getCardValue
    else
        { id = 0, word = "error", definition = "error", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }


getCardValue item =
    case item of
        Just i ->
            i

        Nothing ->
            { id = 0, word = "error", definition = "error", definiteArticle = "", numOfTimesInNT = 0, otherWordForms = "" }


cycleCards : List Word -> List Word
cycleCards wList =
    (List.drop 1 wList) ++ (List.take 1 wList)



--shuffle : Model -> List Word


shuffle model =
    let
        randomlist =
            Random.step (Random.list (List.length model.wordList) (Random.int 1 100)) (Random.initialSeed model.time) |> Tuple.first

        zippedList =
            List.map2 (,) randomlist model.wordList

        sorted =
            zippedList |> List.sortBy Tuple.first

        unzipped =
            List.unzip sorted |> Tuple.second
    in
        unzipped
