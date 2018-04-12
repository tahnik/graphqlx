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
  | definitions = read_definitions
    LEFT_BRACE selection_set = read_selections RIGHT_BRACE EOF
    {
      Operation {
        optype=Query;
        name=None;
        variable_definitions=[];
        directives=[];
        selection_set=selection_set;
      }::definitions
    }
  | definitions = read_definitions
    STRING name = STRING STRING type_condition = NAME
    LEFT_BRACE selection_set = read_selections RIGHT_BRACE
    {
      Fragment {
        name=name;
        type_condition=type_condition;
        directives=[];
        selection_set=selection_set;
      }::definitions
    }
  ;

read_selections:
  | { [] }
  (* Field *)
  | selections = read_selections
    alias = read_alias
    name = NAME
    /* arguments = read_arguments */
    /* directives = read_directives */
    {
      Field {
        alias=None; name=name;
        arguments=[];
        directives=[];
        selection_set=[];
      }::selections
    }
  ;

read_alias:
  | { None }
  | read_alias name = NAME COLON
    { Some name }
  ;

read_arguments:
  | { [] }
  | arguments = read_arguments
    RIGHT_PAREN argument = read_argument LEFT_PAREN
    { argument::arguments }
  ;

read_argument:
  | name = STRING COLON value = read_value
    { (name, value) }
  ;

read_value:
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
  | value = NAME
    { `Enum value }
  | LEFT_BRACK value = read_list RIGHT_BRACK
    { `List value }
  | LEFT_BRACE value = read_object RIGHT_BRACE
    { `Assoc value }

read_list:
  | { [] }
  | listVal = read_list value = read_value 
    { value::listVal }

read_object:
  | { [] }
  | fields = read_object key = STRING COLON value = read_value
    { (key, value)::fields }

read_directives:
  | { [] }
  | directives = read_directives AT name = NAME arguments = read_arguments
    {
      { name=name; arguments=arguments }::directives
    }