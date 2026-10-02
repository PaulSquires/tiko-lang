'' lowerqsym.bas -- '__FB_QUERY_SYMBOL__', fbc's compile-time symbol query.
''
'' Nothing about it survives to run time: every query folds to an integer here.
''
'' The query codes and the answer encodings are fbc's own, published in
'' 'fbc-int/symbol.bi' and MEASURED against it rather than read off the enum -- the
'' header itself says "much work is still needed here", and four of the answers do not
'' follow from the names:
''
''   a PARAMETER reads as FB_SYMBCLASS_VAR, not _PARAM
''   an ENUM MEMBER reads as FB_SYMBCLASS_CONST, and its datatype is _ENUM
''   'type C extends object' is _STRUCT, not _CLASS
''   an EXPRESSION rather than a symbol is class 0, and its datatype is the
''   expression's own
''
'' The datatype is ENCODED: the base type in the low five bits, the POINTER LEVEL in
'' the next four, and one CONST bit per level from bit 9 up. Measured:
''
''   const integer        8 + 512          const at level 0
''   const long ptr      11 +  32 + 1024   pointer, const at level 1
''   long ptr ptr        11 +  64
''   any ptr              0 +  32

#include once "mir/lowerctx.bi"

namespace Tko.Mir

declare function QSymConstOf_ _
    ( byref c as Ctx, byval qn as Tko.NodeId, byref outv as longint ) as boolean
declare function QSymClassOf_ _
    ( byref c as Ctx, byval sy as Tko.Symbol ptr ) as longint
declare function QSymTypeOf_ _
    ( byref c as Ctx, byval sn as Tko.NodeId, byval sy as Tko.Symbol ptr ) as Tko.TypeId
declare function QSymEncodeType_ _
    ( byref c as Ctx, byval sy as Tko.Symbol ptr, byval t as Tko.TypeId ) as longint
declare function QSymBaseType_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as longint
declare function QSymDataClass_( byval dt as longint ) as longint

'' The query selector, its mask, and the four queries answered here. The text queries
'' -- typename, mangleid and the rest -- are not: they return a STRING, which is a
'' different shape of answer, and nothing in the corpus asks for one.
const QSYM_SYMBCLASS as long = &h0000
const QSYM_DATATYPE  as long = &h0001
const QSYM_DATACLASS as long = &h0002
const QSYM_EXISTS    as long = &h0007
const QSYM_QUERYMASK as long = &h00ff

const QSYMCLASS_VAR       as long = 1
const QSYMCLASS_CONST     as long = 2
const QSYMCLASS_PROC      as long = 3
const QSYMCLASS_LABEL     as long = 7
const QSYMCLASS_NAMESPACE as long = 8
const QSYMCLASS_ENUM      as long = 9
const QSYMCLASS_STRUCT    as long = 10
const QSYMCLASS_FIELD     as long = 12
const QSYMCLASS_TYPEDEF   as long = 13
const QSYMCLASS_RESERVED  as long = 16

const QSYMDT_VOID     as long = 0
const QSYMDT_BOOLEAN  as long = 1
const QSYMDT_BYTE     as long = 2
const QSYMDT_UBYTE    as long = 3
const QSYMDT_CHAR     as long = 4
const QSYMDT_SHORT    as long = 5
const QSYMDT_USHORT   as long = 6
const QSYMDT_WCHAR    as long = 7
const QSYMDT_INTEGER  as long = 8
const QSYMDT_UINTEGER as long = 9
const QSYMDT_ENUM     as long = 10
const QSYMDT_LONG     as long = 11
const QSYMDT_ULONG    as long = 12
const QSYMDT_LONGINT  as long = 13
const QSYMDT_ULONGINT as long = 14
const QSYMDT_SINGLE   as long = 15
const QSYMDT_DOUBLE   as long = 16
const QSYMDT_STRING   as long = 17
const QSYMDT_FIXSTR   as long = 18
const QSYMDT_VA_LIST  as long = 19
const QSYMDT_STRUCT   as long = 20
const QSYMDT_NAMESPC  as long = 21
const QSYMDT_FUNCTION as long = 22
const QSYMDT_FWDREF   as long = 23
'' 26, one past the last row the published header carries: it stops at XMMWORD, and
'' fbc-modern added USTRING after it. Measured, not derived.
const QSYMDT_USTRING  as long = 26

