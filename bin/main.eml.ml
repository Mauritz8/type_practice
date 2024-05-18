open Type_practice

let game_form request (game : Game.game) =
  <form id='thegame'>
    <%s! Dream.csrf_tag request %>
    <input type='text' name='paragraph' value='<%s game.paragraph %>' readonly><br><br>
    <input type='text' name='input' hx-post='/api/new_input' hx-trigger='input' hx-target='#thegame' value='<%s game.input %>' autofocus>
  </form> 

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [
    Dream.get "/api/test" (fun _ ->
      Dream.html "this is a test");

    Dream.get "/api/new_game" (fun request ->
      Dream.html (game_form request (Game.init_game Game.str)));

    Dream.post "/api/new_input" (fun request ->
      match%lwt Dream.form request with
      | `Ok ["input", input; "paragraph", paragraph] ->
          let (g : Game.game) = { paragraph = paragraph; input = input; errors = 0; } in
          Dream.html (game_form request g)
      | _ -> Dream.empty `Bad_Request);

    Dream.get "/**" @@ Dream.static "view/";
  ]
