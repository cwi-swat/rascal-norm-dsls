module lang::eflint::Parser

import lang::eflint::Syntax;

import ParseTree;

start[Spec] parseSpec(loc file)        = parse(#start[Spec], file);
start[Spec] parseSpec(str x, loc file) = parse(#start[Spec], x, file);
start[Spec] parseSpec(str x)           = parse(#start[Spec], x);
