open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Char_info

type typing_data = { text : char_info list; errors : int } [@@deriving yojson]
type report = { words : int; errors : int; accuracy_percent : int }

let str = "this is a test"

let init_typing_data str =
  let first = { ch = String.get str 0; is_correct = false; is_next = true } in
  let elem i = { ch = String.get str i; is_correct = false; is_next = false } in
  let range = List.init (String.length str - 1) (fun x -> x + 1) in
  { text = first :: List.map elem range; errors = 0 }

let rec handle_backspace = function
  | [] -> []
  | [ x ] -> [ x ]
  | x :: y :: ys -> 
      if y.is_next then 
        { x with is_correct = false; is_next = true} :: { y with is_next = false} :: ys 
      else x :: handle_backspace (y :: ys)

let handle_ch txt ch =
  let rec aux = function
    | [] -> []
    | [ x ] -> [ { x with is_correct = x.ch = ch; is_next = if x.ch = ch then false else true} ] 
    | x :: y :: ys ->
        if x.is_next then
          { x with is_correct = x.ch = ch; is_next = false } :: { y with is_next = true } :: ys
        else x :: aux (y :: ys)
  in aux txt


let handle_new_key typing_data key =
  if String.equal key "Backspace" then 
    { typing_data with text = handle_backspace typing_data.text }
  else 
    if String.length key <> 1 then typing_data
    else
      let ch = key.[0] in
      let ci = List.find (fun ci -> ci.is_next) typing_data.text in
      let errors =
        if ci.ch = ch then typing_data.errors else typing_data.errors + 1 in 
      { text = (handle_ch typing_data.text ch); errors }

let text_done txt =
  List.length (List.filter (fun ci -> ci.is_correct = false) txt) = 0

let n_words txt = List.length (List.filter (fun ci -> ci.ch = ' ') txt) + 1

let report typing_data =
  let correct = List.length typing_data.text in
  let total =  correct + typing_data.errors in
  let accuracy = float_of_int correct /. float_of_int total in
  let accuracy_percent = int_of_float (Float.round (accuracy *. 100.0)) in
  {
    words = n_words typing_data.text;
    errors = typing_data.errors;
    accuracy_percent;
  }

let wpm txt sec =
  let min = sec /. 60.0 in
  float_of_int (n_words txt) /. min

let typing_data_equal x y =
  List.equal equal_char_info x.text y.text && x.errors = y.errors

let typing_data_format x =
  let chs = List.map format_char_info x.text in
  let chs_str = String.concat ", \n" chs in
  Printf.sprintf "[\n%s\n]\n, errors = %d" chs_str x.errors

let print_text_diff expected actual =
  Printf.printf "Test failed!\nExpected %s\nActual %s"
    (typing_data_format expected)
    (typing_data_format actual)
