open Ppx_yojson_conv_lib.Yojson_conv.Primitives

open Type_practice
open Game

type new_ch_post_data = { g: game_ch list; ch: char } [@@deriving yojson]

let ch_classes game_ch = if game_ch.is_correct then "ch correct" else "ch"
let ch_id game_ch = if game_ch.is_next then "next" else ""

let thething (game : Game.game) =
  <div id='str'>
%   game |> List.iter begin fun (game_ch : Game.game_ch) ->
%     if Char.equal game_ch.ch ' ' then begin
        <span id='<%s ch_id game_ch %>' class='<%s ch_classes game_ch %>'>&nbsp;</span>
%     end
%     else begin
        <span id='<%s ch_id game_ch %>' class='<%s ch_classes game_ch %>'><%s Utils.ch_to_str game_ch.ch %></span>
%     end;
%   end;
  </div>

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [
    Dream.get "/api/test" (fun _ ->
      Dream.html "this is a test");

    Dream.get "/api/new_game" (fun _ ->
      Dream.html (thething (Game.init_game Game.str)));

    Dream.post "/api/new_input" (fun request ->
      let%lwt body = Dream.body request in
      let data =
        body
        |> Yojson.Safe.from_string
        |> new_ch_post_data_of_yojson
      in
      let new_game = new_input data.g data.ch in
      Dream.html @@ thething new_game);


    Dream.get "/" (Dream.from_filesystem "view" "index.html");
    Dream.get "/view/**" (Dream.static "view/");
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/script/**" (Dream.static "script/");
  ]
