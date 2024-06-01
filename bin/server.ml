open Ppx_yojson_conv_lib.Yojson_conv.Primitives

open Type_practice
open Game_engine
open Char_info
open Dream_html
open HTML

type input_data = { typing_data: typing_data; key: string } [@@deriving yojson]

let char_info_span (ci : char_info) = 
    span 
      [ if ci.is_next then id "next" else id "";
        match ci.state with
        | Default -> class_ "ch";
        | Correct -> class_ "ch correct";
        | Wrong -> class_ "ch wrong";
      ]
      [txt "%c" ci.ch]

let text (tp : typing_data) =
  div [id "text-box"] [
    input [id "errors"; type_ "hidden"; value "%d" tp.errors];
    input [id "start_time"; type_ "hidden";
        match tp.start_time with
        | None -> value ""
        | Some v -> value "%f" v];
    div [] (List.map char_info_span tp.text)
  ]

let typing_report report = 
  div [id "report"] [
    p [id "report-title"] [txt "Summary"];
    div [id "report-stats"] [
      div [class_ "row"] [
        div [] [
          p [class_ "label"] [txt "Characters"];
          p [class_ "value"] [txt "%d" report.chars];
        ];
        div [] [
          p [class_ "label"] [txt "Mistakes"];
          p [class_ "value"] [txt "%d" report.errors];
        ];
        div [] [
          p [class_ "label"] [txt "Accuracy"];
          p [class_ "value"] [txt "%d%%" report.accuracy_percent];
        ];
      ];
      div [class_ "row"] [
        div [] [
          p [class_ "label"] [txt "Words"];
          p [class_ "value"] [txt "%d" report.words];
        ];
        div [] [
          p [class_ "label"] [txt "Time"];
          p [class_ "value"] [txt "%d sec" report.sec];
          ];
        div [] [
          p [class_ "label"] [txt "WPM"];
          p [class_ "value"] [txt "%d" (wpm report.words report.sec)];
          ];
      ];
    ];
    button [id "report-continue-practice-btn"; Hx.get "/api/new_text";
    Hx.target "body"] [txt "Continue practicing"];
  ]

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [
    Dream.get "/api/new_text" (fun _ ->
      Dream_html.respond (text (init_typing_data (Text_gen.gen_text ()))));

    Dream.post "/api/new_input" (fun request ->
      let%lwt body = Dream.body request in
      let data =
        body
        |> Yojson.Safe.from_string
        |> input_data_of_yojson
      in
      let new_typing_data = handle_new_key data.typing_data data.key in
      let html = if text_done_without_errors new_typing_data.text then 
        typing_report (report new_typing_data) else text new_typing_data in
      Dream_html.respond html);


    Dream.get "/" (Dream.from_filesystem "view" "index.html");
    Dream.get "/view/**" (Dream.static "view/");
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/script/**" (Dream.static "script/");
  ]