const QSYMDT_TYPEMASK as long = &b11111
const QSYMDT_PTRPOS   as long = 5
const QSYMDT_PTRMASK  as long = &b111100000
const QSYMDT_CONSTPOS as long = 9

const QSYMCLS_INTEGER as long = 0
const QSYMCLS_FPOINT  as long = 1
const QSYMCLS_STRING  as long = 2
const QSYMCLS_UDT     as long = 3
const QSYMCLS_UNKNOWN as long = 5

function LowerQuerySymbol_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->count <> 2 then return false
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "__fb_query_symbol__" then
        return false
    end if

    '' THE QUERY, which must be a constant: it selects between answers of different
    '' kinds, and there is nothing to emit for one that is not known here.
    dim as Tko.NodeId qn = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as longint qraw = 0
    if QSymConstOf_( c, qn, qraw ) = false then return false
    dim as long q = cast( long, qraw ) and QSYM_QUERYMASK

    dim as Tko.NodeId sn = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
    dim as Tko.SymbolId sid = c.info->RefOf( sn )
    dim as Tko.Symbol ptr sy = c.syms->SymbolAt( sid )
    '' A NAME THAT IS ONLY A LABEL binds to nothing -- labels are declared under a key no
    '' written name reaches (DeclareLabel_, symbols/collectdecl.bas) -- and fbc answers
    '' LABEL for it (fbc-int/query-symbol.bas). So one is looked for by that key.
    if (sy = 0) andalso (c.ast->Kind( sn ) = Tko.N_IDENT) then
        dim as Tko.InternId lk = c.names->GetString( "$label:" & _
            c.names->Spelling( c.names->Fold( c.ast->idents[cast( long, c.ast->nodes[cast( long, sn )].data )].name ) ) )
        for i as long = 0 to c.syms->symbols.Count - 1
            if (c.syms->symbols[i].kind = cast( ubyte, Tko.SYM_LABEL )) andalso _
               (c.syms->symbols[i].name = lk) then
                sy = @c.syms->symbols[i]
                exit for
            end if
        next
    end if

    '' A NAME '#pragma reserve' TOOK has no symbol and is a class of its own: fbc answers
    '' FB_SYMBCLASS_RESERVED (fbc-int/query-symbol.bas). It was 0.
    if (sy = 0) andalso (q = QSYM_SYMBCLASS) andalso (c.ast->Kind( sn ) = Tko.N_IDENT) then
        dim as ulong rn = cast( ulong, c.names->Fold( c.ast->idents[cast( long, c.ast->nodes[cast( long, sn )].data )].name ) )
        for each r as ulong in c.syms->reservedNames
            if r = rn then
                outv = ConstInt( c, QSYMCLASS_RESERVED, MT_I64 )
                return true
            end if
        next
    end if

    select case q
    case QSYM_EXISTS
        dim as longint ev = 0
        if sy <> 0 then ev = -1
        outv = ConstInt( c, ev, MT_I64 )
        return true
    case QSYM_SYMBCLASS
        outv = ConstInt( c, QSymClassOf_( c, sy ), MT_I64 )
        return true
    case QSYM_DATATYPE, QSYM_DATACLASS
        dim as Tko.TypeId t = QSymTypeOf_( c, sn, sy )
        dim as longint dt = QSymEncodeType_( c, sy, t )
        if q = QSYM_DATATYPE then
            outv = ConstInt( c, dt, MT_I64 )
        else
            outv = ConstInt( c, QSymDataClass_( dt ), MT_I64 )
        end if
        return true
    end select
    return false
end function

