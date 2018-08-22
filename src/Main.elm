-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html
port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Browser


main  =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


init : () -> (Model, Cmd Msg)
init _ =
   (initialModel , Cmd.none)


-- MODEL

type alias Model =
  {
     resultofanswer : ResultofAwser
  ,  langnghe : String
  }



initialModel: Model
initialModel =
  {
   resultofanswer = initAnswer
   ,langnghe = "chua co gi"
  }


initAnswer : ResultofAwser

initAnswer =
  {
    answer =""
  , imageUrl ="https://media.giphy.com/media/Cmr1OMJ2FN0B2/giphy.gif"
  }



type alias ResultofAwser =
  {
    answer: String
  , imageUrl: String
  }




port check : ResultofAwser -> Cmd msg


-- UPDATE


type Msg
  = GetAnswer
  | LangNghe String
  | NewGif (Result Http.Error ResultofAwser)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetAnswer ->
      (model, getRandomGif)
    LangNghe bienlangnghe->
      ({ model | langnghe = bienlangnghe }, Cmd.none)
    NewGif (Ok newResult) ->
      ({ model | resultofanswer = newResult}, check model.resultofanswer)

    NewGif (Err _) ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div [id "main"] [
    div [ class "container" ]
      [
        div [class "form-input"] [
          input [placeholder "Put your question here"] []
        , button [ onClick GetAnswer ] [ text "Get answer!" ]
        ]
      , div [class "result"] [
          h1 [] [ text model.langnghe ]
        ,  h2 [] [text model.resultofanswer.answer]
        , img [src model.resultofanswer.imageUrl] []
        ]
      ]
  ]



-- SUBSCRIPTIONS


port langnghe : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
  langnghe LangNghe



-- HTTP


getRandomGif : Cmd Msg
getRandomGif =
  let
    url =
      "https://yesno.wtf/api/"
  in
    Http.send NewGif (Http.get url decodeAnswer)


decodeAnswer : Decode.Decoder ResultofAwser
decodeAnswer =
   Decode.map2 ResultofAwser
    (Decode.field "answer" Decode.string)
    (Decode.field "image" Decode.string)
