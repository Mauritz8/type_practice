open Ppx_yojson_conv_lib.Yojson_conv.Primitives

(*type game = { paragraph : string; input : string; errors : int }*)
type game_ch = { ch: char; is_correct: bool; is_next: bool; } [@@deriving yojson]
type game = game_ch list [@@deriving yojson]


let str = "this is a test"

let init_game str =
  let rec aux i (lst : game_ch list) = 
    let ch = String.get str i in
    match i with
    | 0 -> { ch = ch; is_correct = false; is_next = true; } :: lst
    | _ -> aux (i - 1) ({ ch = ch; is_correct = false; is_next = false; } :: lst)
  in aux (String.length str - 1) []


let rec new_input game ch = 
  let new_x x = { ch = x.ch; is_correct = Char.equal x.ch ch; is_next = false; } in
  match game with
  | [] -> []
  | [x] -> [new_x x]
  | x :: y :: ys -> 
      let new_y = { ch = y.ch; is_correct = y.is_correct; is_next = true; } in
      if x.is_next then new_x x :: new_y :: ys else x :: new_input (y :: ys) ch

(*let is_correct_input game =*)
(*  let new_ch_index = String.length game.input - 1 in*)
(*  if new_ch_index >= String.length game.paragraph then false*)
(*  else*)
(*    let new_ch = String.get game.input new_ch_index in*)
(*    let actual_ch = String.get game.paragraph new_ch_index in*)
(*    Char.equal new_ch actual_ch*)
(**)
(*let is_finished game = String.equal game.paragraph game.input*)
(*let words s = String.split_on_char ' ' s*)
(*let get_n_words s = List.length @@ words s*)
(**)
(*let chs s = String.split_on_char '' s*)
(**)
(*let wpm str sec =*)
(*  let n_words = get_n_words str in*)
(*  let min = sec /. 60.0 in*)
(*  float_of_int n_words /. min*)
