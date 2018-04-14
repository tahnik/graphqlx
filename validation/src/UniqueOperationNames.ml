open Graphql
open Printf

let rec validate definitions =
  (match definitions with
    | [] -> ()
    | def::defs -> read_definition def; validate defs);


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
      | Subscription -> () );
    (match name with
      | None -> ()
      | Some value -> () );
    read_var_defs variable_definitions;
    read_directives directives;
    read_selection_set selection_set;

and read_selection_set selection_set =
  List.iter (fun selection ->
    (match selection with
      | Field field -> read_field field
      | FragmentSpread spread -> read_frag_spread spread 
      | InlineFragment frag -> read_inline_frag frag);
  ) selection_set

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

and read_directives directives = 
  (match directives with
    | [] -> ()
    | direc::direcs ->
      (match direc with
      | {
          name;
          arguments
        } ->
        read_arguments arguments);
      read_directives direcs;
  );

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
    read_arguments arguments;
    read_selection_set selection_set;

and read_arguments arguments =
let length = List.length arguments in
List.iter (fun (key, value) ->
  read_value value;
) arguments;


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
    | `List ls -> ()
    | `Assoc ls -> ()

and read_list ls =
  List.iter (fun value ->
    read_value value;
  ) ls;

and read_assoc ls =
  List.iter (fun (key, value) ->
    read_value value;
  ) ls

and read_var_defs defs =
  List.iter (fun def ->
  match def with
    | {
        name;
        typ;
        default_value;
      } ->
      read_type typ;
  ) defs

and read_type typ =
  match typ with
    | NamedType str ->  ()
    | ListType tTyp -> read_type tTyp
    | NonNullType tTyp -> read_type tTyp