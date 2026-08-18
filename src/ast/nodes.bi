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

#ifndef __FBX_AST_NODES_BI__
#define __FBX_AST_NODES_BI__

#include once "fbx.bi"
#include once "source/location.bi"
#include once "lexer/token.bi"

namespace Fbx

    type NodeId as ulong
    const NODE_NONE as NodeId = 0

    '' NODE( name, category )
    #macro FBX_NODE_LIST( NODE )
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
        NODE( N_NEW,          NCAT_EXPR )
        NODE( N_DELETE,       NCAT_EXPR )

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
        FBX_NODE_LIST( NODE )
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

    '' N_PROC reuses StmtPayload.extra as a modifier set. The ushort NF_ flags are
    '' fully allocated, and these are meaningful for exactly one node kind.
    const PF_OVERLOAD   as ushort = &h0001   '' the OVERLOAD keyword was written
    const PF_CONST      as ushort = &h0002   '' 'const function T.F( )' -- a const method
    const PF_STATIC     as ushort = &h0004   '' 'static sub T.S( )' -- no implicit THIS
    const PF_ABSTRACT   as ushort = &h0008
    const PF_VIRTUAL    as ushort = &h0010
    const PF_FOREIGN    as ushort = &h0020   '' inside EXTERN "C" / "Windows" ...
    const PF_PRIVATE    as ushort = &h0040   '' module-static: no linker-visible name

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
    type StmtPayload
        as InternId name            '' declared or referenced name, 0 if none
        as NodeId   a               '' cond / target / typeref / iterator
        as NodeId   b               '' body / init / value
        as NodeId   c               '' else / step / extra
        as long     first           '' child list, into the shared pool (signed: see ListPayload)
        as long     count
        as ushort   op              '' keyword that spelled it, for dumps
        as ushort   extra           '' levels for EXIT/CONTINUE, intrinsic id, PF_* ...
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

        declare constructor( )
        declare function Kind( byval id as NodeId ) as NodeKind
        declare function Loc( byval id as NodeId ) as SourceLoc
        declare function Count( ) as long
    end type

    declare function NodeKindName( byval k as NodeKind ) as string
    declare function NodeKindCategory( byval k as NodeKind ) as NodeCategory

end namespace

#endif
