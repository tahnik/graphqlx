open Lexer
open Lexing
open Printf

let print_file filename =
  let rins = String.rindex filename '/' in
  let rind = String.rindex filename '.' in
  let name = String.sub filename (rins + 1) (rind - rins) in
  printf "Testing %s: " (String.capitalize name);;


let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines ;;

let test (pretty: bool) (filename: string) =
  print_file filename;
  let strL = read_file filename in
  let str = String.concat "" strL in
  Parse.parse str;
  printf "OK\n";;

let read_files = 
  if Dir.dir_is_empty "language/test/assets" then
    printf "No Files Found"
  else
    List.iter (fun name ->
      test true name 
    ) (List.rev (Dir.dir_contents "language/test/assets"));