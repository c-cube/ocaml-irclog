
(** {1 Small Parser for IRC Logs} *)

type 'a sequence = ('a -> unit) -> unit

(** One message in a IRC log *)
type log_record = {
  author: string;
  time: string;
  msg: string;
}

val re : Re.re

val norm_author : string -> string
(** Normalize the nicknames a bit *)

val parse_record : string -> log_record option

val string_of_record : log_record -> string

val iter_records : file:string -> log_record sequence

val iter_files : dir:string -> string sequence
(** [iter_files d] iterates on the files (not directories) that can
    be found under [d] *)

val iter_records_dir : dir:string -> (string * log_record) sequence
(** [iter_files dir] calls {!iter_records} on every file under [dir],
    recursively, yielding a sequence of [(file, record)] *)
