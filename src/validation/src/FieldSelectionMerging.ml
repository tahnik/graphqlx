open Graphql
open Printf

let error: bool ref = ref false;;
let listOfNames: string list ref = ref [];;

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
    read_selection_set selection_set;

and read_selection_set selection_set =
  match selection_set with
  | [] -> ()
  | selection::sel_sets ->
    (match selection with
      | Field field -> read_field field
      | FragmentSpread spread -> ()
      | InlineFragment frag -> read_inline_frag frag);
    read_selection_set sel_sets;


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
    let exists = List.exists (fun x -> compare x name == 0) !listOfNames in
    if exists == false then listOfNames := !listOfNames@[name];
    (match alias with
      | None -> ()
      | Some alias -> (
        let redFlag: bool ref = ref false in
        let alexists = List.exists (fun x -> compare x alias == 0) !listOfNames in
        if alexists then
        (
          error := true
        )
      );
    );
    read_selection_set selection_set;;


let validate definitions =
  read_doc definitions;
  !error