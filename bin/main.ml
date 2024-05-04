let game_loop str =
    let rec aux process =
        if (String.equal str process) then true
        else
            let input = read_line () in
            let ch = String.get input 0 in
            let compare_ch = String.get str (String.length process) in
            if Char.equal ch compare_ch then
                aux (process ^ String.make 1 ch)
            else
                aux process 
    in aux ""

let str = "test"
let () = print_endline str
let success = game_loop str
let () = print_endline (if success then "win" else "lose")
