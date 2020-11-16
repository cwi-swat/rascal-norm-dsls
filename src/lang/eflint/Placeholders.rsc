module lang::eflint::Placeholders

import lang::eflint::Syntax;

import IO;

map[str,str] get_alias_map(s) {
   map[str,str] res = ();
   bottom-up visit(s) {
    case (Decl) `Placeholder <ID ID1> For <ID ID2>`: res = res + ("<ID1>" : "<ID2>");
  } 
  return res;
}

str chase_aliases(map[str,str] amap, str ty) = chase_aliases(amap, amap[ty])
  when ty in amap;
str chase_aliases(map[str,str] amap, str ty) = ty
  when ty notin amap;