open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type game_ch = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]

type game = game_ch list [@@deriving yojson]

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
