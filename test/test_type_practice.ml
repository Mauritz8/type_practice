open Base
open Type_practice.Game

let%test_unit "init_text_word" =
  let expect = [
    { ch = 's'; is_correct = false; is_next = true; };
    { ch = 't'; is_correct = false; is_next = false; };
    { ch = 'r'; is_correct = false; is_next = false; };
  ] in
  let actual = init_text "str" in
  let is_eq = text_equal actual expect in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "init_text_sentence" =
  let expect = [
    { ch = 't'; is_correct = false; is_next = true; };
    { ch = 'h'; is_correct = false; is_next = false; };
    { ch = 'i'; is_correct = false; is_next = false; };
    { ch = 's'; is_correct = false; is_next = false; };
    { ch = ' '; is_correct = false; is_next = false; };
    { ch = 'i'; is_correct = false; is_next = false; };
    { ch = 's'; is_correct = false; is_next = false; };
    { ch = ' '; is_correct = false; is_next = false; };
    { ch = 'a'; is_correct = false; is_next = false; };
    { ch = ' '; is_correct = false; is_next = false; };
    { ch = 't'; is_correct = false; is_next = false; };
    { ch = 'e'; is_correct = false; is_next = false; };
    { ch = 's'; is_correct = false; is_next = false; };
    { ch = 't'; is_correct = false; is_next = false; };
  ] in
  let actual = init_text "this is a test" in
  let is_eq = text_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "new_input_correct" = 
  let game = [
    { ch = 's'; is_correct = false; is_next = true; };
    { ch = 't'; is_correct = false; is_next = false; };
    { ch = 'r'; is_correct = false; is_next = false; };
  ] in
  let expect = [
    { ch = 's'; is_correct = true; is_next = false; };
    { ch = 't'; is_correct = false; is_next = true; };
    { ch = 'r'; is_correct = false; is_next = false; };
  ] in
  let actual = new_input game 's' in
  let is_eq = text_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "new_input_wrong" = 
  let game = [
    { ch = 's'; is_correct = false; is_next = true; };
    { ch = 't'; is_correct = false; is_next = false; };
    { ch = 'r'; is_correct = false; is_next = false; };
  ] in
  let expect = [
    { ch = 's'; is_correct = false; is_next = false; };
    { ch = 't'; is_correct = false; is_next = true; };
    { ch = 'r'; is_correct = false; is_next = false; };
  ] in
  let actual = new_input game 'h' in
  let is_eq = text_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq
