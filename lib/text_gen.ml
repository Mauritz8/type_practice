let nouns = [|"person"; "player"; "receptionist";|]
let adjectives = [|"happy"; "sad"; "stressed";|]

let template1 noun adjective = Printf.sprintf "The %s is %s" noun adjective

let rand_elem arr = arr.(Random.int (Array.length arr))

let gen_text () = 
  Random.self_init ();
  let noun = rand_elem nouns in
  let adjective = rand_elem adjectives in
  template1 noun adjective
