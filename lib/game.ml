type game = {
  paragraph: string;
  input: string;
  errors: int;
}

let str = "this is a test"

let init_game paragraph = { paragraph = paragraph; input = ""; errors = 0; }

let new_input game new_ch = 
  let actual_ch = String.get game.paragraph (String.length game.input) in
  if Char.equal actual_ch new_ch then
    { game with 
      input = Utils.cat game.input new_ch; 
    }
  else
    { game with
      errors = game.errors + 1;
    }

let is_correct_input game =
  let new_ch_index = String.length game.input - 1 in
  if new_ch_index >= String.length game.paragraph then 
    false
  else
    let new_ch = String.get game.input new_ch_index in
    let actual_ch = String.get game.paragraph new_ch_index in
    Char.equal new_ch actual_ch

let is_finished game = String.equal game.paragraph game.input

let words s = List.length (String.split_on_char ' ' s)

let wpm str sec = 
    let n_words = words str in
    let min = sec /. 60.0 in
    float_of_int (n_words) /. min
