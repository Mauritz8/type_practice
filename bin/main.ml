open Ppx_yojson_conv_lib.Yojson_conv.Primitives

open Type_practice
open Game_engine
open Char_info
open Dream_html
open HTML

type input_data = { typing_data: typing_data; ch: char } [@@deriving yojson]

let char_info_span (ci : char_info) = 
    span 
      [ if ci.is_next then id "next" else id "";
        if ci.is_correct then class_ "ch correct" else class_ "ch" ]
      [txt "%s" (Utils.ch_to_str ci.ch)]

let text (tp : typing_data) =
  div [id "str"] [
    input [id "errors"; type_ "hidden"; value "%d" tp.errors];
    div [] (List.map char_info_span tp.text)
  ]

let typing_report report = 
  div [id "report"] [
    p [] [txt "Excellent"];
    p [] [txt "You typed %d words with %d accuracy" report.words report.accuracy_percent];
  ]

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [
    Dream.get "/api/new_text" (fun _ ->
      Dream_html.respond (text (init_typing_data str)));

    Dream.post "/api/new_input" (fun request ->
      let%lwt body = Dream.body request in
      let data =
        body
        |> Yojson.Safe.from_string
        |> input_data_of_yojson
      in
      let new_typing_data = handle_new_ch data.typing_data data.ch in
      let html = if text_done new_typing_data.text then 
        typing_report (report new_typing_data) else text new_typing_data in
      Dream_html.respond html);


    Dream.get "/" (Dream.from_filesystem "view" "index.html");
    Dream.get "/view/**" (Dream.static "view/");
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/script/**" (Dream.static "script/");
  ]
