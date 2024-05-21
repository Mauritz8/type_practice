type char_info = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]

val str : string
val init_game : string -> char_info list
val new_input : char_info list -> char -> char_info list
val wpm : string -> float -> float
val equal_game : char_info list -> char_info list -> bool
val format_game : char_info list -> string
val print_diff : char_info list -> char_info list -> unit
