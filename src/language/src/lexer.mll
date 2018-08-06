(**
 * Name: Lexer
 * 
 * The input for OCamllex. Defines the structure of tokens
 *)

{
  open Lexing
  open Parser

  (* This exception is used when an error is detected *)
  exception SyntaxError of string

  (**
   * Tracks the location of tokens across line breaks
   *)
  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      {
        pos with pos_bol = lexbuf.lex_curr_pos;
        pos_lnum = pos.pos_lnum + 1;
      }
}

let int = '-'? ['0'-'9'] ['0'-'9']*
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let name = ['_' 'a'-'z' 'A'-'Z' ] ['_' 'a'-'z' 'A'-'Z' '0'-'9' ]*

(*
 * These rules are used for reading tokens.
 *
 * Do not move name from the last position.
 * Moving that will cause name to catch everything
 *)
rule read =
  parse
  | white       { read lexbuf }
  | newline     { next_line lexbuf; read lexbuf }
  | "..."       { SPREAD }
  | int         { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | float       { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | "true"      { TRUE }
  | "false"     { FALSE }
  | "null"      { NULL }
  | "query"     { QUERY }
  | "mutation"  { MUTATION }
  | "fragment"  { FRAGMENT }
  | "on"        { ON "on" }
  | '"'         { read_string (Buffer.create 17) lexbuf }
  | '$'         { DOLLAR }
  | '@'         { AT }
  | '{'         { LEFT_BRACE }
  | '}'         { RIGHT_BRACE }
  | '('         { LEFT_PAREN }
  | ')'         { RIGHT_PAREN }
  | '['         { LEFT_BRACK }
  | ']'         { RIGHT_BRACK }
  | ':'         { COLON }
  | '!'         { BANG }
  | ','         { read lexbuf }
  | _           { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  | eof         { EOF }
  | name        { NAME (Lexing.lexeme lexbuf) }

(* rules for reading a string *)
and read_string buf =
  parse
  | '"'       { STRING (Buffer.contents buf) }
  | '\\' '/'  { Buffer.add_char buf '/'; read_string buf lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' 'b'  { Buffer.add_char buf '\b'; read_string buf lexbuf }
  | '\\' 'f'  { Buffer.add_char buf '\012'; read_string buf lexbuf }
  | '\\' 'n'  { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | '\\' 'r'  { Buffer.add_char buf '\r'; read_string buf lexbuf }
  | '\\' 't'  { Buffer.add_char buf '\t'; read_string buf lexbuf }
  | [^ '"' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string buf lexbuf
    }
  | _ { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof { raise (SyntaxError ("String is not terminated")) }
