module trans::eflint::asp

import lang::eflint::Syntax;
import lang::eflint::Placeholders;
import trans::asp::Util;

import String;
import Maybe;

str trans((Spec) `<Decl decl>`) = 
 "#include \"assets/ndec.clingo\".
 '<trans(get_alias_map(decl),decl)>
 ";
           
str trans(amap, (Decl) `<Decl D1> <Decl D2>`) = "<trans(amap, D1)>\n<trans(amap, D2)>";           
str trans(amap, (Decl) `Fact <ID Id>`) = "";
str trans(amap, (Decl) `Fact <ID Id> Identified by String`) = "";
str trans(amap, (Decl) `Fact <ID Id> Identified by Int`) = "";
str trans(amap, (Decl) `Fact <ID Id> Identified by <{Literal ","}+ Lits>`) = 
  ( "" | "<Id>(<Lit>).\n<it>" | Lit <- Lits);
str trans(amap, (Decl) `Fact <ID Id> Identified by <{Var ","}+ Vs> <InstanceConstraint? Ic> <DerivationClause? Dc>`) = 
  trans_record_decl(amap, Id,Vs,Ic,Dc);
default str trans(amap, Decl D) = "";
  
  
str trans_record_decl(amap, Id, Vars, Ic, Dcs) =
 "<instance_check_record(amap, Id, Vs, Ic)>
 '<derivation_record(amap, Id, Vs, [ Dc | Dc <- Dcs] )>"
 when Vs := [ Var | Var <- Vars ];

str instance_check_record(amap, Id, list[Var] Vs, Ic) = 
  "<Id>(<csv(CVars)>) :- <csv(typechecks(amap, Vs))>."
  when 
    CVars := to_vars(Vs);
    
str derivation_record(amap, Id, list[Var] Vs, []) = "";
str derivation_record(amap, Id, list[Var] Vs, [Dc]) = 
  "derivedAt(<term(Id, csv(CVars))>, T) :- <Vs>"
  when CVars := to_vars(Vs)
    && (DerivationClause) `Holds when <Expression Expr>` := Dc; 
    
    
list[str] typechecks(amap, Vs) = [ typecheck(amap, V) | V <- Vs ];
str typecheck(amap, Var V) = "<cons>(<to_var(V)>)"
  when cons := chase_aliases(amap, "<V.id>"); 

    
list[str] to_vars(Vs) = [ to_var(V) | V <- Vs ];
str to_var(V) = capitalize("<V>");

str trans((Expression) `True`) = "0{}0";
str trans((Expression) `False`) = "1{}1";
str trans((Expression) `(<Expression Expr>)`) = trans(Expr);
str trans((Expression) `!<Expression Expr>`) = "not (<trans(Expr)>)";
str trans((Expression) `Not<Expression Expr>`) = "not (<trans(Expr)>)";
str trans((Expression) `Holds<Expression Expr>`) = "derivedAt(<trans(Expr)>,T)";
str trans((Expression) `Violated<Expression Expr>`) = "violatedAt(<trans(Expr)>,T)";
str trans((Expression) `<Expression E1> && <Expression E2>`) = "<trans(E1)>,<trans(E2)>";

str trans((Expression) `<Var Var>`) = to_var(Var);
str trans((Expression) `<Integer I>`) = "<I>";
str trans((Expression) `<StringLiteral S>`) = "<S>";
str trans((Expression) `(<Expression Expr>)`) = trans(Expr);
str trans((Expression) `<ID ID>(<{Expression ","}+ Exprs>)`) = term(Id, transs(Exprs));

list[str] transs(Exprs) = [ trans(Expr) | Expr <- Exprs ];