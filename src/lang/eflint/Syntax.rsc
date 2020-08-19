module lang::eflint::Syntax

extend lang::std::Layout;

extend lang::expr::records::Syntax;

syntax Spec = Standard Phrase Standard;

syntax Phrase = TypeDecl | Placeholder | assoc Phrase Phrase;

syntax Placeholder = "Placeholder" ID "For" ID;
syntax Query = "?" BoolExpression;
syntax Statement = "+" OptForeach
                 | "-" OptForeach
                 | "Force" OptForeach
                 | OptForeach
                 ;
syntax TypeDecl 
  = "Fact" ID "Identified by" TypeExpression InstanceConstraint? DerivationClause?
  | "Act" ID "Actor" Var ("Recipient" Var)? RelatedTo? InstanceConstraint? PreConditions? PostConditions DerivationClause?
  | "Event" ID RelatedTo? InstanceConstraint? PostConditions DerivationClause?
  | "Duty" ID "Holder" Var "Claimant" Var RelatedTo? InstanceConstraint? DerivationClause? ViolationClause?
  | "Predicate" ID "When" BoolExpression
  | "Invariant" ID ":" BoolExpression
  ;
  
syntax RelatedTo = "Related to" Var ("," Var)*;  
syntax PreConditions = "Conditioned by" BoolExpression ("," BoolExpression)*;
syntax PostConditions = Terminates? Creates?;
syntax Terminates = "Terminates" OptForeach ("," OptForeach)*;
syntax Creates    = "Creates" OptForeach ("," OptForeach)*;
  
syntax InstanceConstraint = "When" BoolExpression;
syntax DerivationClause  = "Derived from" OptForeach
                         | "Holds when" BoolExpression;
syntax ViolationClause   = "Violated when" BoolExpression ("," BoolExpression)*;

keyword Keywords = TypeKeywords | ExprKeywords | Keywords;
keyword ExprKeywords =  "Holds" | "Violated" | "Exists" ;
keyword Keywords = "Event" | "Act" | "Fact" | "Duty"
                 | "Invariant" | "Predicate" | "Placeholder" | "For"
                 | "Actor" | "Recipient" | "Holder" | "Claimant"
                 | "Related to" | "Conditioned by" | "Creates" | "Terminates" | "With"
                 | "Identified by" | "Derived from";