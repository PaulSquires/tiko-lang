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

#ifndef __FBX_PARSER_BI__
#define __FBX_PARSER_BI__

#include once "fbx.bi"
#include once "parser/expr.bi"

namespace Fbx.Parse

    '' Parse a whole token vector as a module.
    declare function Unit( byref p as Fbx.ParserState ) as Fbx.NodeId

    '' One statement, or NODE_NONE at end of input.
    declare function Statement( byref p as Fbx.ParserState ) as Fbx.NodeId

    '' A syntactic type reference: 'integer', 'Foo ptr ptr', 'sub( byval as long )'.
    declare function TypeRef( byref p as Fbx.ParserState ) as Fbx.NodeId

    declare function DumpTree _
        ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
          byref names as Fbx.Interner, byval root as Fbx.NodeId ) as string

end namespace

#endif
