(**
 * Name: Parse
 *
* The front-end for parser. Exposes necessary functions for parsing
 *)

open Lexing
open Printf
open Pervasives

(* For priting the position of an error *)
let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)


(* Uses the Parser and prints error if there is any *)
let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | Lexer.SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    None
  | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    None;;

(* Helper function for parsing *)
let rec parse_and_print lexbuf =
  let ast: Types.document ref = ref [] in
  (match parse_with_error lexbuf with
  | Some value ->
    ast := value;
    ignore(parse_and_print lexbuf);
  | None -> ());
  !ast;;


(**
 * The entry point for parsing. Takes a string as input and returns the AST
 *)
let parse (graphql: string) (pretty_print: bool) =
  let lexbuf = Lexing.from_string graphql in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = graphql };
  let ast = parse_and_print lexbuf in
  if pretty_print then Prettify.print ast;
  ast;;
  

(* Similar to parse but takes a input buffer instead of string *)
let parse_from_buf buf =
  let ast = parse_and_print buf in
  Prettify.print ast;
  ast;