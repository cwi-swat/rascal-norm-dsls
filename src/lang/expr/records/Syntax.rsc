module lang::expr::records::Syntax

extend lang::std::Layout;

import ParseTree;

lexical Integer = [0-9]+ !>> [0-9];
lexical Letter = [a-zA-Z];
lexical Cap    = [A-Z];
lexical Lower  = [a-z];
lexical ID = Lower IdChar* !>> [A-Za-z0-9_\-] ;
lexical Identifier = ID;
lexical TypeId = ID;
lexical IdChar = (Letter | [0-9] | [_\-]);
lexical String = Cap IdChar*;
lexical StringLiteral = String \ Keywords;
lexical Literal = StringLiteral | Integer;
lexical Decoration = Integer? "\'"*; 
lexical Var = ID Decoration;

syntax TypeExpression = "String" | "Int" | { Literal ","}+ | {TypeId "*"}+;


syntax InstExpression = Integer | StringLiteral | Var | bracket "(" InstExpression ")"
                  > "Sum" Foreach
                  | "Count" Foreach
                  > InstExpression "." Var
                  | Application
                  > left (InstExpression "*" InstExpression
                  |       InstExpression "/" InstExpression)
                  > left (InstExpression "-" InstExpression
                  |       InstExpression "+" InstExpression)
                  > left InstExpression "When" BoolExpression
                  ; 

syntax BoolExpression = "True" | "False" | "(" BoolExpression ")" 
                  > 
                  | "!" BoolExpression
                  | "Not" BoolExpression
                  | "Holds" InstExpression
                  | "Violated" InstExpression
                  | "Enabled" InstExpression
                  > left (BoolExpression "||" BoolExpression
                  |       BoolExpression "&&" BoolExpression)
                  > non-assoc (InstExpression "==" InstExpression
                            || InstExpression "!=" InstExpression
                            || InstExpression "\<"  InstExpression 
                            || InstExpression "\>"  InstExpression)
                  > left BoolExpression "When" BoolExpression
                  | "(" "Exists" {Var ","}+ ":" BoolExpression ")"
                  | "(" "Forall" {Var ","}+ ":" BoolExpression ")"
                  ; 

syntax Foreach = "(" "Foreach" {Var ","}+ ":" InstExpression ")";
syntax OptForeach = Foreach | InstExpression;
syntax Application = ID "(" Arguments ")";
syntax Arguments = { Modifier ","}* 
                 | { InstExpression ","}+;
syntax Modifier = Var "=" InstExpression;

keyword Keywords = TypeKeywords | ExprKeywords;
keyword TypeKeywords = "String" | "Int";
keyword ExprKeywords = "Not" | "True" | "False" | "Sum" | "When" | "Holds when" | "Holds"
                     | "Count" | "Enabled" | "Violated when" | "Violated" | "Exists" 
                     | "Forall"| "Foreach" | "Event" | "Act" | "Fact" | "Duty"
                     | "Invariant" | "Predicate" | "Actor" | "Recipient" | "Related to" 
                     | "Conditioned by" | "Creates" | "Terminates" | "With"
                     | "Identified by" | "Derived from" | "Placeholder" | "For";