'' nodes.bi -- the AST node model.
''
'' Nodes live in arenas and are addressed by a 32-bit NodeId, not a pointer
'' (docs/plan/05 section 1 -- decision D7). Every node header is the same 16 bytes, so
'' traversal, dumping and location lookup need no per-kind switch; the variable part
'' lives in a per-kind payload array indexed by the header's 'data' field.
''
'' Invariants:
''   - NodeId 0 is NODE_NONE and refers to nothing.
''   - Every node's loc lies inside a loaded file.
''   - The AST is a TREE. Instantiation produces new subtrees, never shared ones.
''   - An Error node exists only if a diagnostic was emitted for it.

#ifndef __TKO_AST_NODES_BI__
#define __TKO_AST_NODES_BI__

#include once "tko.bi"
#include once "source/location.bi"
#include once "lexer/token.bi"

namespace Tko

    type NodeId as ulong
    const NODE_NONE as NodeId = 0

    '' NODE( name, category )
    #macro TKO_NODE_LIST( NODE )
        NODE( N_ERROR,        NCAT_EXPR )

        '' ---- expressions
        NODE( N_INT_LIT,      NCAT_EXPR )
        NODE( N_FLOAT_LIT,    NCAT_EXPR )
        NODE( N_STRING_LIT,   NCAT_EXPR )
        NODE( N_STRCAT,       NCAT_EXPR )   '' adjacent literals: "a" "b" is one string
        NODE( N_IDENT,        NCAT_EXPR )
        NODE( N_UNARY,        NCAT_EXPR )
        NODE( N_BINARY,       NCAT_EXPR )
        NODE( N_CALL,         NCAT_EXPR )   '' also array indexing, until resolution
        NODE( N_INDEX,        NCAT_EXPR )   '' explicit [ ] form
        NODE( N_MEMBER,       NCAT_EXPR )   '' a.b and a->b
        NODE( N_DEREF,        NCAT_EXPR )   '' *p
        NODE( N_ADDROF,       NCAT_EXPR )   '' @x, varptr, strptr, procptr
        NODE( N_CAST,         NCAT_EXPR )   '' cast/ctype/cptr
        NODE( N_SIZEOF,       NCAT_EXPR )
        NODE( N_TYPEOF,       NCAT_EXPR )
        NODE( N_IIF,          NCAT_EXPR )
        NODE( N_PAREN,        NCAT_EXPR )   '' kept: diagnostics and faithful dumps
        NODE( N_TUPLE,        NCAT_EXPR )
        NODE( N_INITIALIZER,  NCAT_EXPR )   '' { ... }
        '' A CAPTURING LAMBDA'S closure object: the invoke procedure in 'target', one
        '' capture per child (NF_BYREF says which kind), and the generated closure
        '' TYPE's name in 'name'. See lambda.bas.
        NODE( N_CLOSURE,      NCAT_EXPR )
        NODE( N_NEW,          NCAT_EXPR )
        NODE( N_DELETE,       NCAT_EXPR )
        NODE( N_FUNCRESULT,   NCAT_EXPR )
        NODE( N_ELLIPSIS,     NCAT_EXPR )
        NODE( N_ELIDED,       NCAT_EXPR )   '' an ARGUMENT that was left out: 'f( 1, , 3 )'
                                            '' and 'locate ,,0'. A node rather than a
                                            '' gap, because the ARITY has to survive --
                                            '' that call passes three arguments.
        NODE( N_GLOBALSCOPE,  NCAT_EXPR )   '' the '..' of '..x' -- the base of a member
                                            '' access that names the GLOBAL scope, as
                                            '' against '.x', whose base is the open WITH.   '' '...' as an ARRAY BOUND, where the size
                                            '' comes from the initializer. Legal nowhere
                                            '' else, so it is read only in a bound.   '' the FUNCTION/OPERATOR/PROPERTY keyword
                                            '' as an assignment TARGET. Assignable and
                                            '' not readable: fbc rejects 'print function'.

        '' ---- type references (syntactic, not semantic types)
        NODE( N_TYPEREF,      NCAT_TYPE )   '' builtin or named, with ptr/array suffixes

        '' ---- statements
        NODE( N_BLOCK,        NCAT_STMT )   '' a statement list
        NODE( N_AMBIGUOUS,    NCAT_STMT )   '' call-or-assign; the resolver decides (plan 04 s6)
        NODE( N_IF,           NCAT_STMT )
        NODE( N_IF_BRANCH,    NCAT_STMT )   '' one cond + body of an IF/ELSEIF
        NODE( N_SELECT,       NCAT_STMT )
        NODE( N_CASE,         NCAT_STMT )
        NODE( N_CASE_RANGE,   NCAT_STMT )   '' 'a TO b' or 'IS < a'
        NODE( N_PRINT_SEP,    NCAT_STMT )   '' ';' or ',' between PRINT items
        NODE( N_FOR,          NCAT_STMT )
        NODE( N_FOREACH,      NCAT_STMT )
        NODE( N_DO,           NCAT_STMT )
        NODE( N_WHILE,        NCAT_STMT )
        NODE( N_WITH,         NCAT_STMT )
        NODE( N_SCOPE,        NCAT_STMT )
        NODE( N_DEFER,        NCAT_STMT )   '' 'defer <stmt>' -- FBC-Modern, CONTEXTUAL
        NODE( N_SPAWN,        NCAT_STMT )   '' 'spawn f( a )' -- FBC-Modern, CONTEXTUAL
        NODE( N_RETURN,       NCAT_STMT )
        NODE( N_EXIT,         NCAT_STMT )
        NODE( N_END_STMT,     NCAT_STMT )   '' END [exitcode] -- terminates the program
        NODE( N_CONTINUE,     NCAT_STMT )
        NODE( N_GOTO,         NCAT_STMT )
        NODE( N_LABEL,        NCAT_STMT )
        NODE( N_INTRINSIC,    NCAT_STMT )   '' PRINT, OPEN, DRAW ... (plan 04 s5)
        NODE( N_ASM,          NCAT_STMT )   '' parsed only to reject (plan 01 s5.6)
        NODE( N_DELETE_STMT,  NCAT_STMT )   '' 'delete p' / 'delete[] p'
        NODE( N_ASSERT,       NCAT_STMT )   '' '#assert expr' -- compile-time, not PP
        NODE( N_UNDEF,        NCAT_STMT )   '' '#undef name' of a DECLARED symbol
        NODE( N_ERROR_STMT,   NCAT_STMT )

        '' ---- declarations
        NODE( N_MODULE,       NCAT_DECL )
        NODE( N_VAR,          NCAT_DECL )   '' dim/redim/var/static/shared/common/extern
        NODE( N_VAR_ITEM,     NCAT_DECL )   '' one name in a dim list
        NODE( N_CONST,        NCAT_DECL )
        NODE( N_TYPE,         NCAT_DECL )   '' type/union/class
        NODE( N_FIELD,        NCAT_DECL )
        NODE( N_ENUM,         NCAT_DECL )
        NODE( N_ENUM_ITEM,    NCAT_DECL )
        NODE( N_TYPEDEF,      NCAT_DECL )
        NODE( N_PROC,         NCAT_DECL )   '' sub/function/property/ctor/dtor/operator
        NODE( N_PARAM,        NCAT_DECL )
        NODE( N_NAMESPACE,    NCAT_DECL )
        NODE( N_USING,        NCAT_DECL )
        NODE( N_OPTION,       NCAT_DECL )
        NODE( N_EXTERN_BLOCK, NCAT_DECL )
        NODE( N_ERROR_DECL,   NCAT_DECL )
    #endmacro

    enum NodeCategory
        NCAT_EXPR = 0
        NCAT_TYPE
        NCAT_STMT
        NCAT_DECL
    end enum

    enum NodeKind
        N_NONE = 0
        #define NODE( n_name, n_cat ) n_name,
        TKO_NODE_LIST( NODE )
        #undef NODE
        N_KIND_COUNT
    end enum

    '' Unary and binary operators are the token kind that spelled them, so the parser
    '' does not translate and the dump can print the original spelling.
    type AstNode                    '' 16 bytes
        as ushort    kind
        as ushort    flags
        as SourceLoc loc
        as ulong     data           '' index into this kind's payload array
    end type

    const NF_ARROW      as ushort = &h0001   '' N_MEMBER used '->'
    const NF_FROM_MACRO as ushort = &h0002
    const NF_HAS_COMMA  as ushort = &h0004   '' N_TUPLE / N_PAREN: a comma was present
    const NF_SINGLE_LINE as ushort = &h0008  '' 'if c then s' rather than a block
    const NF_BYREF      as ushort = &h0010
    const NF_PTR        as ushort = &h0020
    const NF_ARRAY      as ushort = &h0040
    const NF_UNTIL      as ushort = &h0080   '' N_DO: until rather than while
    const NF_POST_COND  as ushort = &h0100   '' N_DO: condition on the LOOP
    const NF_IS_UNION   as ushort = &h0200
    const NF_SHARED     as ushort = &h0400
    const NF_STATIC     as ushort = &h0800
    const NF_PRESERVE   as ushort = &h1000   '' redim preserve
    const NF_CONST      as ushort = &h2000
    const NF_PROC_TYPE  as ushort = &h4000   '' N_TYPEREF: 'sub(...)' / 'function(...) as T'
    const NF_QUALIFIED  as ushort = &h8000   '' N_PROC: 'Stack.Push' -- a member DEFINITION
    '' N_TUPLE: written as 'type( ... )' rather than as a bare '( ... )'.
    ''
    '' THE BIT IS SHARED WITH NF_UNTIL, which is N_DO's and can never appear on an
    '' N_TUPLE -- every bit of the ushort is spoken for, and widening the field to
    '' carry one more would touch every node in the arena. Sharing per NODE KIND is
    '' the same thing the payload fields already do.
    ''
    '' It has to be distinguishable: fbc ACCEPTS 'function = type( 5, 6 )' and REJECTS
    '' 'function = ( 5, 6 )' with error 7, and the two build the same node otherwise.
    const NF_TYPE_LITERAL as ushort = &h0080

    '' N_PARAM: 'byval' was WRITTEN. The passing mode is not decided by the parser --
    '' with neither keyword the default depends on the TYPE, which is not resolved yet
    '' -- so the absence of NF_BYREF cannot mean "byval" on its own.
    ''
    '' Shares its bit with NF_POST_COND, which is N_DO's and can never appear on an
    '' N_PARAM, the same way NF_TYPE_LITERAL shares with NF_UNTIL.
    const NF_BYVAL_WRITTEN as ushort = &h0100

    '' N_FOREACH: the loop was written with a NAME LIST -- 'for each (k, v) in c'.
    '' The parser rewrites that into the ordinary form plus a 'var' at the top of the
    '' body, so nothing downstream can tell from the shape alone; only the check that
    '' the element really is a tuple of the right arity needs to know, and it is the
    '' one thing the rewrite cannot express.
    ''
    '' Shares its bit with NF_IS_UNION, which is N_TYPE's and can never appear on an
    '' N_FOREACH, the same way NF_TYPE_LITERAL shares with NF_UNTIL.
    const NF_DESTRUCTURE as ushort = &h0200

    '' PLACEMENT NEW -- 'new( p ) T'. The placement expression is CHILD 0 and the
    '' constructor arguments (or the array count) follow it, so the two uses of the
    '' child list stay exactly as they were for an ordinary 'new'.
    ''
    '' Shares its bit with NF_PRESERVE, which is REDIM's and can never appear on an
    '' N_NEW -- the same sharing NF_TYPE_LITERAL and NF_DESTRUCTURE already do.
    const NF_PLACEMENT as ushort = &h1000
    '' N_NEW: 'new T[n] { any }', the array left uninitialised. Shares its bit with
    '' NF_HAS_COMMA, which is N_TUPLE's and N_PAREN's and can never appear on an N_NEW.
    const NF_NOINIT as ushort = &h0004
    '' N_IDENT / N_MEMBER: the name is CALLED, addressed or taken by 'procptr' -- so it is
    '' not a paren-less read, which picks its overload by arity (see ParenlessMethodOf_).
    '' Same bit again: neither kind can carry NF_HAS_COMMA or NF_NOINIT.
    const NF_CALL_TARGET as ushort = &h0004

    '' N_VAR: THE DECLARATION WAS WRITTEN, and its nodes were built where it stands.
    '' The parser also SYNTHESIZES declarations -- a lambda's captures, a spawn's frame,
    '' a select-channel binding, a destructuring 'for each' -- and builds them AFTER the
    '' body they are prepended to, so their node ids run backwards against the statements
    '' below them. Anything reading the arena as a proxy for source order has to ask
    '' first; see MarkShadow_, where a capture came to hide itself from its own body.
    ''
    '' Positive, rather than a 'synthesized' bit, so a synthesizer added later is left
    '' out by default instead of by remembering. Shares its bit with NF_ARROW, which is
    '' N_MEMBER's and can never appear on an N_VAR.
    const NF_DECL_WRITTEN as ushort = &h0001

    '' N_PROC reuses StmtPayload.extra as a modifier set. The ushort NF_ flags are
    '' fully allocated, and these are meaningful for exactly one node kind.
    const PF_OVERLOAD   as ushort = &h0001   '' the OVERLOAD keyword was written
    const PF_CONST      as ushort = &h0002   '' 'const function T.F( )' -- a const method
    const PF_STATIC     as ushort = &h0004   '' 'static sub T.S( )' -- no implicit THIS
    const PF_ABSTRACT   as ushort = &h0008
    const PF_VIRTUAL    as ushort = &h0010
    const PF_FOREIGN    as ushort = &h0020   '' inside EXTERN "C" / "Windows" ...
    const PF_PRIVATE    as ushort = &h0040   '' module-static: no linker-visible name

    '' The calling convention AS WRITTEN. Mutually exclusive, and all three absent means
    '' NONE WAS WRITTEN -- which is not the same as the default: a definition with no
    '' convention inherits its DECLARE's, and fbc refuses one that contradicts it
    '' ("Calling convention does not match DECLARE prototype").
    ''
    '' On win64 the convention has no effect on the emitted name at all -- cdecl,
    '' stdcall and pascal all give plain 'CD', 'ST', 'PA'. On win32 it decides the
    '' decoration, and PASCAL decorates like CDECL rather than like STDCALL, which is
    '' the one part of this a reader will get wrong from first principles.
    const PF_CDECL      as ushort = &h0080
    const PF_STDCALL    as ushort = &h0100
    const PF_PASCAL     as ushort = &h0200

    '' AN ELLIPSIS THE PARSER REFUSED, in 'extra' of its N_PARAM: fbc's error 312, '...'
    '' in a procedure that is not CDECL (parser/typeref.bas, CheckVarargConv_). The '...'
    '' stays, as fbc keeps it, so the procedure is still variadic to everything after;
    '' the mark only tells Collect the statement has had its one error.
    const PARAM_VARARG_REFUSED as ushort = 1

    '' Member visibility, from a 'private:' / 'protected:' / 'public:' label in a TYPE
    '' body. Neither bit set is PUBLIC, which is the default fbc gives an unlabelled
    '' member. Carried in StmtPayload.extra on N_FIELD as well as N_PROC, so the name
    '' says member rather than proc -- and note PF_PRIVATE above is a DIFFERENT thing,
    '' module-static linkage, which is why these are not called PF_PRIVATE.
    '' 'function f( ) as long EXPORT' -- the procedure joins the DLL's export table.
    '' The keyword was consumed by the trailing-modifier loop and recorded nowhere,
    '' so fbc emitted 'define dllexport i32 @"AddUp"' where tiko-lang emitted
    '' 'define i32 @"AddUp"' -- measured. A DLL built from that exports nothing.
    ''
    const PF_MEMB_PRIVATE   as ushort = &h0400
    const PF_MEMB_PROTECTED as ushort = &h0800

    '' A GENERIC PROCEDURE -- 'function Ok( of T, E )( byval v as T ) as ...'. The
    '' parameter list is currently SKIPPED by the parser, so nothing downstream can
    '' tell the declaration from an ordinary one, and its body lowered as if T were a
    '' real type: aggregates of SIZE ZERO, stores into void slots, a function emitted
    '' under a name no call site will ever use. Recording it is what lets lowering
    '' decline instead of producing that.
    const PF_GENERIC_PROC   as ushort = &h1000
    '' A procedure TYPE that returns BYREF: 'as function( ) byref as zstring'. The
    '' modifier sits before the AS, which is what made it a parse error rather than
    '' a flag -- the same shape the byref-returning DECLARATION had.
    const PF_BYREF_RESULT   as ushort = &h2000
    '' A CAPTURING LAMBDA'S '__fbinvoke'. Its FIRST parameter is the closure object,
    '' written by the parser rather than by the source, so nothing may read the
    '' parameter list as the lambda's own.
    const PF_CLOSURE_INVOKE as ushort = &h4000

    '' 'declare sub f( ) OVERRIDE' -- a TRAILING modifier, and not a reserved word: it
    '' arrives as an identifier and is recognised by spelling, as 'defer' and 'each' are.
    '' Recorded because it is a PROMISE that has to be checked -- fbc's error 223, "Not
    '' overriding any virtual method" -- and the trailing-modifier loop used to consume
    '' it with everything else, so a promise that was not kept said nothing at all.
    const PF_OVERRIDE       as ushort = &h8000

    '' A TRAILING 'constructor' / 'destructor' -- a MODULE structor, which the C
    '' runtime calls around main. Nothing to do with a UDT's constructor: this is
    '' 'sub f( ) constructor' at module level, which fbcunit's SUITE and TEST macros
    '' use to register every test before main runs.
    ''
    '' PAST BIT 15, which is why StmtPayload.extra is a ULONG.
    const PF_MODCTOR        as ulong = &h00010000
    const PF_MODDTOR        as ulong = &h00020000
    '' 'function f( ) as long EXPORT' -- the procedure joins the DLL's export table.
    '' The keyword was consumed by the trailing-modifier loop and recorded nowhere,
    '' so fbc emitted 'define dllexport i32 @"AddUp"' where tiko-lang emitted
    '' 'define i32 @"AddUp"'. A DLL built from that exports nothing.
    ''
    '' &h00040000 AND NOT &h1000, which is where this was first put -- and &h1000 is
    '' PF_GENERIC_PROC. The collision did not error: an exported function was read as
    '' a generic one, generics are not emitted until instantiated, and the module came
    '' out with no functions in it at all. The low sixteen bits are ALL spoken for;
    '' anything added here goes above PF_MODDTOR.
    const PF_EXPORT         as ulong = &h00040000

    '' INSIDE 'extern "C++"', which is NOT the same as PF_FOREIGN. A foreign block
    '' takes the spelling VERBATIM and ignores OVERLOAD; a C++ one MANGLES, and
    '' mangles the SOURCE SPELLING rather than the uppercased name. Measured:
    ''
    ''     sub g2( byval n as integer )        inside extern "C++"'
    ''         -> _Z2g2u7INTEGER
    ''     sub h( byval n as integer )         outside it
    ''         -> H
    ''
    '' so the two cannot share a bit: reading "C++" as foreign emitted four
    '' overloads all named 'f1' and clang refused the module.
    const PF_CXX            as ulong = &h00080000

    type UnaryPayload
        as ushort op                '' TokenKind
        as NodeId operand
    end type

    type BinaryPayload
        as ushort op                '' TokenKind
        as NodeId lhs
        as NodeId rhs
    end type

    type LiteralPayload
        as ulongint intValue
        as double   fltValue
        as long     strFile         '' FileId the span indexes -- NOT the node's loc,
                                    '' which macro expansion is free to rewrite
        as long     strOffset       '' raw span in that buffer
        as long     strLength
        as ubyte    strKind
        as ubyte    suffix
        as ubyte    radix
    end type

    type IdentPayload
        as InternId name            '' folded
        as long     spellOffset     '' original spelling, in the source buffer
        as long     spellLength
    end type

    '' Child lists live in ONE shared pool as (offset, count), so no node allocates.
    '' first/count are SIGNED on purpose. With ulong, 'count - 1' underflows to
    '' 4294967295 whenever count is 0, and every loop over an empty child list runs
    '' four billion times. Signed counts make that impossible rather than careful.
    type ListPayload
        as NodeId target            '' callee, base, or 0
        as long   first             '' index into the child pool
        as long   count
    end type

    '' The general statement/declaration payload. Slots are named by role rather than
    '' by construct so one record serves every node kind; which slots are meaningful
    '' is documented per kind in parser/stmt.bas.
    '' A calling convention, resolved. CC_NONE is 'none written'.
    enum CallConv
        CC_NONE = 0
        CC_CDECL
        CC_STDCALL
        CC_PASCAL
    end enum

    declare function CallConvOf( byval procFlags as ushort ) as CallConv
    declare function CallConvName( byval c as CallConv ) as string

    type StmtPayload
        as InternId name            '' declared or referenced name, 0 if none
        as NodeId   a               '' cond / target / typeref / iterator
        as NodeId   b               '' body / init / value
        as NodeId   c               '' else / step / extra
        as long     first           '' child list, into the shared pool (signed: see ListPayload)
        as long     count
        as ushort   op              '' keyword that spelled it, for dumps
        '' ULONG, NOT USHORT. All sixteen PF_* bits were allocated, and a trailing
        '' 'constructor' had nowhere to be recorded -- the parser recognised it,
        '' checked it, and then threw it away, so a module constructor was emitted as
        '' an ordinary procedure that nothing ever called. Widening here was cheaper
        '' and more honest than borrowing an NF_* bit that happens to be free for
        '' N_PROC today.
        as ulong    extra           '' levels for EXIT/CONTINUE, intrinsic id, PF_* ...
                                    '' -- and, on an OPEN, its CLAUSE WORDS: see
                                    '' the OPEN_* codes below.
        as InternId aliasName       '' N_PROC: the ALIAS spelling, CASE PRESERVED, or 0
        as InternId ownerName       '' N_PROC: the QUALIFIER of 'Widget.Method' --
                                    '' the last component lands in .name, and without
                                    '' this the type a member belongs to is lost
        as InternId rawName         '' N_PROC: the source spelling, CASE PRESERVED.
                                    '' Identifiers intern FOLDED, so the only record
                                    '' of how a name was written is kept here -- and
                                    '' EXTERN "C" emits exactly what was written.
    end type

    type NodeVec    as FB.Array( of AstNode )
    type UnaryVec   as FB.Array( of UnaryPayload )
    type BinaryVec  as FB.Array( of BinaryPayload )
    type LiteralVec2 as FB.Array( of LiteralPayload )
    type IdentVec   as FB.Array( of IdentPayload )
    type ListVec    as FB.Array( of ListPayload )
    type StmtVec    as FB.Array( of StmtPayload )
    type ChildPool  as FB.Array( of ulong )
    type NodeIdVec  as FB.Array( of ulong )   '' a working list of NodeIds

    type AstArena
        as NodeVec     nodes        '' index 0 is a permanent N_NONE sentinel
        as UnaryVec    unaries
        as BinaryVec   binaries
        as LiteralVec2 literals
        as IdentVec    idents
        as ListVec     lists
        as StmtVec     stmts
        as ChildPool   children

        '' THE TOKEN RANGE a declaration was parsed from, for the declarations that
        '' may have to be parsed a SECOND time: a generic's TYPE body and the
        '' out-of-line definitions of its members.
        ''
        '' Instantiating a generic member cannot share the generic's nodes, because
        '' SemanticInfo is keyed by NodeId and two instantiations would write two
        '' different types onto one node. Fresh nodes are the only answer, and a
        '' re-parse is how they are got -- the token buffer only ever grows, so an
        '' index recorded during the first parse stays valid.
        ''
        '' Triples (node, firstTok, lastTok), appended in parse order and scanned
        '' linearly. Only N_TYPE and out-of-line N_PROC definitions are recorded, and
        '' the scan happens once per member per instantiation, so it is not hot.
        as ChildPool   tokenRanges

        '' TOP-LEVEL NODES CREATED AFTER PARSING -- today, the instantiated members of
        '' a generic. They are not children of the unit's root block, whose child list
        '' was closed when it was built, so every later pass has to walk them
        '' separately or they are typed and never emitted.
        as ChildPool   extraTopLevel

        '' THE TYPE ARGUMENTS AT A CALL SITE -- 'Ok( of Decimal, FinanceError )( v )'.
        ''
        '' A side table rather than a field on the call, because every reader of an
        '' N_CALL expects its target to be an N_IDENT and its children to be arguments;
        '' putting the type list in either place would change a shape a dozen files
        '' already depend on. Triples (call node, first, count) into the shared child
        '' pool, scanned linearly -- explicit type arguments are rare.
        as ChildPool   callTypeArgs

        declare constructor( )
        declare sub RecordTokens _
            ( byval id as NodeId, byval firstTok as long, byval lastTok as long )
        '' False when nothing was recorded for this node, which is the normal case.
        declare function TokensOf _
            ( byval id as NodeId, byref firstTok as long, byref lastTok as long ) as boolean
        declare sub RecordCallTypeArgs _
            ( byval id as NodeId, byval firstArg as long, byval argCount as long )
        '' False when the call carried none, which is the normal case.
        declare function CallTypeArgsOf _
            ( byval id as NodeId, byref firstArg as long, byref argCount as long ) as boolean
        declare function Kind( byval id as NodeId ) as NodeKind
        declare function Loc( byval id as NodeId ) as SourceLoc
        declare function Count( ) as long
    end type

    declare function NodeKindName( byval k as NodeKind ) as string
    declare function NodeKindCategory( byval k as NodeKind ) as NodeCategory

    '' OPEN's clause words, packed into StmtPayload.extra on the N_INTRINSIC node.
    ''
    '' EVERY ONE IS A SMALL INTEGER TO FBC rather than a separate entry point -- mode,
    '' access and lock all ride in the fb_FileOpen argument list -- and the numbering was
    '' MEASURED from fbc's own C output, not guessed:
    ''
    ''   mode    BINARY 0  RANDOM 1  INPUT 2  OUTPUT 3  APPEND 4
    ''   access  (none) 0  READ 1    WRITE 2  READ WRITE 3
    ''   lock    (none) 0  READ 1    WRITE 2  READ WRITE 3
    ''
    '' OMITTING 'FOR' IS NOT MODE 0. It is RANDOM, mode 1 -- the same code the word
    '' RANDOM gives -- so a missing clause and a written one are indistinguishable by
    '' design. 'SHARED' likewise compiles to lock 0, indistinguishable from writing no
    '' LOCK at all, and the default record length is 0 rather than 128.
    ''
    '' Here rather than beside either user because the parser packs these bits and
    '' lowering unpacks them, and two spellings of the same field would drift.
    const OPEN_MODE_MASK     as ushort = &h0007
    const OPEN_ACCESS_SHIFT  as long   = 3
    const OPEN_ACCESS_MASK   as ushort = &h0018
    const OPEN_LOCK_SHIFT    as long   = 5
    const OPEN_LOCK_MASK     as ushort = &h0060
    const OPEN_HAS_ENCODING  as ushort = &h0080

end namespace

#endif
