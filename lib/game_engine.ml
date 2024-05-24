open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Char_info

type typing_data = { text : char_info list; errors : int; start_time : float option}
[@@deriving yojson]
type report = { chars: int; words : int; errors : int; accuracy_percent : int; sec : int; }

let init_typing_data str =
  let first = { ch = String.get str 0; state = Default; is_next = true } in
  let elem i = { ch = String.get str i; state = Default; is_next = false } in
  let range = List.init (String.length str - 1) (fun x -> x + 1) in
  { text = first :: List.map elem range; errors = 0; start_time = None;}

let rec handle_backspace = function
  | [] -> []
  | [ x ] -> [ x ]
  | x :: y :: ys -> 
      if y.is_next then 
        { x with state = Default; is_next = true} ::
        { y with state = Default; is_next = false} :: ys 
      else x :: handle_backspace (y :: ys)

let handle_ch txt ch =
  let rec aux = function
    | [] -> []
    | [ x ] -> [{ x with 
          state = if x.ch = ch then Correct else Wrong;
          is_next = if x.ch = ch then false else true
        }] 
    | x :: y :: ys ->
        if x.is_next then
          { x with 
            state = if x.ch = ch then Correct else Wrong;
            is_next = false } :: { y with is_next = true } :: ys
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
      let start_time = if typing_data.start_time = None then Some (Unix.time ())
                       else typing_data.start_time in
      { text = (handle_ch typing_data.text ch); errors; start_time; }

let rec text_done = function
  | [] -> true
  | ci :: txt -> if ci.is_next then false else text_done txt

let rec text_done_without_errors = function
  | [] -> true
  | ci :: txt -> if ci.state = Default || ci.state = Wrong then false 
               else text_done_without_errors txt

let n_words txt = List.length (List.filter (fun ci -> ci.ch = ' ') txt) + 1

let accuracy typing_data =
  let len = List.length typing_data.text in
  float_of_int (len - typing_data.errors) /. float_of_int len

let report typing_data =
  let accuracy_percent = accuracy typing_data *. 100.0
  in {
    chars = List.length typing_data.text;
    words = n_words typing_data.text;
    errors = typing_data.errors;
    accuracy_percent = int_of_float (Float.round accuracy_percent);
    sec = match typing_data.start_time with
          | None -> failwith "no start time"
          | Some start -> int_of_float (Unix.time () -. start)
  }

let wpm words sec =
  let min = (float_of_int sec) /. 60.0 in
  int_of_float (Float.round ((float_of_int words) /. min))

let typing_data_equal x y =
  List.equal equal_char_info x.text y.text && x.errors = y.errors

let typing_data_format x =
  let chs = List.map format_char_info x.text in
  let chs_str = String.concat ", \n" chs in
  Printf.sprintf "{[\n%s\n]\n, errors = %d}" chs_str x.errors

let print_text_diff expected actual =
  Printf.printf "Test failed!\nExpected %s\nActual %s\n"
    (typing_data_format expected)
    (typing_data_format actual)
