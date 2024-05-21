open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type char_info = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]

let str = "this is a test"

let init_game str =
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


let equal_ch ch1 ch2 =
  Char.equal ch1.ch ch2.ch &&
  Bool.equal ch1.is_correct ch2.is_correct &&
  Bool.equal ch1.is_next ch2.is_next

let equal_game g1 g2 = List.equal equal_ch g1 g2

let format_ch ch = Printf.sprintf "{ ch = %c; is_correct = %b; is_next = %b }"
    ch.ch ch.is_correct ch.is_next

let format_game g = 
  let chs = List.map format_ch g in
  let chs_str = String.concat ", \n" chs in
  Printf.sprintf "[\n%s\n]\n" chs_str

let print_diff expected actual = Printf.printf "Test failed!\nExpected %s\nActual %s"
    (format_game expected) (format_game actual)
