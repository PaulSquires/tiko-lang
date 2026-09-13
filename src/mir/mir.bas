'' mir.bas -- MIR construction and the opcode metadata tables.

#include once "mir/mir.bi"

namespace Tko.Mir

constructor MirModule( )
end constructor

destructor MirModule( )
    for i as long = 0 to this.functions.Count - 1
        if this.functions[i] <> 0 then delete this.functions[i]
    next
end destructor

sub MirFunction.AddParam _
    ( byval ty as MirType, byval aggSize as ulong, byval aggClass as ulong, _
      byval attr as ubyte )

    this.paramTys.Push( cast( ubyte, ty ) )
    this.paramAggs.Push( aggSize )
    this.paramClasses.Push( aggClass )
    this.paramAttrs.Push( attr )
    this.paramCount = this.paramTys.Count
end sub

function MirModule.AddFunction _
    ( byval nm as InternId, byval retTy as MirType ) as MirFunction ptr

    dim as MirFunction ptr f = new MirFunction
    f->name = nm
    f->retTy = cast( ubyte, retTy )
    f->nextTemp = 1
    this.functions.Push( f )
    return f
end function

'' A WIDE string literal.
''
'' Measured: fbc folds 'wstr( "abc" )' at COMPILE TIME into L"abc" and emits no call
'' at all -- not fb_StrToWstr on the literal's bytes. Kept separate from the narrow
'' pool because a narrow and a wide literal of the same text are different objects.
'' A DATA block. Never shared: two identical blocks are still two blocks, because
'' the chain threads through their terminators and sharing one would make it a cycle.
function MirModule.AddDataBlock( byref names as Interner ) as long
    dim as MirGlobal g
    g.isData = true
    g.dataFirst = this.dataTypes.Count
    g.dataCount = 0
    g.name = names.GetString( "$data" & str( this.globals.Count ) )
    this.globals.Push( g )
    return this.globals.Count - 1
end function

sub MirModule.PushDataEntry _
    ( byval g as long, byval ty as long, byval ref as long )

    if (g < 0) orelse (g >= this.globals.Count) then return
    this.dataTypes.Push( ty )
    this.dataRefs.Push( ref )
    this.globals[g].dataCount += 1
end sub

'' A WIDE LITERAL FROM ITS DECODED CODE UNITS.
''
'' 'text' is the literal's SOURCE spelling and is what the dump prints; the UNITS
'' are the value. Widening the text one byte per unit -- which is what this used
'' to be -- cannot express a '\uXXXX' above 255, and the corpus's wide tests are
'' made of them: 'trim.bas' alone writes 186.
''
'' Two literals with the same TEXT have the same units, so the text is still the
'' merge key.
function MirModule.AddWideStringUnits _
    ( byref text as string, byref units as FB.Array( of ulong ), _
      byref names as Interner ) as long

    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isString andalso this.globals[i].isWide andalso _
           (this.globals[i].bytes = text) then
            return i
        end if
    next
    dim as MirGlobal g
    g.bytes = text
    g.isString = true
    g.isWide = true
    g.wcharFirst = this.wcharPool.Count
    g.wcharCount = units.Count
    g.name = names.GetString( "$wstr" & str( this.globals.Count ) )
    this.globals.Push( g )
    for i as long = 0 to units.Count - 1
        this.wcharPool.Push( units[i] )
    next
    return this.globals.Count - 1
end function

'' ...and from plain TEXT, one unit per byte. Every caller that has no escapes to
'' decode goes through here, and the units are filled in the same way so nothing
'' downstream has to know which entry point was used.
function MirModule.AddWideStringLiteral _
    ( byref text as string, byref names as Interner ) as long

    dim as FB.Array( of ulong ) units
    for i as long = 0 to len( text ) - 1
        units.Push( cast( ulong, text[i] ) )
    next
    return this.AddWideStringUnits( text, units, names )
end function

function MirModule.AddStringLiteral _
    ( byref text as string, byref names as Interner ) as long

    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isString andalso (this.globals[i].isWide = false) andalso _
           (this.globals[i].bytes = text) then
            return i
        end if
    next
    dim as MirGlobal g
    g.bytes = text
    g.isString = true
    g.name = names.GetString( "$str" & str( this.globals.Count ) )
    this.globals.Push( g )
    return this.globals.Count - 1
end function

function MirModule.AddPtrTable( byval nm as InternId ) as long
    '' By NAME, so a type's table is found again rather than built twice: the base's
    '' RTTI is referenced by every type below it in the chain.
    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isPtrTable andalso (this.globals[i].name = nm) then return i
    next
    dim as MirGlobal g
    g.name = nm
    g.isPtrTable = true
    g.ptrFirst = this.ptrKinds.Count
    g.ptrCount = 0
    this.globals.Push( g )
    return this.globals.Count - 1
