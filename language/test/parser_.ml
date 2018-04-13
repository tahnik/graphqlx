open Core.Std
open Lexer
open Lexing

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    None
  | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

(* part 1 *)
let rec parse_and_print pretty lexbuf =
  match parse_with_error lexbuf with
  | Some value ->
    if pretty = true then Prettify.print (List.rev value);
    parse_and_print pretty lexbuf
  | None -> ()

let print_file filename =
  let rins = match (String.rindex filename) '/' with
    | None -> 0
    | Some value -> value + 1
  in
  let rind = match (String.rindex filename) '.' with
    | None -> 0
    | Some value -> value
  in
  let name = String.sub filename rins (rind - rins) in
  printf "Testing %s: " (String.capitalize name);;

let test (pretty: bool) (filename: string) =
  print_file filename; 
  let inx = In_channel.create filename in
  let lexbuf = Lexing.from_channel inx in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  parse_and_print pretty lexbuf;
  printf "OK\n";
  In_channel.close inx;;

let read_files = 
  if Dir.dir_is_empty "language/test/assets" then
    printf "No Files Found"
  else
    List.iter ~f: (fun name ->
      test true name 
    ) (List.rev (Dir.dir_contents "language/test/assets"));