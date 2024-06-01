open Base
open Type_practice.Game_engine
open Type_practice.Char_info

let%test_unit "init_typing_data_word" =
  let expect =
    {
      text =
        [
          { ch = 's'; state = Default; is_next = true };
          { ch = 't'; state = Default; is_next = false };
          { ch = 'r'; state = Default; is_next = false };
        ];
      errors = 0;
      start_time = None;
    }
  in
  let actual = init_typing_data "str" in
  let is_eq = typing_data_equal actual expect in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "init_typing_data_sentence" =
  let expect =
    {
      text =
        [
          { ch = 't'; state = Default; is_next = true };
          { ch = 'h'; state = Default; is_next = false };
          { ch = 'i'; state = Default; is_next = false };
          { ch = 's'; state = Default; is_next = false };
          { ch = ' '; state = Default; is_next = false };
          { ch = 'i'; state = Default; is_next = false };
          { ch = 's'; state = Default; is_next = false };
          { ch = ' '; state = Default; is_next = false };
          { ch = 'a'; state = Default; is_next = false };
          { ch = ' '; state = Default; is_next = false };
          { ch = 't'; state = Default; is_next = false };
          { ch = 'e'; state = Default; is_next = false };
          { ch = 's'; state = Default; is_next = false };
          { ch = 't'; state = Default; is_next = false };
        ];
      errors = 0;
      start_time = None;
    }
  in
  let actual = init_typing_data "this is a test" in
  let is_eq = typing_data_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "handle_new_key_correct" =
  let typing_data =
    {
      text =
        [
          { ch = 's'; state = Default; is_next = true };
          { ch = 't'; state = Default; is_next = false };
          { ch = 'r'; state = Default; is_next = false };
        ];
      errors = 0;
      start_time = Some 0.0;
    }
  in
  let expect =
    {
      text =
        [
          { ch = 's'; state = Correct; is_next = false };
          { ch = 't'; state = Default; is_next = true };
          { ch = 'r'; state = Default; is_next = false };
        ];
      errors = 0;
      start_time = Some 0.0;
    }
  in
  let actual = handle_new_key typing_data "s" in
  let is_eq = typing_data_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "handle_new_key_wrong" =
  let typing_data =
    {
      text =
        [
          { ch = 's'; state = Default; is_next = true };
          { ch = 't'; state = Default; is_next = false };
          { ch = 'r'; state = Default; is_next = false };
        ];
      errors = 0;
      start_time = Some 0.0;
    }
  in
  let expect =
    {
      text =
        [
          { ch = 's'; state = Wrong; is_next = false };
          { ch = 't'; state = Default; is_next = true };
          { ch = 'r'; state = Default; is_next = false };
        ];
      errors = 1;
      start_time = Some 0.0;
    }
  in
  let actual = handle_new_key typing_data "h" in
  let is_eq = typing_data_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "handle_new_key_last_char_wrong" =
  let typing_data =
    {
      text =
        [
          { ch = 's'; state = Correct; is_next = false };
          { ch = 't'; state = Correct; is_next = false };
          { ch = 'r'; state = Default; is_next = true };
        ];
      errors = 0;
      start_time = Some 0.0;
    }
  in
  let expect =
    {
      text =
        [
          { ch = 's'; state = Correct; is_next = false };
          { ch = 't'; state = Correct; is_next = false };
          { ch = 'r'; state = Wrong; is_next = true };
        ];
      errors = 1;
      start_time = Some 0.0;
    }
  in
  let actual = handle_new_key typing_data "z" in
  let is_eq = typing_data_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq

let%test_unit "handle_new_key_last_char_correct_with_previous_wrong" =
  let typing_data =
    {
      text =
        [
          { ch = 's'; state = Correct; is_next = false };
          { ch = 't'; state = Wrong; is_next = false };
          { ch = 'r'; state = Default; is_next = true };
        ];
      errors = 0;
      start_time = Some 0.0;
    }
  in
  let expect =
    {
      text =
        [
          { ch = 's'; state = Correct; is_next = false };
          { ch = 't'; state = Wrong; is_next = false };
          { ch = 'r'; state = Wrong; is_next = true };
        ];
      errors = 0;
      start_time = Some 0.0;
    }
  in
  let actual = handle_new_key typing_data "r" in
  let is_eq = typing_data_equal expect actual in
  if not is_eq then print_text_diff expect actual;
  assert is_eq
