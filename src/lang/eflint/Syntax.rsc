module lang::eflint::Syntax

extend lang::std::Layout;

lexical Integer = [0-9]+ !>> [0-9];
lexical Letter = [a-zA-Z];
lexical Cap    = [A-Z];
lexical Lower  = [a-z];
lexical ID = Lower IdChar* !>> [A-Za-z0-9_\-] ;
lexical Identifier = ID;
lexical IdChar = (Letter | [0-9] | [_\-]);
lexical String = Cap IdChar*;
lexical StringLiteral = String \ Keywords;
lexical Literal = StringLiteral | Integer;
lexical Decoration = Integer? "\'"*; 
lexical Var = ID id Decoration dec;

start syntax Spec = Decl;
start syntax Script = Command;

syntax Decl = TypeDecl | Placeholder | assoc Decl Decl;

syntax Command = Statement | Query | assoc Command Command; 

syntax Query = "?" Expression;
syntax Statement = "+" OptForeach
                 | "-" OptForeach
                 | "Force" OptForeach
                 | OptForeach
                 ;

syntax Placeholder = "Placeholder" ID "For" ID;
syntax TypeDecl 
  = "Fact" ID ("Identified" "by" TypeExpression)? InstanceConstraint? DerivationClause?
  | "Act" ID "Actor" Var ("Recipient" Var)? RelatedTo? InstanceConstraint? PostConditions DerivationClause?
  | "Event" ID RelatedTo? InstanceConstraint? PostConditions DerivationClause?
  | "Duty" ID "Holder" Var "Claimant" Var RelatedTo? InstanceConstraint? DerivationClause? ViolationClause?
  | "Predicate" ID "When" Expression
  | "Invariant" ID ":" Expression
  ;
  
syntax RelatedTo = "Related" "to" {Var ","}+;  
syntax PostConditions = Terminates? Creates?;
syntax Terminates = "Terminates" {OptForeach ","}+;
syntax Creates    = "Creates" {OptForeach ","}+;
  
syntax InstanceConstraint = "When" Expression;
syntax DerivationClause  = "Derived" "from" OptForeach
                         | "Holds" "when" Expression;
syntax ViolationClause   = "Violated" "when" {Expression ","}+;


syntax TypeExpression = "String" | "Int" | { Literal ","}+ | {Var "*"}+;


syntax Expression = Integer | StringLiteral | Var | "True" | "False" | bracket "(" Expression ")"
                  > "!" Expression
                  | "Not" Expression
                  | "Holds" Expression
                  | "Violated" Expression
                  > "Sum" Foreach
                  | "Count" Foreach
                  > Expression "." Var
                  | Application
                  > left (Expression "*" Expression
                  |       Expression "/" Expression)
                  > left (Expression "-" Expression
                  |       Expression "+" Expression)
                  > left (Expression "||" Expression
                  |       Expression "&&" Expression)
                  > non-assoc (Expression "==" Expression
                            || Expression "!=" Expression
                            || Expression "\<"  Expression 
                            || Expression "\>"  Expression)
                  > left Expression "When" Expression
                  | "(" "Exists" {Var ","}+ ":" Expression ")"
                  | "(" "Forall" {Var ","}+ ":" Expression ")"
                  ; 

syntax Foreach = "(" "Foreach" {Var ","}+ ":" Expression ")";
syntax OptForeach = Foreach | Expression;
syntax Application = ID "(" Arguments ")";
syntax Arguments = { Modifier ","}+ 
                 | { Expression ","}+;
syntax Modifier = Var "=" Expression;

keyword Keywords = "Event" | "Act" | "Fact" | "Duty"
                 | "Invariant" | "Predicate" | "Placeholder" | "For"
                 | "Actor" | "Recipient" | "Holder" | "Claimant"
                 | "Related to" | "Conditioned by" | "Creates" | "Terminates" | "With"
                 | "Identified by" | "Derived from"
                 | TypeKeywords | ExprKeywords;
                 
keyword TypeKeywords = "String" | "Int";
keyword ExprKeywords = "Not" | "True" | "False" | "Sum" | "When" | "Holds when" | "Holds"
                     | "Count" | "Enabled" | "Violated when" | "Violated" | "Exists" 
                     | "Forall"| "Foreach" | "Event" | "Act" | "Fact" | "Duty"
                     | "Invariant" | "Predicate" | "Actor" | "Recipient" | "Related to" 
                     | "Conditioned by" | "Creates" | "Terminates" | "With"
                     | "Identified by" | "Derived from" | "Placeholder" | "For";
                 