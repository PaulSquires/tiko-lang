'' visibility.bi -- 'private:' and 'protected:' inside a TYPE, checked at the USE SITE.
''
'' fbc error 202, "Illegal member access". A PRIVATE member may be named only from inside
'' its own type's procedures; a PROTECTED one from those and from a DERIVED type's.
''
'' A PASS OF ITS OWN, after Check, and that is the whole reason it exists. The question
'' needs two things at once: WHICH MEMBER -- which only Check knows, because a field means
'' nothing until its base has a type -- and WHICH PROCEDURE ENCLOSES THE USE, which Check
'' does not track and Resolve cannot answer for a field.

#ifndef TKO_VISIBILITY_BI
#define TKO_VISIBILITY_BI

#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"
#include once "types/type.bi"
#include once "diag/engine.bi"

namespace Tko.Vis

    declare sub Run _
        ( byref ast as AstArena, byval root as NodeId, byref syms as SymbolTable, _
          byref types as TypeContext, byref names as Interner, _
          byref diags as DiagnosticEngine, byref info as SemanticInfo )

end namespace

#endif
