open Graphql

(* part 1 *)
open Core.Std

let spaces : int ref = ref 0;;

let print_spaces amount = 
  for i = 1 to amount do
    printf " "
  done

let rec print definitions =
  (match definitions with
    | [] -> printf "\n"
    | def::defs -> read_definition def; print defs);


and read_definition def =
match def with
  | Operation op ->
    printf "Operation\n";
    read_operation op
  | Fragment fr ->
    printf "Fragment\n";
    read_fragment fr

and read_fragment fr =
match fr with
  | {
      name;
      type_condition;
      directives;
      selection_set;
    } ->
    spaces := !spaces + 2;
    print_spaces !spaces;
    printf "Name: %s\n" name;
    print_spaces !spaces;
    printf "Type Condition: %s\n" type_condition;
    spaces := !spaces + 2;
    read_directives directives;
    read_selection_set selection_set;
    spaces := !spaces - 4;

and read_operation op =
match op with
  | {
      optype;
      name;
      variable_definitions;
      directives;
      selection_set;
    } ->
    spaces := !spaces + 2;
    print_spaces !spaces;
    (match optype with
      | Query -> printf "Query\n";
      | Mutation -> printf "Mutation\n";
      | Subscription -> printf "Subscription\n");
    print_spaces !spaces;
    (match name with
      | None -> printf "Shorthand Query\n"
      | Some value -> printf "Name: %s\n" value);
    spaces := !spaces + 2;
    read_var_defs variable_definitions;
    read_directives directives;
    read_selection_set selection_set;
    spaces := !spaces - 4;

and read_selection_set selection_set =
  List.iter ~f:(fun selection ->
    print_spaces !spaces;
    spaces := !spaces + 2;
    (match selection with
      | Field field -> read_field field
      | FragmentSpread spread -> read_frag_spread spread 
      | InlineFragment frag -> read_inline_frag frag);
    spaces := !spaces - 2;
  ) selection_set

and read_frag_spread spread = 
  printf "Fragment Spread\n";
  match spread with
    | {
        name;
        directives;
      } ->
      print_spaces !spaces;
      printf "Name: %s\n" name;
      read_directives directives;

and read_inline_frag frag =
  printf "Inline Fragment\n";
  print_spaces !spaces;
  match frag with
    | {
        type_condition;
        directives;
        selection_set;
      } ->
      (match type_condition with
      | None -> printf ""
      | Some typ -> printf "Type Condition: %s\n" typ);
      read_directives directives;
      read_selection_set selection_set;

and read_field field =
  match field with
  | {
      alias;
      name;
      arguments;
      directives;
      selection_set;
    } ->
    (match alias with
      | None -> printf ""
      | Some alias -> printf "Alias: %s\n" alias);
    printf "Name: %s\n" name;
    read_arguments arguments;
    read_selection_set selection_set;

and read_directives directives = 
  List.iter ~f:(fun directive ->
    match directive with
    | {
        name;
        arguments
      } ->
      printf "Name: %s\n" name;
      print_spaces (!spaces - (!spaces - 2));
      read_arguments arguments;
  ) directives

and read_arguments arguments =
let length = List.length arguments in
if length > 0 then
  print_spaces !spaces;
if length > 0 then
  printf "Arguments: (";
let i: int ref = ref 0 in
List.iter ~f:(fun (key, value) ->
  printf "%s: " key;
  read_value value;
  i := !i + 1;
  if !i < length then printf ", " else printf ""
) arguments;
if length > 0 then printf ")\n";


and read_value value =
  match value with
    | `Variable vari -> printf "%s" vari
    | `Null -> printf "Null"
    | `Int intVal -> printf "%d" intVal
    | `Float floatVal -> printf "%f" floatVal
    | `String str -> printf "%s" str
    | `Bool bl ->
      (match bl with
        | true -> printf "true"
        | false -> printf "false")
    | `Enum en -> printf "%s" en
    | `List ls -> read_list ls
    | `Assoc ls -> read_assoc ls

and read_list ls =
  let length = List.length ls in
  printf "[";
  let i: int ref = ref 0 in
  List.iter ~f:(fun value ->
    read_value value;
    i := !i + 1;
    if !i < length then printf ", " else printf ""
  ) ls;
  printf "]";

and read_assoc ls =
  printf "Object\n";
  List.iter ~f:(fun (key, value) ->
    printf "%s: " key;
    read_value value;
  ) ls

and read_var_defs defs =
  List.iter ~f:(fun def ->
  print_spaces !spaces;
  match def with
    | {
        name;
        typ;
        default_value;
      } ->
      printf "Name: %s\n" name;
      read_type typ;
  ) defs

and read_type typ =
  match typ with
    | NamedType str ->  printf "Type: %s\n" str
    | ListType tTyp -> read_type tTyp
    | NonNullType tTyp -> read_type tTyp