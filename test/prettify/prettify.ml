open Graphql

(* part 1 *)
open Core.Std

let spaces : int ref = ref 0;;

let print_spaces amount = 
  for i = 1 to amount do
    printf " "
  done

let rec print definitions =
  match definitions with
  | [] -> "\n"
  | def::defs -> read_definition def; print defs


and read_definition def =
match def with
  | Operation op ->
    printf "Operation\n";
    read_operation op
  | Fragment fr ->
    printf "Fragment\n"

and read_operation op = match op with
  | {
      optype;
      name;
      variable_definitions;
      directives;
      selection_set;
    } ->
    print_spaces 4;
    (match optype with
    | Query -> printf "Query\n";
    | Mutation -> printf "Mutation\n";
    | Subscription -> printf "Subscription\n");
    print_spaces 4;
    (match name with
    | None -> printf "Shorthand Query\n"
    | Some value -> printf "%s\n" value);

    (* read_var_defs variable_definitions;

and read_var_defs defs =
  List.iter ~f:(fun def ->
    read_var_def def
  ) outc

and read_var_def def = match def with
  | {

    } *)