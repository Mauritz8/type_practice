open Ppx_yojson_conv_lib.Yojson_conv.Primitives

open Type_practice
open Game_engine
open Char_info

type input_data = { typing_data: typing_data; ch: char } [@@deriving yojson]

let ch_classes ci = if ci.is_correct then "ch correct" else "ch"
let ch_id ci = if ci.is_next then "next" else ""

let text (tp : typing_data) =
  <div id='str'>
    <input id='errors' type='hidden' value='<%d tp.errors %>'>
%   tp.text |> List.iter begin fun (ci : char_info) ->
%     if Char.equal ci.ch ' ' then begin
        <span id='<%s ch_id ci %>' class='<%s ch_classes ci %>'>&nbsp;</span>
%     end
%     else begin
        <span id='<%s ch_id ci %>' class='<%s ch_classes ci %>'><%s Utils.ch_to_str ci.ch %></span>
%     end;
%   end;
  </div>

let report =
  <div id='report'>
    <p>Excellent!</p>
    <p>Your speed was 96 wpm with 98% accuracy</p>
  </div>

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [
    Dream.get "/api/new_text" (fun _ ->
      Dream.html (text (init_typing_data str)));

    Dream.post "/api/new_input" (fun request ->
      let%lwt body = Dream.body request in
      let data =
        body
        |> Yojson.Safe.from_string
        |> input_data_of_yojson
      in
      let new_typing_data = handle_new_ch data.typing_data data.ch in
      let html = if text_done new_typing_data.text then report else text new_typing_data in
      Dream.html html);


    Dream.get "/" (Dream.from_filesystem "view" "index.html");
    Dream.get "/view/**" (Dream.static "view/");
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/script/**" (Dream.static "script/");
  ]
