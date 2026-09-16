'' parser.bi -- statements, declarations and the unit entry point.
''
'' Recursive descent, one function per construct, over the preprocessed token vector.
'' The parser never consults symbols or types (docs/plan/01 section 1): where FreeBASIC
'' appears to require it -- 'Foo 1, 2' versus 'Foo = 1' -- it emits N_AMBIGUOUS and the
'' resolver decides (docs/plan/04 section 6).
''
'' Invariants:
''   - Always returns a module node, however damaged the input.
''   - Never loops forever: every recovery path consumes at least one token.
''   - One diagnostic per statement; the rest of a broken statement is suppressed.

#ifndef __TKO_PARSER_BI__
#define __TKO_PARSER_BI__

#include once "tko.bi"
#include once "parser/expr.bi"
'' The parser tells the preprocessor what it has DECLARED, so 'defined( X )' can answer
'' for a TYPE or a CONST and not only for a macro -- see NoteDeclaredName_ in decl.bas.
'' expr.bas already reaches this header to pull tokens through PpEnsure.
#include once "pp/pp.bi"

namespace Tko.Parse

    '' Parse a whole token vector as a module.
    declare function Unit( byref p as Tko.ParserState ) as Tko.NodeId

    '' One statement, or NODE_NONE at end of input.
    declare function Statement( byref p as Tko.ParserState ) as Tko.NodeId
    declare function CallStatement( byref p as Tko.ParserState ) as Tko.NodeId

    '' A syntactic type reference: 'integer', 'Foo ptr ptr', 'sub( byval as long )'.
    declare function TypeRef( byref p as Tko.ParserState ) as Tko.NodeId

    declare function DumpTree _
        ( byref ast as Tko.AstArena, byref src as Tko.SourceManager, _
          byref names as Tko.Interner, byval root as Tko.NodeId ) as string

end namespace

#endif
