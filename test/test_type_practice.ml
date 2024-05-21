open Base
open Type_practice.Game

let%test_unit "init_game_basic" =
  let expect = [
    { ch = 's'; is_correct = false; is_next = true; };
    { ch = 't'; is_correct = false; is_next = false; };
    { ch = 'r'; is_correct = false; is_next = false; };
  ] in
  let actual = init_game "str" in
  let is_eq = equal_game actual expect in
  if not is_eq then print_diff expect actual;
  assert is_eq
