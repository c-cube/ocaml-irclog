
(** {1 Small Parser for IRC Logs} *)

type 'a sequence = ('a -> unit) -> unit

type log_record = {
  author: string;
  time: string;
  msg: string;
}

let re = Re_posix.re "([0-9:]*)<(%s)> (%s)" |> Re.compile

let finally_ f x ~h =
  try
    let res = f x in
    h x;
    res
  with e ->
    h x;
    raise e

let with_in ?(mode=0o644) ?(flags=[Open_text]) filename f =
  let ic = open_in_gen (Open_rdonly::flags) mode filename in
  finally_ f ic ~h:close_in

(* read lines *)
let rec seq_lines_ ic yield =
  match input_line ic with
    | s -> yield s
    | exception End_of_file -> ()

let parse_record s =
  match Re.exec_opt re s  with
    | None -> None
    | Some g ->
      let author = Re.Group.get g 1 in
      let time = Re.Group.get g 0 in
      let msg = Re.Group.get g 2 in
      Some {author; time; msg}

let seq_record_ ic yield =
  seq_lines_ ic
    (fun l -> match parse_record l with
       | None -> ()
       | Some r -> yield r)

let iter_file file f = with_in file (fun ic -> f (seq_record_ ic))

let rec seq_files_ dir yield =
  let d = Unix.opendir dir in
  finally_
    ~h:(fun d -> Unix.closedir d)
    (fun d ->
       let rec aux () = match Unix.readdir d with
         | s ->
           begin
             if Sys.is_directory s
             then seq_files_ s yield
             else yield s
           end;
           aux ()
         | exception End_of_file -> ()
       in
       aux ())
    d

let iter_dir dir f =
  let seq yield =
    seq_files_ dir
      (fun file ->
         with_in file
           (fun ic -> seq_record_ ic (fun x -> yield (file,x))))
  in
  f seq


