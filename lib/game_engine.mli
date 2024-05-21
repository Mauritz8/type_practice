type char_info = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]

val str : string
val init_text : string -> char_info list
val handle_new_ch : char_info list -> char -> char_info list
val wpm : string -> float -> float
val text_equal : char_info list -> char_info list -> bool
val text_format : char_info list -> string
val print_text_diff : char_info list -> char_info list -> unit
