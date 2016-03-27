
(** {1 Small Parser for IRC Logs} *)

type 'a sequence = ('a -> unit) -> unit

(** One message in a IRC log *)
type log_record = {
  author: string;
  time: string;
  msg: string;
}

val re : Re.re

val parse_record : string -> log_record option

val iter_file : string -> log_record sequence

val iter_dir : string -> (string * log_record) sequence
