'' ppmodule.bi -- the preprocessor's per-unit state for '#module', '#import' and
'' '#export' (ADR 0017). See ppmodule.bas. Engine-private: included by pp.bas only.

#pragma once

#include once "pp/pp.bi"

namespace Tko

type PpModState
    '' Directives read in the ROOT file so far, '#lang' excepted. '#module' has to be
    '' the first, so the count it sees must be exactly one: itself.
    as long      directives
    '' A token that is not an end of line has been emitted, anywhere.
    as boolean   sawToken
    '' THE HEADER HAS ENDED: '#import' is no longer allowed. Set by the first token, and
    '' by the first directive that is not one the header may contain (RFC-0001 §3).
    as boolean   headerClosed
    as boolean   isModuleFile
    '' TKO0992 is said once per unit, not once per directive.
    as boolean   reportedNotImpl
    '' The first name that the condition about to be pushed consulted and that is not
    '' predefined, as written. PushCond moves it onto the PpCond; see PpModFirstUserIdent.
    as string    pendingUser
    '' InternId -> non-zero: a macro PpDefineBuiltins defined. The -d defines come
    '' after it and are NOT predefined: a header must be decidable from the target.
    as IdVec     predefMark
end type

end namespace
