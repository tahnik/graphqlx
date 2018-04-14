open Lexing
open Printf
open Pervasives

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | Lexer.SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    None
  | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

let rec parse_and_print lexbuf =
  let returnVal: Graphql.document ref = ref [] in
  (match parse_with_error lexbuf with
  | Some value ->
    returnVal := value;
    ignore(parse_and_print lexbuf);
  | None -> ());
  !returnVal;;

let parse (graphql: string) =
  let lexbuf = Lexing.from_string graphql in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = graphql };
  parse_and_print lexbuf;;

let parse_from_buf buf =
  parse_and_print buf;;