open Lexing
open Printf

let validate (str: string) =
  let lexbuf = Lexing.from_string str in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = str };
  let ast = (Parse.parse_from_buf lexbuf) in
  UniqueOperationNames.validate ast;
  LoneAnonymousOperation.validate;