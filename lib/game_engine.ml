open Char_info

let str = "this is a test"

let init_text str =
  let first = { ch = String.get str 0; is_correct = false; is_next = true } in
  let elem i = { ch = String.get str i; is_correct = false; is_next = false } in
  let range = List.init (String.length str - 1) (fun x -> x + 1) in
  first :: List.map elem range

let rec handle_new_ch text ch =
  let new_x x = { x with is_correct = Char.equal x.ch ch; is_next = false } in
  match text with
  | [] -> []
  | [ x ] -> [ new_x x ]
  | x :: y :: ys ->
      let new_y = { y with is_next = true } in
      if x.is_next then new_x x :: new_y :: ys else x :: handle_new_ch (y :: ys) ch

let get_n_words s = List.length @@ String.split_on_char ' ' s

let wpm str sec =
  let n_words = get_n_words str in
  let min = sec /. 60.0 in
  float_of_int n_words /. min

let text_equal t1 t2 = List.equal equal_char_info t1 t2

let text_format t = 
  let chs = List.map format_char_info t in
  let chs_str = String.concat ", \n" chs in
  Printf.sprintf "[\n%s\n]\n" chs_str

let print_text_diff expected actual = Printf.printf "Test failed!\nExpected %s\nActual %s"
    (text_format expected) (text_format actual)
