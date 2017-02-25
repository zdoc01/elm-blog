import Html exposing (..)
--import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Regex exposing (..)


main : Program Never Model Msg  -- type annotation; 'main' has type 'Program' and should 'Never' expect a flags argument
main =
  Html.program { -- start app with record
    init = init,
    update = update,
    {-
      '\' begins anon function; '_' is a discarded arg; '->' is the function body;
      No concept of null or undefined - expects functions as values so pass anon function
    -}
    subscriptions = \_ -> Sub.none,
    view = view
  }

{-
  MODEL
  * Model type
  * Future type annotations can now reference this type
    * i.e. 'Something : Model' will now refer to this type
  * Expect a record with a 'quote' property that has a string value
-}

type alias Model = {
  quote : String,
  addingPost : Bool,
  posts : List String,
  newPostContent : String
}


init : (Model, Cmd Msg) -- returns a tuple with a record and a command for an effect
init =
  ( Model "" False ["My second post, woot!", "My first post"] "", Cmd.none ) -- instantiate a Model with default values


{-
  UPDATE
  * messages
-}

type Msg = GetQuote | AddPost | SubmitPost | DeletePost | NewPostChange String -- union type; provides a way to represent types that have unusual structures (not String, Bool, Int, etc.). Says 'type Msg' can be any of these values

formatPost : String -> String
formatPost = Regex.replace All (regex "/\n/g") (\_ -> "<br>")

{-
  * update takes a message as an argument and a model argument and returns a tuple
  containing a model and a command for an effect with an update message.
  * A series of items separate by '->' represent argument types, the last of which is the return type
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetQuote ->
      -- return a tuple that updates the quote to append "A quote! " to the existing value
      -- The syntax for updating properties of a record is: `{ recordName | property = updatedValue, property2 = updatedValue2 }`
      ({ model | quote = model.quote ++ "A quote! " }, Cmd.none)
    AddPost ->
      ({ model | addingPost = True }, Cmd.none)
    SubmitPost ->
      ({ model | posts = List.append [ model.newPostContent ] model.posts, addingPost = False }, Cmd.none)
    DeletePost -> -- how to get index of post?
      ( model, Cmd.none)
    NewPostChange newContent ->
      ({ model | newPostContent = formatPost newContent }, Cmd.none)


{-
  Post View Helpers
-}
renderPostsList : List String -> Html Msg
renderPostsList strings =
  ul [ class "posts" ] (List.map renderPost strings)

renderPost : String -> Html Msg
renderPost post =
  li [ class "post" ] [
    blockquote [] [
      text post,
      span [ class "label label-danger right delete-post", onClick DeletePost ] [ text "X" ]
    ]
  ]

{-
  TextArea View Helper
-}
renderTextArea : Model -> Html Msg
renderTextArea model =
  if model.addingPost then
    textarea [ rows 10, onInput NewPostChange ] []
  else
    text "" -- empty Html element


renderButtons : Model -> Html Msg
renderButtons model =
  if model.addingPost then
    button [ class "btn btn-success", onClick SubmitPost ] [ text "Submit" ]
  else
    button [ class "btn btn-info", onClick AddPost ] [ text "Add a post" ]

{-
  VIEW
  * A command Cmd is a request for an effect to take place outside of Elm.
  * A message Msg is a function that notifies the update method that a command was completed.
  * The view needs to return HTML with the message outcome to display the updated UI.
-}

view : Model -> Html Msg -- returns HTML with a message
view model =
  div [ class "container" ] [
    -- The first list argument passed to each node function contains attribute functions with arguments.
    -- The second list contains the contents of the element.
    h2 [ class "text-center" ] [ text "Welcome to Blogger!" ],
    p [ class "text-center" ] [
      renderButtons model
    ],
    renderTextArea model,
    div [ class "posts-container" ] [
      renderPostsList model.posts
    ]
  ]