%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token NULL
%token TRUE
%token FALSE
%token LEFT_BRACE
%token RIGHT_BRACE
%token LEFT_PAREN
%token RIGHT_PAREN
%token LEFT_BRACK
%token RIGHT_BRACK
%token COLON
%token EOF
%token DOLLAR
%token BANG
%token SPREAD
%token EQUAL
%token AT
%token BAR
%token POUND
%token <string> NAME

%token QUERY
%token MUTATION
%token FRAGMENT
%token <string> ON

%{
  open Graphql
%}


%start <Graphql.document option> prog
%%

prog:
  | EOF       { None }
  | v = read_document { Some v }
  ;

read_document:
  | definitions = read_definitions EOF
    { definitions }
  ;

read_definitions:
  | { [] }
  (* Short hand queries *)
  | definitions = read_definitions
    selection_set = read_selection_set EOF
    {
      Operation {
        optype=Query;
        name=None;
        variable_definitions=[];
        directives=[];
        selection_set=selection_set;
      }::definitions
    }
  (* Operation Definition *)
  | definitions = read_definitions
    optype = read_optype name = read_name
    variable_definitions = read_variable_definitions
    directives = read_directives
    selection_set = read_selection_set
    {
      Operation {
        optype=optype;
        name=None;
        variable_definitions=variable_definitions;
        directives=directives;
        selection_set=selection_set;
      }::definitions
    }
  | definitions = read_definitions
    FRAGMENT name = read_fragment_name type_condition = read_type_condition
    directives = read_directives
    selection_set = read_selection_set
    {
      Fragment {
        name=name;
        type_condition=type_condition;
        directives=directives;
        selection_set=selection_set;
      }::definitions
    }
  ;


read_optype:
  | QUERY
    { Query }
  | MUTATION
    { Mutation }

read_selection_set:
  | { [] }
  | read_selection_set LEFT_BRACE selections = read_selection RIGHT_BRACE
    { selections }

read_selection:
  | { [] }
  (* Field *)
  | selections = read_selection
    alias = read_alias
    name = read_name
    arguments = read_arguments
    directives = read_directives
    selection_set = read_selection_set
    {
      Field {
        alias=None; name=name;
        arguments=arguments;
        directives=directives;
        selection_set=selection_set;
      }::selections
    }
  (* Fragment Spread *)
  | selections = read_selection
    SPREAD fname = read_fragment_name directives = read_directives
    {
      FragmentSpread {
        name=fname; directives=directives
      }::selections
    }
  (* inline fragment *)

read_type_condition:
  ON named_type = read_name
  { named_type }

read_alias:
  | { None }
  | read_alias name = read_name COLON
    { Some name }

read_arguments:
  | { [] }
  | arguments = read_arguments
    LEFT_PAREN argument = read_argument RIGHT_PAREN
    { argument::arguments }

read_argument:
  | name = read_name COLON value = read_value
    { (name, value) }

read_value:
  | value = read_variable
    { `Variable value }
  | value = STRING
    { `String value }
  | value = INT
    { `Int value }
  | value = FLOAT
    { `Float value }
  | value = TRUE
    { `Bool true }
  | value = FALSE
    { `Bool false }
  | value = NULL
    { `Null }
  | value = read_name
    { `Enum value }
  | LEFT_BRACK value = read_list RIGHT_BRACK
    { `List value }
  | LEFT_BRACE value = read_object RIGHT_BRACE
    { `Assoc value }

read_const_value:
  | value = STRING
    { `String value }
  | value = INT
    { `Int value }
  | value = FLOAT
    { `Float value }
  | value = TRUE
    { `Bool true }
  | value = FALSE
    { `Bool false }
  | value = NULL
    { `Null }
  | value = read_name
    { `Enum value }
  | LEFT_BRACK value = read_const_list RIGHT_BRACK
    { `List value }
  | LEFT_BRACE value = read_const_object RIGHT_BRACE
    { `Assoc value }

read_list:
  | { [] }
  | listVal = read_list value = read_value 
    { value::listVal }

read_const_list:
  | { [] }
  | listVal = read_const_list value = read_const_value 
    { value::listVal }

read_object:
  | { [] }
  | fields = read_object key = STRING COLON value = read_value
    { (key, value)::fields }
    
read_const_object:
  | { [] }
  | fields = read_const_object key = STRING COLON value = read_const_value
    { (key, value)::fields }

read_directives:
  | { [] }
  | directives = read_directives AT name = read_name arguments = read_arguments
    {
      { name=name; arguments=arguments }::directives
    }

read_variable_definitions:
  | { [] }
  | definitions = read_variable_definitions
    LEFT_PAREN definition = read_variable_definition RIGHT_PAREN
    { definition::definitions }

read_variable_definition:
  | name = read_variable COLON
    typ = read_type
    default_value = option(read_const_value)
    {
      { name=name; typ=typ; default_value=default_value }
    }

read_variable:
  | DOLLAR value = read_name
    { value }

read_type:
  | value = read_name
    { NamedType value }
  | LEFT_BRACK value = read_type RIGHT_BRACK
    { ListType value }
  | value = read_type BANG
    { NonNullType value }

read_fragment_name:
  | value = NAME
    { value }

read_name:
  | value = ON
    { value }
  | value = NAME
    { value }