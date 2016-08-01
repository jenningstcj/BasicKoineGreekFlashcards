module MyStyles exposing (..)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)


flashcard : Attribute msg
flashcard =
  style
    [ ("backgroundColor", "#fafafa")
    , ("height", "75%")
    , ("boxShadow","0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12)")
    , ("margin", "8px")
    , ("position", "relative")
    , ("borderRadius", "2px")
    ]


center: Attribute msg
center =
  style
    [ ("marginLeft","auto")
    , ("marginRight", "auto")
    , ("display", "inline-block")
    ]

buttonBar: Attribute msg
buttonBar =
  style
    [("height", "15%")]

btn: Attribute msg
btn =
  style
    [("display","inline-block")
    , ("padding", "6px 12px")
    , ("fontWeight", "400")
    , ("lineHeight", "1.42857143")
    , ("textAlign", "center")
    , ("whiteSpace", "nowrap")
    , ("verticalAlign", "middle")
    , ("cursor", "pointer")
    , ("border", "none")
    , ("color", "#ffffff")
    , ("margin", "5px")
    , ("fontSize", "3em")
    , ("height", "100%")
    , ("width", "48%")
    ]

btnBlue: Attribute msg
btnBlue =
  style
    [("backgroundColor", "#4285f4")]
{----}
btnGreen: Attribute msg
btnGreen =
  style
    [("backgroundColor", "#4caf50")]
--}
mainStyle: Attribute msg
mainStyle =
  style
    [("backgroundColor", "lightgray")
    , ("height", "100%")]

clearFloats: Attribute msg
clearFloats =
  style
    [("clear","both")]

italics: Attribute msg
italics =
  style
    [("fontStyle","italic")]


selectList: Attribute msg
selectList =
  style
    [("padding","6px 12px;")
    , ("fontSize", "2em")
    , ("color", "#555")
    , ("backgroundColor", "#fff")
    , ("backgroundImage", "none")
    , ("border", "1px solid #ccc")
    , ("borderRadius", "4px")
    , ("boxShadow","inset 0 1px 1px rgba(0,0,0,.075)")
    , ("transition","border-color ease-in-out .15s,box-shadow ease-in-out .15s")
    , ("width", "98%")
    , ("height", "8%")
    ]

pullRight: Attribute msg
pullRight =
  style
    [("float","right")]

textCenter: Attribute msg
textCenter =
  style
    [("textAlign", "center")]

dropDown:Attribute msg
dropDown =
  style
    [("marginTop", "7em")]

size2:Attribute msg
size2 =
  style
    [("fontSize","2em")
    , ("margin","0px")]

size3:Attribute msg
size3 =
  style
    [("fontSize","3em")]
