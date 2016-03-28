
let hashtbl_add tbl k n =
  let m = CCHashtbl.get_or tbl k ~or_:0 in
  Hashtbl.replace tbl k (m+n)

let analyse_spoken_lines tbl r =
  CCHashtbl.incr tbl r.Irclog.author

let analyse_spoken_char tbl r =
  let count =
    CCString.to_seq r.Irclog.msg
    |> Sequence.filter
      (function ' ' | '\t' -> false | _ -> true)
    |> Sequence.length
  in
  hashtbl_add tbl r.Irclog.author count

let analyse_dirs dirs ~f =
  let tbl = Hashtbl.create 64 in
  List.iter
    (fun dir ->
       Irclog.iter_records_dir ~dir (fun (_,r) -> f tbl r))
    dirs;
  CCHashtbl.to_list tbl
    |> List.filter (fun (_,i) -> i > 10)
    |> List.sort (fun (_,i1)(_,i2) -> compare i2 i1)

(* print list *)
let print_res l =
  Format.printf "@[<2>stats:@ @[<v>%a@]@]@."
    CCFormat.(list ~start:"" ~stop:"" (hbox (pair string int)))
    l

type mode =
  | Line
  | Char

let () =
  let dirs = ref [] in
  let mode = ref Line in
  let set_mode = function
    | "line" -> mode := Line
    | "char" -> mode := Char
    | s -> failwith ("unknown mode " ^ s ^ "; options are {char,line}")
  in
  let options =
    Arg.align
      [ "-m", Arg.String set_mode, " choose analysis mode"
      ]
  in
  Arg.parse options (fun d->dirs:= d::!dirs) "usage: stats dir [dir*]";
  let f = match !mode with
    | Char -> analyse_spoken_char
    | Line -> analyse_spoken_lines
  in
  let res = analyse_dirs !dirs ~f in
  print_res res

