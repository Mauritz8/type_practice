val str : string
val init_text : string -> Char_info.char_info list
val handle_new_ch : Char_info.char_info list -> char -> Char_info.char_info list
val text_done : Char_info.char_info list -> bool
val wpm : string -> float -> float
val text_equal : Char_info.char_info list -> Char_info.char_info list -> bool
val text_format : Char_info.char_info list -> string
val print_text_diff : Char_info.char_info list -> Char_info.char_info list -> unit
