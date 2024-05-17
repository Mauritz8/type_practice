let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/api/test" (fun _ ->
      Dream.html "this is a test");
    Dream.get "/**" @@ Dream.static "";
  ]
