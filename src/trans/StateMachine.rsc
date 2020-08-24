module trans::StateMachine

import ParseTree;
import IO;

import lang::eflint::Syntax;

void main(loc l) {
  print(parse(#start[Spec], l));
}