open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type char_state = Default | Correct | Wrong [@@deriving yojson]
type char_info = { ch : char; state : char_state; is_next : bool }
[@@deriving yojson]

let equal_char_info ci1 ci2 =
  Char.equal ci1.ch ci2.ch
  && ci1.state = ci2.state
  && Bool.equal ci1.is_next ci2.is_next


let format_char_state = function
  | Default -> "Default"
  | Correct -> "Correct"
  | Wrong -> "Wrong"

let format_char_info ci =
  Printf.sprintf "{ ch = %c; state = %s; is_next = %b }" ci.ch
    (format_char_state ci.state) ci.is_next
