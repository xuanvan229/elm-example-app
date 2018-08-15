-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main : Program Never Model Msg
main  =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


init : (Model, Cmd Msg)
init =
   (initialModel , Cmd.none)


-- MODEL

type alias Model =
  { 
     resultofanswer : ResultofAwser
  }



initialModel: Model 
initialModel =
  {
   resultofanswer = initAnswer
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






-- UPDATE


type Msg
  = GetAnswer
  | NewGif (Result Http.Error ResultofAwser)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetAnswer ->
      (model, getRandomGif)

    NewGif (Ok newResult) ->
      ({ model | resultofanswer = newResult}, Cmd.none)

    NewGif (Err _) ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div [ class "container" ]
    [ 
      div [class "form-input"] [
        input [placeholder "Put your question here"] []
      , button [ onClick GetAnswer ] [ text "Get answer!" ]
      ]
    , div [class "result"] [
       h2 [] [text model.resultofanswer.answer]
      , img [src model.resultofanswer.imageUrl] []
      ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



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