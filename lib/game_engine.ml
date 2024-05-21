open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Char_info

type typing_data = { text: char_info list; errors: int; } [@@deriving yojson]

let str = "this is a test"

let init_typing_data str =
  let first = { ch = String.get str 0; is_correct = false; is_next = true } in
  let elem i = { ch = String.get str i; is_correct = false; is_next = false } in
  let range = List.init (String.length str - 1) (fun x -> x + 1) in
  { text = first :: List.map elem range; errors = 0; }

let handle_new_ch typing_data ch =
  let ci = List.find (fun ci -> ci.is_next) typing_data.text in
  let new_ci = { ci with is_correct = ci.ch = ch; is_next = false } in
  let errors = if ci.ch = ch then typing_data.errors else typing_data.errors + 1 in
  let rec new_text = function
    | [] -> []
    | [ _ ] -> [ new_ci ]
    | x :: y :: ys ->
        let new_y = { y with is_next = true } in
        if x.is_next then new_ci :: new_y :: ys else x :: new_text (y :: ys)
  in { text = (new_text typing_data.text); errors = errors }


let text_done txt = List.length (List.filter (fun ci -> ci.is_correct = false) txt) = 0

let get_n_words s = List.length @@ String.split_on_char ' ' s

let wpm str sec =
  let n_words = get_n_words str in
  let min = sec /. 60.0 in
  float_of_int n_words /. min

let typing_data_equal x y = List.equal equal_char_info x.text y.text && x.errors = y.errors

let typing_data_format x = 
  let chs = List.map format_char_info x.text in
  let chs_str = String.concat ", \n" chs in
  Printf.sprintf "[\n%s\n]\n, errors = %d" chs_str x.errors

let print_text_diff expected actual = Printf.printf "Test failed!\nExpected %s\nActual %s"
    (typing_data_format expected) (typing_data_format actual)
