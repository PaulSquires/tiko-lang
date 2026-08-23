'' type.bi -- the semantic type model.
''
'' Types are CANONICAL and INTERNED: a TypeId is a 32-bit handle, and two structurally
'' identical types share one id, so type equality is an integer compare
'' (docs/plan/06 section 1). That is what makes tuples' structural identity natural
'' rather than special-cased.
''
'' The model is TARGET-INDEPENDENT. Sizes and alignments come from a TargetLayout that
'' is injected, never hard-coded here, so "do not assume BASIC integer types map
'' identically across platforms" is structurally impossible to get wrong.
''
'' Invariants:
''   - TypeId 0 is TYPE_NONE.
''   - The builtin ids are FIXED small constants, so a builtin lookup is free and a
''     dump is stable across runs.
''   - Interning is by structural key: Pointer(Long) asked for twice is one id.

#ifndef __TKO_TYPE_BI__
#define __TKO_TYPE_BI__

#include once "tko.bi"
#include once "support/intern.bi"

namespace Tko

    type TypeId as ulong
    const TYPE_NONE as TypeId = 0

    '' BUILTIN( id name, spelling, bits, signed, class )
    ''
    '' 'integer' and 'uinteger' are POINTER-SIZED -- 32-bit on a 32-bit target, 64 on
    '' a 64-bit one -- while 'long'/'ulong' are always 32 and 'longint'/'ulongint'
    '' always 64. That is the single most common source of ported-code bugs, so the
    '' width here is a PROPERTY resolved by the data layout, not a number.
    #macro TKO_BUILTIN_LIST( BUILTIN )
        BUILTIN( TY_VOID,     "void",     0,   false, TC_VOID  )
        BUILTIN( TY_BYTE,     "byte",     8,   true,  TC_INT   )
        BUILTIN( TY_UBYTE,    "ubyte",    8,   false, TC_INT   )
        BUILTIN( TY_SHORT,    "short",    16,  true,  TC_INT   )
        BUILTIN( TY_USHORT,   "ushort",   16,  false, TC_INT   )
        BUILTIN( TY_LONG,     "long",     32,  true,  TC_INT   )
        BUILTIN( TY_ULONG,    "ulong",    32,  false, TC_INT   )
        BUILTIN( TY_INTEGER,  "integer",  0,   true,  TC_INTPTR )
        BUILTIN( TY_UINTEGER, "uinteger", 0,   false, TC_INTPTR )
        BUILTIN( TY_LONGINT,  "longint",  64,  true,  TC_INT   )
        BUILTIN( TY_ULONGINT, "ulongint", 64,  false, TC_INT   )
        BUILTIN( TY_SINGLE,   "single",   32,  true,  TC_FLOAT )
        BUILTIN( TY_DOUBLE,   "double",   64,  true,  TC_FLOAT )
        BUILTIN( TY_BOOLEAN,  "boolean",  8,   false, TC_BOOL  )
        BUILTIN( TY_STRING,   "string",   0,   false, TC_STRING )
        BUILTIN( TY_ZSTRING,  "zstring",  8,   false, TC_ZSTRING )
        BUILTIN( TY_WSTRING,  "wstring",  0,   false, TC_WSTRING )
        BUILTIN( TY_USTRING,  "ustring",  0,   false, TC_USTRING )
        '' 'string * N' -- THE FIXED-LENGTH, SPACE-PADDED STRING, and a THIRD string
        '' flavour rather than a spelling of either of the two above it. Measured:
        ''
        ''   storage        exactly N bytes, no terminator and no room for one
        ''   initial value  N SPACES (memset value 32), where a zstring gets NULs
        ''   capacity       N usable characters, where 'zstring * N' holds N-1
        ''   runtime length passed as '&h8000000000000000 or N' -- the SIGN BIT is the
        ''                  tag that says "fixed-length", and the low bits carry N
        ''   len()          a COMPILE-TIME CONSTANT N, never a call, never content
        ''
        '' Modelled as an ARRAY of this one-byte element, exactly as zstring and wstring
        '' are, so the size and alignment fall out of the array rule. It was previously
        '' resolved to the plain 'string' builtin -- a 24-byte DESCRIPTOR where fbc has
        '' N raw bytes -- so every one was the wrong size and every access read the
        '' wrong thing.
        BUILTIN( TY_FIXSTR,   "fixstr",   8,   false, TC_ZSTRING )
        '' THE VARARG CURSOR, 'cva_list'. Opaque: no conversions, no arithmetic, and
        '' the only things that read it are the four cva_* intrinsics, each of which
        '' takes its ADDRESS. Its width comes from TargetLayout because it differs by
        '' target in a way nothing else here does.
        BUILTIN( TY_CVA_LIST, "cva_list", 0,   false, TC_CVA   )
        BUILTIN( TY_ANY,      "any",      0,   false, TC_ANY   )
    #endmacro

    enum TypeClass
        TC_VOID = 0
        TC_INT
        TC_INTPTR       '' integer/uinteger: width comes from the target
        TC_FLOAT
        TC_BOOL
        TC_STRING       '' var-len FBSTRING descriptor
        TC_ZSTRING
        TC_WSTRING      '' 2 bytes/unit on Windows, 4 on Linux -- a real FB difference
        TC_USTRING      '' FBUSTRING; UTF-16 code units on EVERY target
        TC_ANY
        TC_CVA          '' cva_list: opaque, and target-sized
    end enum

    enum BuiltinType
        TY_NONE = 0
        #define BUILTIN( b_id, b_name, b_bits, b_signed, b_class ) b_id,
        TKO_BUILTIN_LIST( BUILTIN )
        #undef BUILTIN
        TY_BUILTIN_COUNT
    end enum

    enum TypeKind
        TK_ERROR = 0
        TK_BUILTIN
        TK_POINTER
        TK_REFERENCE
        TK_ARRAY
        TK_PROC
        TK_UDT
        TK_ENUM
        TK_TYPEDEF
        TK_TUPLE
        TK_FORWARD      '' named but not yet complete
    end enum

    const TF_CONST    as ushort = &h0001
    const TF_COMPLETE as ushort = &h0002

    type TypeInfo
        as ubyte    kind
        as ubyte    builtin        '' BuiltinType, when kind = TK_BUILTIN
        as ushort   flags
        as TypeId   inner          '' pointee / referent / element / return type
        as InternId name           '' UDT, enum, typedef
        as long     first          '' element list (tuple, proc params), into a pool
                                   '' TK_ARRAY: (lo, hi) pairs, into boundPool
        as long     count
        as long     dims           '' array rank; -1 for a dynamic array
        as long     packing        '' UDT: the 'field = N' cap, 0 for none
        as long     elems          '' TK_ARRAY: TOTAL element count across all
                                   '' dimensions, which is what a layout needs;
                                   '' 0 when the count is not known
        as ulong    declScope      '' UDT/ENUM/TYPEDEF: the scope it was declared in.
                                   '' Part of the IDENTITY -- two namespaces may each
                                   '' hold a 'Vec' -- and part of the mangled name,
                                   '' which spells a namespaced UDT as N<prefix>3VECE.
    end type

    '' The targets tiko-lang can compile for. Windows comes in both widths; Linux is 64-bit
    '' only, deliberately -- x86-32 Linux is a THIRD set of layout numbers (wchar is 4
    '' bytes there, and 8-byte alignment differs) and nobody has asked for it.
    enum TargetId
        TARGET_WIN64 = 0
        TARGET_WIN32
        TARGET_LINUX_X86_64
    end enum

    '' Target facts, injected. The frontend never hard-codes a size.
    type TargetLayout
        as long pointerBits        '' 64
        as long wcharBytes         '' 2 on Windows, 4 on Linux
        as long stringBytes        '' sizeof( FBSTRING ) -- 24 on x86-64
        as long stringAlign
        as long maxAlign
        '' sizeof( cva_list ) and its alignment. MEASURED, and it is not derivable from
        '' the pointer width: fbc emits '__builtin_memset( &ARGS, 0, N )' at every
        '' 'dim as cva_list' declaration, and N is 8 on win64, 4 on win32 and 24 on
        '' Linux x86-64 -- where a va_list is the SysV register-save record, not a
        '' pointer. Getting it wrong is a stack overwrite, not a wrong number.
        as long cvaListBytes
        as long cvaListAlign
        '' Windows or not. Only cva_list needs it so far, and only for its MANGLING,
        '' which is target-dependent in a way no width explains -- see BuiltinCode.
        as boolean isWindows
    end type

    type TypeVec  as FB.Array( of TypeInfo )
    type TypeIdVec2 as FB.Array( of ulong )

    type TypeLayout
        as long size
        as long align
    end type

    type TypeContext
        as TypeVec       types
        as TypeIdVec2    pool        '' element lists
        as FB.Array( of longint ) boundPool   '' TK_ARRAY (lo, hi) pairs
        as Interner ptr  names
        as TargetLayout  target

        declare constructor( )
        declare sub Attach( byval it as Interner ptr, byref tgt as TargetLayout )

        declare function Builtin( byval b as BuiltinType ) as TypeId
        declare function Pointer_( byval pointee as TypeId ) as TypeId
        declare function Reference( byval referent as TypeId ) as TypeId
        '' 'bounds' is rank (lo, hi) PAIRS, in declaration order. Retaining them is
        '' what makes indexing lowerable: the address of a(i,j) needs each dimension's
        '' stride and the lbound bias, and the total element count alone gives neither.
        declare function ArrayOf _
            ( byval elem as TypeId, byval rank as long, _
              byval elems as long = 0, _
              byval bounds as FB.Array( of longint ) ptr = 0 ) as TypeId
        '' The declared bounds of one dimension. 'known' is false for an array whose
        '' bounds were not constant, in which case nothing may be folded.
        declare function ArrayBound _
            ( byval t as TypeId, byval dim_ as long, byval hi as boolean, _
              byref known as boolean ) as longint
        declare function Qualify( byval t as TypeId, byval fl as ushort ) as TypeId
        '' A UDT, ENUM or TYPEDEF is identified by its NAME, not structurally, so it
        '' needs its own finder: Find( ) compares inner/flags/rank and would collapse
        '' two unrelated types into one.
        declare function NamedType _
            ( byval k as TypeKind, byval nm as InternId, _
              byval declScope as ulong = 0 ) as TypeId
        declare function NameOf( byval t as TypeId ) as InternId
        declare function ElemCount( byval t as TypeId ) as long
        declare function Packing( byval t as TypeId ) as long
        declare function DeclScopeOf( byval t as TypeId ) as ulong
        declare sub SetPacking( byval t as TypeId, byval n as long )
        '' Qualify( ) can only ADD flags. Removing const needs its own operation --
        '' 'Qualify( t, 0 )' silently returns t unchanged.
        declare function Unqualify( byval t as TypeId ) as TypeId
        declare function ProcType _
            ( byval ret as TypeId, byref params as TypeIdVec2 ) as TypeId

        declare function Kind( byval t as TypeId ) as TypeKind
        declare function BuiltinOf( byval t as TypeId ) as BuiltinType
        declare function DynArrayOf _
            ( byval elem as TypeId, byval rank as long ) as TypeId
        declare function IsDynArray( byval t as TypeId ) as boolean
        declare function DynRank( byval t as TypeId ) as long
        declare function Inner( byval t as TypeId ) as TypeId
        declare function IsConst( byval t as TypeId ) as boolean

        declare function Layout( byval t as TypeId ) as TypeLayout
        declare function Name( byval t as TypeId ) as string
        declare function Count( ) as long

        private:
        '' Parameters are not named 'kind'/'inner': those collide with the member
        '' functions Kind( ) and Inner( ) inside a member body.
        declare function Find _
            ( byval wantKind as TypeKind, byval innerT as TypeId, byval fl as ushort, _
              byval rank as long ) as TypeId
    end type

    declare function BuiltinName( byval b as BuiltinType ) as string
    declare function BuiltinClass( byval b as BuiltinType ) as TypeClass
    declare function DefaultTargetLayout( ) as TargetLayout
    '' The layout of one target. Every number in it is measured from fbc for that
    '' target, not derived from the width.
    declare function TargetLayoutFor( byval t as TargetId ) as TargetLayout
    '' The target tiko-lang defaults to when none is named: the one it is running on.
    declare function HostTarget( ) as TargetId
    declare function TargetName( byval t as TargetId ) as string
    declare function TargetFromName( byval nm as string, byref ok as boolean ) as TargetId
    declare function TargetIs64( byval t as TargetId ) as boolean
    declare function TargetIsWindows( byval t as TargetId ) as boolean

    '' --dump-types. Byte-stable: a golden artefact, and the thing the layout
    '' differential compares against fbc.
    declare function DumpTypes( byref tc as TypeContext ) as string

end namespace

#endif
