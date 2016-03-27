
let analyse_dirs dirs =
  let tbl = Hashtbl.create 64 in
  List.iter
    (fun d ->
       Irclog.iter_dir d
         (fun (_,r) ->
            CCHashtbl.incr tbl r.Irclog.author))
    dirs;
  let l =
    CCHashtbl.to_list tbl
    |> List.filter (fun (_,i) -> i > 10)
    |> List.sort (fun (_,i1)(_,i2) -> compare i2 i1)
  in
  Format.printf "@[<2>stats:@ @[<v>%a@]@]@."
    CCFormat.(list ~start:"" ~stop:"" (hbox (pair string int)))
    l

let () =
  let dirs = ref [] in
  Arg.parse [] (fun d->dirs:= d::!dirs) "usage: stats dir [dir*]";
  analyse_dirs !dirs