end function

'' The three entry kinds. Each APPENDS, so a table has to be filled before the next one
'' is opened -- the pool is shared and the runs are contiguous.
sub MirModule.PushPtrNull( byval g as long )
    this.ptrKinds.Push( 0 )
    this.ptrRefs.Push( 0 )
    this.globals[g].ptrCount += 1
end sub

sub MirModule.PushPtrGlobal( byval g as long, byval which as long )
    this.ptrKinds.Push( 1 )
    this.ptrRefs.Push( cast( ulong, which ) )
    this.globals[g].ptrCount += 1
end sub

sub MirModule.PushPtrFunc( byval g as long, byval nm as InternId )
    this.ptrKinds.Push( 2 )
    this.ptrRefs.Push( cast( ulong, nm ) )
    this.globals[g].ptrCount += 1
end sub

function MirModule.AddVarGlobal _
    ( byval nm as InternId, byval ty as MirType, byval ft as Tko.TypeId, _
      byval sizeBytes as long ) as long

    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isVar andalso (this.globals[i].name = nm) then return i
    next
    dim as MirGlobal g
    g.name = nm
    g.isVar = true
    '' -1 IS 'NO RELOCATION'. Zero is a valid global index, so a zero-initialised
    '' field would name the first global in the module as every static pointer's
    '' initial value.
    g.initReloc = -1
    g.ty = cast( ubyte, ty )
    g.frontendType = ft
    g.size = sizeBytes
    this.globals.Push( g )
    return this.globals.Count - 1
end function

'' ------------------------------------------------------------------ metadata

function TypeName( byval t as MirType ) as string
    select case t
    case MT_VOID : return "void"
    case MT_I8   : return "i8"
    case MT_I16  : return "i16"
    case MT_I32  : return "i32"
    case MT_I64  : return "i64"
    case MT_F32  : return "f32"
    case MT_F64  : return "f64"
    case MT_PTR  : return "ptr"
    case MT_AGG  : return "agg"
    end select
    return "?"
end function

function OpName( byval o as MirOp ) as string
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_name
    TKO_MIR_LIST( OP )
    #undef OP
    end select
    return "?"
end function

function OpArity( byval o as MirOp ) as long
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_args
    TKO_MIR_LIST( OP )
    #undef OP
    end select
    return 0
end function

function OpHasResult( byval o as MirOp ) as boolean
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_res
    TKO_MIR_LIST( OP )
    #undef OP
    end select
    return false
end function

'' ------------------------------------------------------------------- lowering

'' The MIR type of a frontend type. Note what collapses here: BOOLEAN becomes i8,
'' every pointer becomes MT_PTR whatever it points at, and STRING is NOT handled --
'' it is a 24-byte descriptor whose lowering needs the runtime, which this slice of
'' phase 6 does not have.
function LowerType _
    ( byval t as Tko.TypeId, byref types as Tko.TypeContext ) as MirType

    if t = Tko.TYPE_NONE then return MT_VOID

    select case types.Kind( t )
    case Tko.TK_POINTER, Tko.TK_REFERENCE, Tko.TK_PROC
        return MT_PTR
    case Tko.TK_ARRAY
        '' A fixed array is storage, addressed by arithmetic rather than loaded whole,
        '' so it is an aggregate however small it is. Falling through to the element's
        '' type would reserve ONE element -- four bytes where forty were needed.
        return MT_AGG
    case Tko.TK_UDT, Tko.TK_ENUM
        '' An ENUM is its underlying integer, which is INTEGER-wide -- 8 bytes on
        '' win64 and 4 on win32, measured -- and not a fixed 32 bits. A UDT is opaque.
        if types.Kind( t ) = Tko.TK_ENUM then
            if types.target.pointerBits = 32 then return MT_I32
            return MT_I64
        end if
        return MT_AGG
    case Tko.TK_BUILTIN
        select case types.BuiltinOf( t )
        case Tko.TY_VOID     : return MT_VOID
        case Tko.TY_BYTE, Tko.TY_UBYTE, Tko.TY_BOOLEAN : return MT_I8
        case Tko.TY_SHORT, Tko.TY_USHORT : return MT_I16
        case Tko.TY_LONG, Tko.TY_ULONG   : return MT_I32
        case Tko.TY_INTEGER, Tko.TY_UINTEGER, Tko.TY_LONGINT, Tko.TY_ULONGINT
            '' INTEGER is pointer-sized, so its width comes from the target rather
            '' than from a constant.
            if types.target.pointerBits = 32 then return MT_I32
            return MT_I64
        case Tko.TY_STRING, Tko.TY_USTRING
            '' A var-length string is a DESCRIPTOR -- 24 bytes on x86-64 -- not a
            '' pointer. Lowering it as MT_PTR would reserve 8 bytes and corrupt the
            '' neighbouring slot the moment the runtime wrote to it.
            return MT_AGG
        case Tko.TY_SINGLE   : return MT_F32
        case Tko.TY_DOUBLE   : return MT_F64
        '' AN AGGREGATE ON EVERY TARGET, even where it is pointer-sized. On Windows a
        '' cva_list is one pointer and MT_PTR would fit, but on Linux it is 24 bytes --
        '' and the four cva_* opcodes all take its ADDRESS, so nothing ever loads it
        '' whole. One shape everywhere means the lowering has no target case in it.
        case Tko.TY_CVA_LIST : return MT_AGG
        '' The ELEMENT of a 'ustring * N'; the array around it is the aggregate.
        case Tko.TY_FIXUSTR  : return MT_I16
        case Tko.TY_ANY      : return MT_VOID
        end select
    end select
    return MT_VOID