'' THE QUERY CODE. It is written as an ENUM MEMBER -- 'fbc.FB_QUERY_SYMBOL.symbclass'
'' -- in every real use, and an enum member's value lives on its SYMBOL rather than in
'' the tree, so the plain constant evaluator cannot see it. Reading only the literal
'' form made this whole builtin work on hand-written probes and on nothing else: the
'' corpus writes the enum member 23 times and a literal never.
private function QSymConstOf_ _
    ( byref c as Ctx, byval qn as Tko.NodeId, byref outv as longint ) as boolean

    dim as Tko.SymbolId qs = c.info->RefOf( qn )
    dim as Tko.Symbol ptr sy = c.syms->SymbolAt( qs )
    if sy <> 0 then
        if sy->kind = cast( ubyte, Tko.SYM_ENUMCONST ) then
            outv = cast( longint, sy->payload )
            return true
        end if
        if sy->kind = cast( ubyte, Tko.SYM_CONSTANT ) then
            if sy->payload <> 0 then
                dim as Tko.NodeId item = cast( Tko.NodeId, sy->payload )
                if c.ast->Kind( item ) = Tko.N_VAR_ITEM then
                    '' WITH types AND info, because a 'cast' in the initialiser
                    '' NARROWS and needs the named type to narrow to. Without
                    '' them 'const E_FAIL = cast( long, &h80004005 )' folded to
                    '' the unnarrowed 2147500037, and every constant built on it
                    '' -- 'const BOTH = S_OK + E_FAIL' -- carried that value.
                    '' A USE narrowed it back, so 'dim as long z = BOTH' was
                    '' right and only the PRINT of the constant was wrong.
                    dim as Tko.Check.ConstVal icv = Tko.Check.ConstOf( _
                        *c.ast, StmtOf( c, item )->b, *c.srcMgr, *c.names, _
                        c.types->target.pointerBits, c.syms, sy->parent, 0, _
                        c.types, c.info )
                    '' ...at the constant's DECLARED width, as everywhere else.
                    icv = Tko.Check.ClampConstToTypeRef( _
                        *c.ast, StmtOf( c, item )->a, icv, c.types->target.pointerBits )
                    if icv.known then
                        outv = icv.value
                        return true
                    end if
                end if
            end if
        end if
    end if

    dim as Tko.Check.ConstVal cv = Tko.Check.ConstOf( _
        *c.ast, qn, *c.srcMgr, *c.names, c.types->target.pointerBits )
    if cv.known = false then return false
    outv = cv.value
    return true
end function

'' fbc's FB_SYMBCLASS for one symbol, or 0 when the argument was not a symbol at all.
function QSymClassOf_ _
    ( byref c as Ctx, byval sy as Tko.Symbol ptr ) as longint

    if sy = 0 then return 0
    select case cast( Tko.SymbolKind, sy->kind )
    '' A PARAMETER READS AS A VARIABLE. Measured, and the corpus file says so in a
    '' comment of its own: telling one from the other needs SYMBATTRIB, which this
    '' query does not expose.
    case Tko.SYM_VARIABLE, Tko.SYM_PARAMETER : return QSYMCLASS_VAR
    '' ...AND AN ENUM MEMBER AS A CONSTANT, which it is.
    case Tko.SYM_CONSTANT, Tko.SYM_ENUMCONST : return QSYMCLASS_CONST
    case Tko.SYM_PROC                        : return QSYMCLASS_PROC
    case Tko.SYM_FIELD                       : return QSYMCLASS_FIELD
    case Tko.SYM_NAMESPACE                   : return QSYMCLASS_NAMESPACE
    case Tko.SYM_ENUM                        : return QSYMCLASS_ENUM
    '' 'type C extends object' is a STRUCT here too -- _CLASS is not what fbc answers
    '' for one, measured.
    case Tko.SYM_UDT                         : return QSYMCLASS_STRUCT
    case Tko.SYM_TYPEDEF                     : return QSYMCLASS_TYPEDEF
    case Tko.SYM_LABEL                       : return QSYMCLASS_LABEL
    end select
    return 0
end function

'' The TYPE the datatype and dataclass queries answer about: the symbol's own where
'' there is one -- a PROCEDURE answers with its RESULT type, so a SUB is VOID -- and
'' the EXPRESSION's otherwise.
function QSymTypeOf_ _
    ( byref c as Ctx, byval sn as Tko.NodeId, byval sy as Tko.Symbol ptr ) as Tko.TypeId

    if sy <> 0 then return sy->type_
    return c.info->TypeOf_( sn )
end function

