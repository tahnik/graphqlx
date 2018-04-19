open Graphql
open Printf

let error: bool ref = ref false;;
let listOfNames: string list ref = ref [];;

let rec checkIfExists names name =
  match names with
  | [] -> listOfNames := names@[name]
  | n::ns ->
      if (compare n name == 0) then
        (printf("\nvalidation error: A query name can only be used once\n");
        error := true);
    checkIfExists ns name

let rec read_doc definitions =
  (match definitions with
    | [] -> ()
    | def::defs -> read_definition def; read_doc defs)

and read_definition def =
match def with
  | Operation op ->
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
    match name with
      | None -> ()
      | Some value -> checkIfExists !listOfNames value;;

let validate definitions =
  listOfNames = ref [];
  read_doc definitions;
  !error;