end function

'' A USTRING'S LITERAL IS UTF-16 ON EVERY TARGET. Lowering shares one wide-literal pool
'' between wstring and ustring consumers, and the emitter widened every entry to the
'' target's wchar -- right for fb_Wstr*, and on Linux, where wchar is 4 bytes, wrong
'' for fb_UStr*: 'dim as ustring u = "src/lexer.bas"' held one character, 's', and
'' tiko-lang's own source manager could not open an include file.
''
'' So each wide global passed to an fb_UStr* entry point is swapped for a UTF-16 twin,
'' made once per literal. The wchar original stays for any other use. A unit above
'' U+FFFF would need a surrogate pair and a different length; that literal is left as
'' it was rather than half-converted.
sub MirModule.SplitUtf16Literals( byref names as Interner )
    for fi as long = 0 to this.functions.Count - 1
        dim as MirFunction ptr f = this.functions[fi]
        if f = 0 then continue for
        for bi as long = 0 to f->blocks.Count - 1
            for ii as long = 0 to f->blocks[bi].insts.Count - 1
                dim as MirInst ptr ins = @f->blocks[bi].insts[ii]
                if cast( MirOp, ins->op ) <> M_CALL_RTL then continue for
                dim as long ci = cast( long, ins->callee )
                if (ci < 0) orelse (ci >= this.functions.Count) then continue for
                if this.functions[ci] = 0 then continue for
                if left( names.Spelling( this.functions[ci]->name ), 7 ) <> "fb_UStr" then continue for
                for k as long = 0 to ins->count - 1
                    dim as long ak = (ins->first + k) * 2
                    if (ak + 1) >= this.argPool.Count then exit for
                    if this.argPool[ak] <> cast( ulong, MV_GLOBAL ) then continue for
                    dim as long gi = cast( long, this.argPool[ak + 1] )
                    if (gi < 0) orelse (gi >= this.globals.Count) then continue for
                    if (this.globals[gi].isWide = false) orelse this.globals[gi].isUtf16 then continue for
                    '' The units, copied out first: pushing a pool element into its own
                    '' pool hands Push a reference the reallocation invalidates.
                    dim as FB.Array( of ulong ) units
                    dim as boolean fits = true
                    for u as long = 0 to this.globals[gi].wcharCount - 1
                        dim as ulong cu = this.wcharPool[this.globals[gi].wcharFirst + u]
                        if cu > &hFFFF then fits = false
                        units.Push( cu )
                    next
                    if fits = false then continue for
                    dim as long twin = -1
                    for gj as long = 0 to this.globals.Count - 1
                        if this.globals[gj].isUtf16 = false then continue for
                        if this.globals[gj].wcharCount <> units.Count then continue for
                        dim as boolean same = true
                        for u as long = 0 to units.Count - 1
                            if this.wcharPool[this.globals[gj].wcharFirst + u] <> units[u] then
                                same = false
                                exit for
                            end if
                        next
                        if same then
                            twin = gj
                            exit for
                        end if
                    next
                    if twin < 0 then
                        dim as MirGlobal g
                        g.bytes = this.globals[gi].bytes
                        g.isString = true
                        g.isWide = true
                        g.isUtf16 = true
                        g.wcharFirst = this.wcharPool.Count
                        g.wcharCount = units.Count
                        g.name = names.GetString( "$ustr" & str( this.globals.Count ) )
                        for u as long = 0 to units.Count - 1
                            this.wcharPool.Push( units[u] )
                        next
                        this.globals.Push( g )
                        twin = this.globals.Count - 1
                    end if
                    this.argPool[ak + 1] = cast( ulong, twin )
                next
            next
        next
    next
end sub

end namespace
