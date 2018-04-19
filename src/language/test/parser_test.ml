(**
 * Name: Parser_test
 *
 * Reads all the graphql files in the ./assets directory
 * and tests them
 *)

open Lexer
open Lexing
open Printf

let print_file filename =
  let rins = String.rindex filename '/' in
  let rind = String.rindex filename '.' in
  let name = String.sub filename (rins + 1) (rind - (rins + 1)) in
  let stringLength: int = String.length name in
  let nLeft: int = 50 - stringLength in
  let sSide: int = nLeft / 2 in
  for i = 0 to sSide do
    printf "=";
  done;
  printf " %s " (String.capitalize name);
  for i = 0 to sSide do
    printf "=";
  done;
  printf "\n";;


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


let test (filename: string) =
  print_file filename;
  printf "\n";
  let strL = read_file filename in
  let str = String.concat "" strL in
  Parse.parse str true;
  printf "TEST RESULT: OK\n\n\n";;


let read_files = 
  if Dir.dir_is_empty "src/language/test/assets" then
    printf "No Files Found"
  else
    List.iter (fun name ->
      test name 
    ) (List.rev (Dir.dir_contents "src/language/test/assets"));