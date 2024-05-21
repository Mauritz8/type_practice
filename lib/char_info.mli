type char_info = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]
val equal_char_info : char_info -> char_info -> bool
val format_char_info : char_info -> string
