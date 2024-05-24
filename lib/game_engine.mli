type typing_data = { text : Char_info.char_info list; errors : int; start_time : float option }
[@@deriving yojson]

type report = { chars: int; words : int; errors : int; accuracy_percent : int; sec : int }

val str : string
val init_typing_data : string -> typing_data
val handle_new_key : typing_data -> string -> typing_data
val text_done : Char_info.char_info list -> bool
val text_done_without_errors : Char_info.char_info list -> bool
val report : typing_data -> report
val wpm : int -> int -> int
val typing_data_equal : typing_data -> typing_data -> bool
val typing_data_format : typing_data -> string
val print_text_diff : typing_data -> typing_data -> unit
