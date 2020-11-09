module Plugin

import lang::eflint::Syntax;
import lang::eflint::Parser;

import util::IDE;

import ParseTree;

anno map[loc,str] Tree@docs;
 
void main() {
  str lang = "eFlint";

  registerLanguage(lang,"eflint", parseSpec); 
  
  contribs = {
    syntaxProperties(#start[Spec])
  };
  
  registerContributions(lang, contribs);
} 

