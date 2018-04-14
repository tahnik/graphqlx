open Graphql
open Printf

let spaces : int ref = ref 0;;

let print_spaces amount = 
  for i = 1 to amount do
    printf " "
  done

let rec print definitions =
  spaces := 0;
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
  match selection_set with
  | [] -> ()
  | selection::sel_sets ->
    print_spaces !spaces;
    spaces := !spaces + 2;
    (match selection with
      | Field field -> read_field field
      | FragmentSpread spread -> read_frag_spread spread 
      | InlineFragment frag -> read_inline_frag frag);
    spaces := !spaces - 2;
    read_selection_set sel_sets;

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
    read_arguments arguments 0;
    read_selection_set selection_set;

and read_directives directives =
  match directives with
  | [] -> ()
  | direc::direcs ->
    match direc with
    | {
        name;
        arguments
      } ->
      printf "Name: %s\n" name;
      print_spaces (!spaces - (!spaces - 2));
      read_arguments arguments 0;
    read_directives direcs;

and read_arguments arguments i =
  let length = List.length arguments in
  if length > 0 then
    print_spaces !spaces;
  if length > 0 then
    if i < 1 then printf "Arguments: (";
  match arguments with
  | [] -> ()
  | arg::args ->
    match arg with
    | (key, value) ->
      printf "%s: " key;
      read_value value;
      if i < length - 1 then printf ", " else printf "";
    read_arguments args (i + 1);
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
    | `List ls -> read_list ls 0
    | `Assoc ls -> read_assoc ls 0

and read_list ls i =
  let length = List.length ls in
  if i < 1 then printf "[";
  match ls with
    | [] -> ()
    | value::lss ->
      read_value value;
      if i < length - 1 then printf ", " else printf "";
    read_list lss (i + 1);
  if i == length then printf "]";
  if length == 1 then printf "]";

and read_assoc ls i =
  let length = List.length ls in
  if i < 1 then printf "{ ";
  (match ls with
    | [] -> ()
    | obj::lss ->
      match obj with
      | (key, value) ->
        printf "%s : " key;
        read_value value;
        if i < length - 1 then printf ", " else printf "";
    read_assoc lss (i + 1));
  if i == length then printf " }";
  if length == 1 then printf " }";

and read_var_defs defs =
  let length = List.length defs in
  if length > 0 then print_spaces !spaces;
  match defs with
  | [] -> ()
  | de::des ->
    match de with
    | {
        name;
        typ;
        default_value;
      } ->
      printf "Name: %s\n" name;
      read_type typ;
    read_var_defs des;

and read_type typ =
  match typ with
    | NamedType str ->  printf "Type: %s\n" str
    | ListType tTyp -> read_type tTyp
    | NonNullType tTyp -> read_type tTyp