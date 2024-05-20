type game_ch = { ch: char; is_correct: bool; is_next: bool; } [@@deriving yojson]
type game = game_ch list [@@deriving yojson]

val str : string
val init_game : string -> game
(*val new_input : game -> char -> game*)
(*val is_correct_input : game -> bool*)
(*val is_finished : game -> bool*)
(*val words : string -> string list*)
(*val wpm : string -> float -> float*)
