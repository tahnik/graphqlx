%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token NULL
%token TRUE
%token FALSE
%token LEFT_BRACE
%token RIGHT_BRACE
%token LEFT_BRACK
%token RIGHT_BRACK
%token COLON
%token COMMA
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
  | v = value { Some v }
  ;

value:
  | defs = read_defs EOF
    { defs }
  ;

read_defs:
  def = read_def defs = read_defs { def::defs }

read_def:
  | LEFT_BRACE selection_set = read_selections RIGHT_BRACE
    {
      Operation {
        optype=Query;
        name=None;
        variable_definitions=[];
        directives=[];
        selection_set=selection_set;
      }
    }
  | STRING name = STRING STRING type_condition = NAME
    LEFT_BRACE selection_set = read_selections RIGHT_BRACE
    {
      Fragment {
        name=name;
        type_condition=type_condition;
        directives=[];
        selection_set=selection_set;
      }
    }
  ;

read_selections:
  {[]}
  ;
