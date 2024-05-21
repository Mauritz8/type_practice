open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type char_info = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]

let equal_char_info ci1 ci2 =
  Char.equal ci1.ch ci2.ch
  && Bool.equal ci1.is_correct ci2.is_correct
  && Bool.equal ci1.is_next ci2.is_next

let format_char_info ci =
  Printf.sprintf "{ ch = %c; is_correct = %b; is_next = %b }" ci.ch
    ci.is_correct ci.is_next