'' fbc's FB_DATATYPE encoding of one type.
function QSymEncodeType_ _
    ( byref c as Ctx, byval sy as Tko.Symbol ptr, byval t as Tko.TypeId ) as longint

    '' A NAMESPACE has no type of its own and answers _NAMESPC.
    if sy <> 0 then
        if sy->kind = cast( ubyte, Tko.SYM_NAMESPACE ) then return QSYMDT_NAMESPC
    end if
    if t = Tko.TYPE_NONE then return QSYMDT_VOID

    '' The POINTER LEVELS and the CONST bit for each, outermost first. 'const long ptr'
    '' is a pointer whose POINTEE is const, so its const bit is the one for level 1.
    dim as longint bits = 0
    dim as long level = 0
    dim as Tko.TypeId cur = t
    dim as long guard = 0
    do
        guard += 1
        if guard > 64 then exit do
        if c.types->IsConst( cur ) then
            bits or= (cast( longint, 1 ) shl (QSYMDT_CONSTPOS + level))
        end if
        dim as Tko.TypeId u = c.types->Unqualify( cur )
        if c.types->Kind( u ) <> Tko.TK_POINTER then
            cur = u
            exit do
        end if
        level += 1
        cur = c.types->Inner( u )
    loop
    bits or= (cast( longint, level ) shl QSYMDT_PTRPOS)

    return bits or QSymBaseType_( c, cur )
end function

'' The low five bits: fbc's base FB_DATATYPE for one unqualified, un-pointered type.
function QSymBaseType_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as longint

    if t = Tko.TYPE_NONE then return QSYMDT_VOID
    dim as Tko.TypeId u = c.types->Unqualify( t )
    select case c.types->Kind( u )
    case Tko.TK_UDT       : return QSYMDT_STRUCT
    case Tko.TK_ENUM      : return QSYMDT_ENUM
    case Tko.TK_PROC      : return QSYMDT_FUNCTION
    case Tko.TK_REFERENCE : return QSymBaseType_( c, c.types->Inner( u ) )
    '' AN ARRAY ANSWERS WITH ITS ELEMENT TYPE -- 'dim arr( 0 to 3 ) as long' is LONG,
    '' measured, and so is 'zstring * 8' CHAR rather than FIXSTR.
    case Tko.TK_ARRAY     : return QSymBaseType_( c, c.types->Inner( u ) )
    end select
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return QSYMDT_VOID
    select case c.types->BuiltinOf( u )
    case Tko.TY_VOID     : return QSYMDT_VOID
    case Tko.TY_BOOLEAN  : return QSYMDT_BOOLEAN
    case Tko.TY_BYTE     : return QSYMDT_BYTE
    case Tko.TY_UBYTE    : return QSYMDT_UBYTE
    case Tko.TY_ZSTRING  : return QSYMDT_CHAR
    case Tko.TY_SHORT    : return QSYMDT_SHORT
    case Tko.TY_USHORT   : return QSYMDT_USHORT
    case Tko.TY_WSTRING  : return QSYMDT_WCHAR
    case Tko.TY_INTEGER  : return QSYMDT_INTEGER
    case Tko.TY_UINTEGER : return QSYMDT_UINTEGER
    case Tko.TY_LONG     : return QSYMDT_LONG
    case Tko.TY_ULONG    : return QSYMDT_ULONG
    case Tko.TY_LONGINT  : return QSYMDT_LONGINT
    case Tko.TY_ULONGINT : return QSYMDT_ULONGINT
    case Tko.TY_SINGLE   : return QSYMDT_SINGLE
    case Tko.TY_DOUBLE   : return QSYMDT_DOUBLE
    case Tko.TY_STRING   : return QSYMDT_STRING
    case Tko.TY_FIXSTR   : return QSYMDT_FIXSTR
    case Tko.TY_CVA_LIST : return QSYMDT_VA_LIST
    case Tko.TY_USTRING  : return QSYMDT_USTRING
    case Tko.TY_FIXUSTR  : return QSYMDT_USTRING
    end select
    return QSYMDT_VOID
end function

'' fbc's FB_DATACLASS, which follows from the encoded datatype and not from the symbol.
'' A POINTER is INTEGER whatever it points at -- 'any ptr' is class 0, measured.
function QSymDataClass_( byval dt as longint ) as longint
    if (dt and QSYMDT_PTRMASK) <> 0 then return QSYMCLS_INTEGER
    select case dt and QSYMDT_TYPEMASK
    case QSYMDT_SINGLE, QSYMDT_DOUBLE                 : return QSYMCLS_FPOINT
    case QSYMDT_STRING, QSYMDT_FIXSTR, QSYMDT_USTRING : return QSYMCLS_STRING
    case QSYMDT_STRUCT, QSYMDT_NAMESPC                : return QSYMCLS_UDT
    case QSYMDT_VOID, QSYMDT_FWDREF                   : return QSYMCLS_UNKNOWN
    end select
    return QSYMCLS_INTEGER
end function

end namespace
