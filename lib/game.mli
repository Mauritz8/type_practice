
type game = {
  paragraph: string;
  input: string;
  errors: int;
}

val str : string

val init_game : string -> game
val new_input : game -> char -> game
val is_correct_input : game -> bool
val is_finished : game -> bool
val words : string -> int
val wpm : string -> float -> float
