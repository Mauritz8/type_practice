open Type_practice
open Game

(*let game_form request (game : Game.game) =*)
(*  <form id='thegame'>*)
(*    <%s! Dream.csrf_tag request %>*)
(*    <input type='text' name='paragraph' value='<%s game.paragraph %>' readonly><br><br>*)
(*    <input type='text' name='input' hx-post='/api/new_input' hx-trigger='input' hx-target='#thegame'*)
(*      value='<%s game.input %>' onfocus='var temp_value=this.value; this.value=""; this.value=temp_value'*)
(*      autocomplete='off' autofocus>*)
(*    <input type='hidden' name='errors' value='<%i game.errors %>'>*)
(*%     if Game.is_finished game then begin*)
(*        <h2>You win</h2> *)
(*%     end;*)
(*  </form> *)

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

      let game_ch =
        body
        |> Yojson.Safe.from_string
        |> game_ch_of_yojson
      in

      yojson_of_game_ch game_ch
      |> Yojson.Safe.to_string
      |> Dream.json);


    Dream.get "/" (Dream.from_filesystem "view" "index.html");
    Dream.get "/view/**" (Dream.static "view/");
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/script/**" (Dream.static "script/");
  ]
