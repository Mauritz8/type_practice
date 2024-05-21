type game_ch = { ch : char; is_correct : bool; is_next : bool }
[@@deriving yojson]

type game = game_ch list [@@deriving yojson]

val str : string
val init_game : string -> game
val new_input : game -> char -> game
val wpm : string -> float -> float
val equal_game : game -> game -> bool
val print_diff : game -> game -> unit
