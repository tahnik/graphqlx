open Types
open Printf

let numberOfShorthands: int ref = ref 0;;
let error: bool ref = ref false;;

let rec read_doc definitions =
  (match definitions with
    | [] -> ()
    | def::defs -> read_definition def; read_doc defs)


and read_definition def =
  match def with
    | Operation op ->
      if !numberOfShorthands > 0 then
        error := true;
      if !numberOfShorthands > 0 then
        printf "\nvalidation error: shorthand query cannot co-exist with other queries\n";
      read_operation op;
    | _ -> ()


and read_operation op =
  match op with
    | {
        optype;
        name;
        variable_definitions;
        directives;
        selection_set;
      } ->
      (match optype with
        | Query -> ()
        | Mutation -> ()
        | Subscription -> ());
      (match name with
        | None -> numberOfShorthands := !numberOfShorthands + 1;
        | Some value -> ());;

let validate definitions =
  error := false;
  numberOfShorthands := 0;
  read_doc definitions;
  !error