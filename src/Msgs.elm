module Msgs exposing (Msg(..))

import Http
import Time
import Models exposing (Word)


type Msg
    = Next String
    | Fetch (Result Http.Error (List Word))
    | SetChapter String
    | Shuffle
    | Tick Time.Time
