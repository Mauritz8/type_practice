let str = "this is a test"

let words s = List.length (String.split_on_char ' ' s)

let wpm str sec = 
    let n_words = words str in
    let min = sec /. 60.0 in
    float_of_int (n_words) /. min
