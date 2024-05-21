type typing_data = { text: Char_info.char_info list; errors: int; }
[@@deriving yojson]
type report = { words: int; errors: int; accuracy_percent: int; }

val str : string
val init_typing_data : string -> typing_data
val handle_new_ch : typing_data -> char -> typing_data
val text_done : Char_info.char_info list -> bool
val report : typing_data -> report
val wpm : Char_info.char_info list -> float -> float
val typing_data_equal : typing_data -> typing_data -> bool
val typing_data_format : typing_data -> string
val print_text_diff : typing_data -> typing_data -> unit
