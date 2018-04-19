open Graphql
open Printf

let error: bool ref = ref false;;
let listOfArgs: string list ref = ref [];;

let rec read_doc definitions =
  (match definitions with
    | [] -> ()
    | def::defs -> read_definition def; read_doc defs);


and read_definition def =
match def with
  | Operation op ->
    read_operation op
  | Fragment fr ->
    read_fragment fr

and read_fragment fr =
match fr with
  | {
      name;
      type_condition;
      directives;
      selection_set;
    } ->
    read_directives directives;
    read_selection_set selection_set;

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
      | None -> ()
      | Some value -> ());
    read_var_defs variable_definitions;
    read_directives directives;
    read_selection_set selection_set;

and read_selection_set selection_set =
  match selection_set with
  | [] -> ()
  | selection::sel_sets ->
    (match selection with
      | Field field -> read_field field
      | FragmentSpread spread -> read_frag_spread spread 
      | InlineFragment frag -> read_inline_frag frag);
    read_selection_set sel_sets;

and read_frag_spread spread = 
  match spread with
    | {
        name;
        directives;
      } ->
      read_directives directives;

and read_inline_frag frag =
  match frag with
    | {
        type_condition;
        directives;
        selection_set;
      } ->
      (match type_condition with
      | None -> ()
      | Some typ -> ());
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
      | None -> ()
      | Some alias -> ());
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
      read_arguments arguments 0;
    read_directives direcs;

and read_arguments arguments i =
  let length = List.length arguments in
  match arguments with
  | [] -> listOfArgs := []
  | arg::args ->
    match arg with
    | (key, value) ->
      let exists = List.exists (fun x -> compare x key == 0) !listOfArgs in
      if exists then
      (
        error := true;
        printf "\nvalidation error: arguments cannot have duplicate names\n";
      );
      listOfArgs := !listOfArgs@[key];
      read_value value;
    read_arguments args (i + 1);


and read_value value =
  match value with
    | `Variable vari -> ()
    | `Null -> ()
    | `Int intVal -> ()
    | `Float floatVal -> ()
    | `String str -> ()
    | `Bool bl ->
      (match bl with
        | true -> ()
        | false -> ())
    | `Enum en -> ()
    | `List ls -> read_list ls 0
    | `Assoc ls -> read_assoc ls 0

and read_list ls i =
  let length = List.length ls in
  match ls with
    | [] -> ()
    | value::lss ->
      read_value value;
    read_list lss (i + 1);

and read_assoc ls i =
  let length = List.length ls in
  (match ls with
    | [] -> ()
    | obj::lss ->
      match obj with
      | (key, value) ->
        read_value value;
    read_assoc lss (i + 1));

and read_var_defs defs =
  let length = List.length defs in
  match defs with
  | [] -> ()
  | de::des ->
    match de with
    | {
        name;
        typ;
        default_value;
      } ->
      read_type typ;
    read_var_defs des;

and read_type typ =
  match typ with
    | NamedType str -> ()
    | ListType tTyp -> read_type tTyp
    | NonNullType tTyp -> read_type tTyp;;

let validate definitions =
  read_doc definitions;
  !error