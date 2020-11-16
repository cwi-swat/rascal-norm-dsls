module trans::eFLINT

import ParseTree;
import IO;

import lang::eflint::Syntax;
import trans::eflint::asp;

void main(loc l) {
  print(trans(parse(#start[Spec], l).top));
}