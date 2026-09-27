'' symbol.bi -- symbols and scopes.
''
'' Name resolution is a SEPARATE phase from parsing (docs/plan/07 section 1), split
'' into collect / resolve / check. Splitting collect from resolve is what makes
'' FreeBASIC's order-independence work: inside a TYPE a member may reference a member
'' declared later, and a SUB may call one declared further down the module.
''
'' Invariants:
''   - SymbolId 0 and ScopeId 0 are "none"; scope 1 is always the global scope.
''   - A symbol's 'name' is the FOLDED spelling. The lexer already folds, so lookup is
''     an integer compare and case-insensitivity costs nothing here.
''   - Declaration ORDER is preserved per scope. It is observable: destruction runs in
''     reverse declaration order (docs/plan/08 section 6).
''   - Overloads chain through 'nextOverload'; a name maps to the FIRST of them.

#ifndef __TKO_SYMBOL_BI__
#define __TKO_SYMBOL_BI__

#include once "tko.bi"
#include once "source/location.bi"
#include once "types/type.bi"
#include once "support/intern.bi"

namespace Tko

    type SymbolId as ulong
    type ScopeId  as ulong

    const SYMBOL_NONE as SymbolId = 0
    const SCOPE_NONE  as ScopeId  = 0
    const SCOPE_GLOBAL as ScopeId = 1
    const USEPOS_LATEST as ulong = &hFFFFFFFF

    '' SYM( name, spelling )
    #macro TKO_SYMKIND_LIST( SYM )
        SYM( SYM_VARIABLE,  "var"       )
        SYM( SYM_PARAMETER, "param"     )
        SYM( SYM_CONSTANT,  "const"     )
        SYM( SYM_FIELD,     "field"     )
        SYM( SYM_PROC,      "proc"      )
        SYM( SYM_UDT,       "type"      )
        SYM( SYM_ENUM,      "enum"      )
        SYM( SYM_ENUMCONST, "enumconst" )
        SYM( SYM_TYPEDEF,   "typedef"   )
        SYM( SYM_NAMESPACE, "namespace" )
        SYM( SYM_LABEL,     "label"     )
    #endmacro

    enum SymbolKind
        SYM_NONE = 0
        #define SYM( s_id, s_name ) s_id,
        TKO_SYMKIND_LIST( SYM )
        #undef SYM
        SYM_KIND_COUNT
    end enum

    enum ScopeKind
        SCOPEK_GLOBAL = 0
        SCOPEK_MODULE
        SCOPEK_NAMESPACE
        SCOPEK_TYPE
        SCOPEK_PROC
        SCOPEK_BLOCK
    end enum

    const SYMF_SHARED   as ushort = &h0001
    const SYMF_STATIC   as ushort = &h0002
    const SYMF_CONST    as ushort = &h0004
    const SYMF_EXTERN   as ushort = &h0008
    const SYMF_DECLARED as ushort = &h0010   '' seen as a DECLARE, no body yet
    const SYMF_DEFINED  as ushort = &h0020
    const SYMF_OVERLOAD as ushort = &h0040
    const SYMF_PRIVATE  as ushort = &h0080
    '' A field spliced out of an anonymous UNION. Its run of consecutive siblings
    '' all share one offset -- they overlap, which is the whole point of a union.
    const SYMF_UNION    as ushort = &h0100

    '' A PREDECLARED constant whose value fbc builds in rather than reading from
    '' source: 'true' and 'false'. 'payload' carries the value itself, not an AST node,
    '' which is why it needs a flag to say so -- every other SYM_CONSTANT's payload is
    '' a node id and reading one as the other is silent nonsense.
    const SYMF_BUILTIN  as ushort = &h0200

    '' __FUNCTION__. Not a value at all until Check knows which procedure encloses the
    '' use, so it needs its own marker rather than a payload.
    const SYMF_FUNCNAME as ushort = &h0400

    '' 'dim byref rb as integer = a' -- a REFERENCE. The slot would have to hold a
    '' pointer and every read and write go through it, which is not implemented, so
    '' lowering declines the declaration AND every use. Without the second half the
    '' declaration declined while 'rb = 5' still stored into a slot aliasing nothing:
    '' fbc prints 5 for that program, tiko-lang would have printed 1.
    const SYMF_BYREF    as ushort = &h0800

    '' The FIRST field spliced out of one anonymous aggregate -- union OR type. Two adjacent anonymous
    '' unions produce one continuous run of SYMF_UNION fields, and the layout pass
    '' scans a run to find its widest member -- so without a marker for where each
    '' union STARTS it merged them and overlapped fields that should follow one
    '' another. Measured: two anonymous unions of one INTEGER each is 16 bytes, not 8.
    const SYMF_UNION_FIRST as ushort = &h1000

    '' On a SYM_UDT: the aggregate was written as a UNION rather than a TYPE. The
    '' layout needs it because a named union's own members overlap, and nothing else
    '' recorded the kind on the symbol.
    const SYMF_UNION_KIND as ushort = &h2000

    '' A BITFIELD -- 'xb0 : 1 as ulong'. Its declared type says how wide the storage
    '' UNIT is, not how many bits the field owns, so nothing may read or write it as an
    '' ordinary field of that type: that would touch the whole unit and clobber its
    '' neighbours. Marked here and DECLINED in lowering until the masked access and the
    '' packed layout are implemented; tools/gen/check-udt.sh measures the layout gap.
    const SYMF_BITFIELD  as ushort = &h4000

    '' Declared by COMMON. A later DIM of the same name is NOT a duplicate: it
    '' re-dimensions it, the way a REDIM does. Measured:
    ''
    ''     common a( ) as integer : dim a( 1 to 2 ) as integer   accepted
    ''     dim    a( ) as integer : dim a( 1 to 2 ) as integer   error 4
    ''     common a( ) as integer : dim a( 1 to 2 ) as single    error 4
    ''
    '' -- so it is COMMON specifically, and the element types still have to
    '' agree. The flag lives here because the DECLARATION keyword is not on the
    '' item, and the symbol is the only place the two can be compared from.
    const SYMF_COMMON    as ushort = &h8000
    '' The variable was brought into existence by a REDIM, so it IS a dynamic
    '' array however its bounds were written. A second REDIM of it is a
    '' re-dimension and not a duplicate -- fbc accepts two 'redim a( ... ) as
    '' integer' in one scope and rejects the pair when the ELEMENT TYPE differs
    '' (error 4), both measured. IsDynArrayItem_ cannot see this: it reads the
    '' written bounds, and a redim's are written out in full.
    ''
    '' Past &h8000, which is why 'flags' is a ulong.
    const SYMF_REDIM     as ulong  = &h00010000

    '' 'private:' and 'protected:' inside a TYPE. Carried from the declaration node onto
    '' the symbol because the USE SITE is where they matter -- fbc's error 202, "Illegal
    '' member access" -- and a use has the symbol, not the declaration.
    ''
    '' NOT SYMF_PRIVATE, which is module linkage ('private sub f') and an unrelated
    '' question: a private MODULE procedure is visible to the whole file, and a private
    '' MEMBER is visible only inside its own type.
    const SYMF_MEMB_PRIVATE   as ulong = &h00020000
    const SYMF_MEMB_PROTECTED as ulong = &h00040000
    '' AN INSTANTIATED GENERIC. Every translation unit that uses 'Array( of long )'
    '' instantiates it, so the same definition is emitted more than once -- twenty
    '' duplicate symbols on the first attempt to compile tiko-lang with tiko-lang.
    '' The definition needs weak, foldable linkage, which is what COMDAT is for.
    const SYMF_GENERIC_INST   as ulong = &h00080000
    '' AN EARLIER GENERATION OF A NAME, no longer the one the slot table indexes. See
    '' SymbolTable.UndefSym: the symbol stays, because a use written BEFORE the '#undef'
    '' still binds to it, and Rehash must not index it again over its successor.
    const SYMF_SUPERSEDED     as ulong = &h00100000
    '' A MEMBER WHOSE BODY HAS BEEN SEEN, written outside its type -- 'sub T.m( )'. Set by
    '' Collect on the declaration the definition was matched to, so a second body for the
    '' same member is fbc's error 4 there rather than a duplicate symbol at the link. See
    '' collectproc.bas.
    const SYMF_MEMBER_BODY    as ulong = &h00200000

    '' A DEFINITION OF AN EXTERN: 'extern e as long' and then 'dim e as long = 5'. The
    '' definition need not say SHARED, and the variable still has module storage -- which
    '' is what EXTERN means and what lets a procedure name it. Collect clears SYMF_EXTERN
    '' on the definition, so without this nothing said the symbol had ever been one.
    const SYMF_EXTERN_DEF     as ulong = &h00400000
    '' MODULE CODE (ADR 0017): declared at module or namespace level in a file of the module
    '' unit being compiled (src/symbols/modsym.bas). It links by the module's chain.
    const SYMF_MODSRC         as ulong = &h00800000
    '' ...marked 'public': an importer may see it, and it is not hidden.
    const SYMF_PUBLIC         as ulong = &h01000000
    '' ...marked 'private': translation-unit local, LLVM internal, as fbc's private is.
    const SYMF_PRIVDECL       as ulong = &h02000000
    const SYMF_MODMASK        as ulong = &h03800000

    type Symbol
        as ubyte     kind
        as ulong     flags
        as InternId  name          '' folded spelling
        as ScopeId   parent
        as TypeId    type_
        as SourceLoc loc
        as SymbolId  nextOverload
        '' A TYPE NAME and a VALUE name may share a spelling in one scope. Measured:
        '' 'type T ... end type' beside 'dim as integer T' is accepted by fbc, and T
        '' still works as a type afterwards; so is a typedef beside a variable, and a
        '' UDT beside a SUB or a CONST of the same name. Only the ENUM is different --
        '' once 'enum E' exists, a bare E is an enum reference and fbc wants a period.
        ''
        '' The slot table is keyed on (scope, name) alone, so the two are chained here
        '' rather than given separate tables: one extra field against rekeying every
        '' lookup in the compiler.
        as SymbolId  altClass      '' the same name in the OTHER class, or SYMBOL_NONE
        as SymbolId  nextInScope   '' declaration order within the parent scope
        as ScopeId   inner         '' the scope this symbol opens, if any
        '' LONGINT, not LONG. Every other user of this field fits in 32 bits, but an
        '' ENUM MEMBER'S VALUE IS INTEGER-WIDE: fbc accepts 'B = 4000000000' in an
        '' enum and prints it back, where truncating to a signed long turned it into
        '' -294967296 with nothing to say so.
        as longint   payload       '' AST node, enum value, parameter index ...
        '' SYM_PROC: the calling convention, resolved across the declaration and the
        '' definition. CC_NONE means neither wrote one, and the TARGET decides what
        '' that means -- stdcall on win32, nothing at all on win64.
        '' How many ANONYMOUS aggregates enclose this field, 0 for one written
        '' directly in the named TYPE or UNION. With SYMF_UNION -- "my immediate
        '' enclosing aggregate is a union" -- it is everything the layout needs: a
        '' group is sequential or overlapping according to its own kind, and nests.
        ''
        '' The flag alone could not express 'this group is SEQUENTIAL but the group
        '' OVERLAPS its siblings', which is what an anonymous TYPE inside a UNION is,
        '' and what winnt.bi's _SLIST_HEADER writes.
        as ubyte     anonDepth
        '' HOW MANY anonymous aggregates OPEN at this field, and WHAT KIND each level
        '' is. anonDepth alone could not tell two adjacent anonymous groups apart when
        '' the second one holds no field of its own at the shared level: in
        '' 'type { union { a }; union { type { b } } }' b sits at anonDepth 2 and the
        '' SECOND union is invisible, so b was laid out inside the FIRST one -- 4 bytes
        '' where fbc says 8. A field opens the levels
        '' (anonDepth - anonOpen + 1) .. anonDepth, and a group at depth d ends at the
        '' first field that opens a level <= d.
        as ubyte     anonOpen
        '' Bit i-1 is set when the aggregate at LEVEL i of this field's chain is a
        '' UNION. One bit could not carry it: an anonymous TYPE inside an anonymous
        '' UNION is sequential at its own level and overlapping at its parent's.
        as ushort    anonUnionMask
        '' THE EMITTED SPELLING OF AN EXTERN VARIABLE, or 0. A variable defined in
        '' another module links by a name the folded one does not give: measured,
        '' 'extern MyThing as long' is 'MYTHING$' and the same line inside an
        '' 'extern "C"' block is 'MyThing', case preserved and no suffix.
        as InternId  linkName
        as ubyte     callConv
        '' '#undef' GENERATIONS -- see SymbolTable.UndefSym. Positions are NODE IDS: the
        '' arena is built in source order, so a use lies on one side of an '#undef' or
        '' the other. 'bornAt' is where this symbol becomes visible (0, from the start),
        '' 'diedAt' the '#undef' that removed it (0, never), and 'olderGen' the symbol of
        '' the same name that it replaced as the head of its slot or its class.
        as ulong     bornAt
        as ulong     diedAt
        as SymbolId  olderGen
        '' WHERE A WRITTEN DECLARATION OF IT STARTS -- the lowest node id the first one
        '' owns -- or 0 for what the source did not write in order: the prelude's, a
        '' generic instance's, a synthesized name. fbc reads a file once, top to bottom, so
        '' a name used above its declaration is undeclared there: Resolve's DeclaredBelow_.
        '' Not 'bornAt', which every lookup in every pass honours; this is a question only
        '' an expression's binding asks.
        as ulong     declAt
    end type

    '' Declaration order is a per-scope LINKED LIST, not a range: an inner scope can
    '' open part-way through a scope (a method's parameters inside a TYPE), so a
    '' scope's symbols are not contiguous in creation order.
    type SymScope
        as ubyte    kind
        as ScopeId  parent
        as SymbolId owner
        as SymbolId firstSym
        as SymbolId lastSym
        as long     count
    end type

    type SymbolVec as FB.Array( of Symbol )
    type ScopeVec  as FB.Array( of SymScope )
    type SymSlotVec as FB.Array( of ulong )

    type SymbolTable
        '' THE MODULE UNIT BEING COMPILED, if this is one (ADR 0017): its files are FileIds
        '' 1..modFileCount, and selfChain is its chain upper-cased, one component each --
        '' what the mangler prepends to every SYMF_MODSRC name. 0 and empty otherwise.
        as long       modFileCount
        as StrVec     selfChain
        as SymbolVec  symbols
        as ScopeVec   scopes
        as SymSlotVec slots        '' open addressing on (scope, name)
        as long       mask
        as long       occupied
        as Interner ptr names

        '' THE NODE A LOOKUP IS MADE FROM, and how many '#undef's have removed a declared
        '' symbol. Positions are only consulted once 'undefs' is non-zero, so a program
        '' without one pays nothing. The Resolve and Check walks set 'usePos';
        '' USEPOS_LATEST means after everything -- the newest generation of every name.
        as ulong      usePos
        as long       undefs
        '' ...AND HOW MANY LOCALS SHADOW AN OUTER NAME. A 'dim' that shadows one is
        '' NOT visible above itself in its own block: measured on fbc-modern, with an
        '' outer 'v = 11', a 'print v' written before 'dim as long v = 22' prints 11,
        '' and so does the same pair over a parameter, a 'static', and every block kind
        '' there is. Those declarations carry a 'bornAt' of their own, so positions have
        '' to be consulted for them as well as after an '#undef' -- hence a second
        '' counter rather than folding them into 'undefs', whose generation chain they
        '' are not part of.
        as long       shadows

        '' 'using ns' -- the namespaces IMPORTED into a scope, as parallel arrays of
        '' (the scope the USING was written in, the namespace's own scope). A list
        '' rather than a field on SymScope because almost no scope has one, and a scope
        '' may import several.
        as FB.Array( of ulong ) usingAt
        as FB.Array( of ulong ) usingInner

        declare constructor( )
        declare sub Attach( byval it as Interner ptr )

        declare function OpenScope _
            ( byval k as ScopeKind, byval parent as ScopeId, _
              byval owner as SymbolId ) as ScopeId

        '' Declare a name in a scope. Named DeclareSym: DECLARE is a keyword. If the name already exists there and both are
        '' procedures, the new one is chained as an overload; otherwise 'duplicate'
        '' is set and the existing symbol is returned.
        declare function DeclareSym _
            ( byval scope_ as ScopeId, byval nm as InternId, byval k as SymbolKind, _
              byval loc as SourceLoc, byref duplicate as boolean ) as SymbolId

        '' Make an EXISTING symbol reachable under ANOTHER name's overload chain. An
        '' instantiated generic global operator is declared under its structural key so
        '' two uses reach one function, and has to be findable under the operator's own
        '' spelling as well, which is what overload resolution looks up. Idempotent: the
        '' same id is never chained twice.
        declare sub ChainOverload _
            ( byval scope_ as ScopeId, byval nm as InternId, byval id as SymbolId )

        '' Innermost-first through the enclosing scope chain.
        declare function Lookup _
            ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId
        '' A name in a particular CLASS. The slot holds whichever was declared first,
        '' so a caller that knows which it wants has to walk the pair.
        declare function LookupLocalTyped _
            ( byval scope_ as ScopeId, byval nm as InternId, _
              byval wantType as boolean ) as SymbolId
        declare function LookupTyped _
            ( byval scope_ as ScopeId, byval nm as InternId, _
              byval wantType as boolean ) as SymbolId
        declare function LookupLocal _
            ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId

        '' A name inside a NAMESPACE, following that namespace's OWN usings.
        '' LookupLocal is a single hash probe and never sees them; the walking
        '' Lookup only follows the enclosing-scope chain, never into a named
        '' namespace. So 'ns.name' where ns gets 'name' from its own 'using' found
        '' nothing at all.
        declare function LookupInNamespace _
            ( byval nsScope as ScopeId, byval nm as InternId, _
              byval depth as long = 0 ) as SymbolId

        '' The same, wanting a TYPE name (or wanting not to be one).
        declare function LookupInNamespaceTyped _
            ( byval nsScope as ScopeId, byval nm as InternId, _
              byval wantType as boolean, byval depth as long = 0 ) as SymbolId

        '' A name reachable only through a USING in effect at 'scope_' -- the scope's
        '' own and every enclosing one's, and NOT the scopes' own declarations. That
        '' is what a leading '.name' needs: it must not see an ordinary local.
        declare function LookupThroughUsings _
            ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId

        '' Register 'using ns' in a scope. Repeats are ignored, so a header included
        '' twice does not grow the list.
        declare sub AddUsing( byval scope_ as ScopeId, byval nsScope as ScopeId )

        '' '#undef name' of a DECLARED symbol, written at node 'at'. Removes the first
        '' symbol a lookup from 'scope_' finds, from 'at' on. See symbol.bas.
        declare sub UndefSym _
            ( byval scope_ as ScopeId, byval nm as InternId, byval at as ulong )

        '' A LOCAL DECLARED AT NODE 'at' THAT SHADOWS AN OUTER NAME. Hides it from
        '' lookups made above 'at' -- which fall through to the outer one, exactly as
        '' they would if this declaration were not there at all.
        declare sub ShadowFrom _
            ( byval id as SymbolId, byval at as ulong )

        declare function SymbolAt( byval id as SymbolId ) as Symbol ptr
        declare function ScopeAt( byval id as ScopeId ) as SymScope ptr
        declare function Count( ) as long
        declare function ScopeCount( ) as long

        private:
        declare function LiveGen( byval id as SymbolId ) as SymbolId
        declare sub Rehash( byval newSlots as long )
        declare function SlotFor _
            ( byval scope_ as ScopeId, byval nm as InternId ) as long
    end type

    '' THE SYNTHETIC UDT A TUPLE DESUGARS INTO -- '$tup:<id>:<id>', with fields
    '' '_1'.._N. Shared because BOTH halves need to name the same one: Resolve builds it
    '' for a tuple TYPE, 'as (long, string)', and Check builds it for a tuple LITERAL,
    '' '(1, 2)', whose element types it is the first pass to know. Identity is
    '' STRUCTURAL, through the element type ids, which is what makes a literal
    '' assignable to a variable of the written type.
    ''
    '' Declaring a SYMBOL rather than a bare type is what makes the layout free:
    '' ComputeUdtLayouts walks symbols and runs after both passes, so a tuple goes
    '' through the same offset and alignment code as every other type.
    declare function TupleUdtFor _
        ( byref syms as SymbolTable, byref types as TypeContext, _
          byref names as Interner, byref elemTypes as FB.Array( of ulong ), _
          byval at as SourceLoc ) as TypeId

    declare function SymbolKindName( byval k as SymbolKind ) as string
    declare function ScopeKindName( byval k as ScopeKind ) as string

end namespace

#endif
