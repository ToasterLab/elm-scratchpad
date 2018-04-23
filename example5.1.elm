import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { fortune : String
  }

init : (Model, Cmd Msg)
init =
  ( Model "loading..."
  , getRandomFortune ""
  )


-- UPDATE

type Msg
  = MorePlease
  | NewGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomFortune "")
    
    NewGif (Ok newFortune) ->
      (Model newFortune, Cmd.none)

    NewGif (Err _) ->
      (model, Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text "Fortunes"] 
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , p [] [ text model.fortune ]
    ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP

getRandomFortune : String -> Cmd Msg
getRandomFortune blank = 
  let
    url =
       "https://happyukgo.com/api/fortune/"

    request =
      Http.get url decodeFortune
  
  in
    Http.send NewGif request

decodeFortune : Decode.Decoder String
decodeFortune =
  Decode.at [] Decode.string


