open Lexing
open Printf

let error: bool ref = ref false;;

let validate (str: string) =
  error := false;
  let lexbuf = Lexing.from_string str in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = str };
  let ast = (Parse.parse_from_buf lexbuf) in
  error := UniqueOperationNames.validate ast;
  error := LoneAnonymousOperation.validate ast;
  !error;