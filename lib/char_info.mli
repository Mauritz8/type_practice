type char_state = Default | Correct | Wrong [@@deriving yojson]
type char_info = { ch : char; state : char_state; is_next : bool }
[@@deriving yojson]

val equal_char_info : char_info -> char_info -> bool
val format_char_info : char_info -> string
