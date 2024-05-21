open Ppx_yojson_conv_lib.Yojson_conv.Primitives

open Type_practice
open Game_engine
open Char_info

type input_data = { text: char_info list; ch: char } [@@deriving yojson]

let ch_classes ci = if ci.is_correct then "ch correct" else "ch"
let ch_id ci = if ci.is_next then "next" else ""

let text (chs : char_info list) =
  <div id='str'>
%   chs |> List.iter begin fun (ci : char_info) ->
%     if Char.equal ci.ch ' ' then begin
        <span id='<%s ch_id ci %>' class='<%s ch_classes ci %>'>&nbsp;</span>
%     end
%     else begin
        <span id='<%s ch_id ci %>' class='<%s ch_classes ci %>'><%s Utils.ch_to_str ci.ch %></span>
%     end;
%   end;
  </div>

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [
    Dream.get "/api/new_text" (fun _ ->
      Dream.html (text (init_text str)));

    Dream.post "/api/new_input" (fun request ->
      let%lwt body = Dream.body request in
      let data =
        body
        |> Yojson.Safe.from_string
        |> input_data_of_yojson
      in
      let new_text = handle_new_ch data.text data.ch in
      Dream.html @@ text new_text);


    Dream.get "/" (Dream.from_filesystem "view" "index.html");
    Dream.get "/view/**" (Dream.static "view/");
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/script/**" (Dream.static "script/");
  ]
