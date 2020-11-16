module trans::asp::Util

import List;

str csv(list[str] Xs) = intercalate(",", Xs);

str term(Id, list[str] Vars) = "<Id>(<Vars>))";