open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type char_info = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]

let str = "this is a test"

let init_text str =
  let first = { ch = String.get str 0; is_correct = false; is_next = true } in
  let elem i = { ch = String.get str i; is_correct = false; is_next = false } in
  let range = List.init (String.length str - 1) (fun x -> x + 1) in
  first :: List.map elem range

let rec new_input game ch =
  let new_x x = { x with is_correct = Char.equal x.ch ch; is_next = false } in
  match game with
  | [] -> []
  | [ x ] -> [ new_x x ]
  | x :: y :: ys ->
      let new_y = { y with is_next = true } in
      if x.is_next then new_x x :: new_y :: ys else x :: new_input (y :: ys) ch

let get_n_words s = List.length @@ String.split_on_char ' ' s

let wpm str sec =
  let n_words = get_n_words str in
  let min = sec /. 60.0 in
  float_of_int n_words /. min


let equal_char_info ci1 ci2 =
  Char.equal ci1.ch ci2.ch &&
  Bool.equal ci1.is_correct ci2.is_correct &&
  Bool.equal ci1.is_next ci2.is_next

let text_equal t1 t2 = List.equal equal_char_info t1 t2

let format_char_info ch = Printf.sprintf "{ ch = %c; is_correct = %b; is_next = %b }"
    ch.ch ch.is_correct ch.is_next

let text_format t = 
  let chs = List.map format_char_info t in
  let chs_str = String.concat ", \n" chs in
  Printf.sprintf "[\n%s\n]\n" chs_str

let print_text_diff expected actual = Printf.printf "Test failed!\nExpected %s\nActual %s"
    (text_format expected) (text_format actual)
