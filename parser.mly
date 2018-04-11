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

%start <Graphql.document option> prog
%%

prog:
  | EOF       { None }
  | v = value { Some v }
  ;

value:
  | LEFT_BRACE obj = obj_fields RIGHT_BRACE EOF
    { `Assoc obj }
  ;

nestedval:
  | LEFT_BRACE obj = obj_fields RIGHT_BRACE
    { `Assoc obj }
  | LEFT_BRACK vl = list_fields RIGHT_BRACK
    { `List vl }
  | s = STRING
    { `String s }
  | i = INT
    { `Int i }
  | x = FLOAT
    { `Float x }
  | TRUE
    { `Bool true }
  | FALSE
    { `Bool false }
  | NULL
    { `Null }
  ;

obj_fields:
  obj = separated_list(COMMA, obj_field)  { obj } ;

obj_field:
  k = STRING COLON v = nestedval          { (k, v) } ;

list_fields:
  vl = separated_list(COMMA, nestedval)       { vl } ;
