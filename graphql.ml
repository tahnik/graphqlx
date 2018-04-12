type primitive_value = [
  | `Null
  | `Int of int
  | `Float of float
  | `String of string
  | `Bool of bool
  | `Enum of string
]

type const_value = [
  | primitive_value
  | `List of const_value list
  | `Assoc of (string * const_value) list
]

type value = [
  | primitive_value
  | `Variable of string
  | `List of value list
  | `Assoc of (string * value) list
]

type directive = {
  name : string;
  arguments : (string * value) list;
}

type fragment_spread = {
  name : string;
  directives : directive list;
}

type selection =
  | Field          of field
  | FragmentSpread of fragment_spread
  | InlineFragment of inline_fragment

and field = {
  alias : string option;
  name : string;
  arguments : (string * value) list;
  directives : directive list;
  selection_set : selection list;
}

and inline_fragment = {
  type_condition : string option;
  directives : directive list;
  selection_set : selection list;
}

type fragment = {
  name : string;
  type_condition : string;
  directives : directive list;
  selection_set : selection list;
}

type typ =
  | NamedType   of string
  | ListType    of typ
  | NonNullType of typ

type variable_definition = {
  name : string;
  typ : typ;
  default_value : const_value option;
}

type optype =
  | Query
  | Mutation
  | Subscription

type operation = {
  optype : optype;
  name   : string option;
  variable_definitions : variable_definition list;
  directives : directive list;
  selection_set : selection list;
}

type definition =
  | Operation of operation
  | Fragment of fragment

type document =
  definition list


(* part 1 *)
open Core.Std
let rec output_value outc =
  List.iter ~f:(fun def ->
    read_definition def
  ) outc

and read_definition def = match def with
  | Operation op ->
    printf "Operation\n";
    read_operation op

and read_operation op = match op with
  | {
      optype;
      name;
      variable_definitions;
      directives;
      selection_set;
    } ->
    (match optype with
    | Query -> printf "Query\n";
    | Mutation -> printf "Mutation\n";
    | Subscription -> printf "Subscription\n");
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
