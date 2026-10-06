'' llvmglobal.bas -- emitting a module's globals: literals, pointer tables, data blocks and
'' variables, and their linkage. Moved out of llvmemit.bas verbatim on 2026-09-27 for the
'' 1500-line cap. #included by llvmemit.bas IN PLACE, where the block stood.

'' ---------------------------------------------------------------- globals
''
'' EVERY BYTE IS ESCAPED THAT IS NOT PLAINLY PRINTABLE. LLVM's c"..." accepts raw bytes
'' and a backslash-hex escape, and the set that MUST be escaped is smaller than the set
'' that SHOULD be: a literal newline inside a constant is legal and unreadable, and a
'' stray quote or backslash ends or corrupts the string. Escaping conservatively costs
'' nothing and removes the whole question.
private function CString( byref b as string ) as string
    dim as string r = "c"""
    for i as long = 0 to len( b ) - 1
        dim as long ch = b[i]
        dim as boolean plain = (ch >= 32) andalso (ch <= 126)
        if (ch = 34) orelse (ch = 92) then plain = false
        if plain then
            r += chr( ch )
        else
            r += "\" & hex( ch, 2 )
        end if
    next
    return r & """"
end function

'' A wide literal's code units, as an array of the target's wchar. THE WIDTH IS THE
'' TARGET'S -- 2 bytes on Windows, 4 on Linux -- which is why MIR keeps the units and
'' not the bytes: baking a width in would have made the IR target-specific.
private function WideArray _
    ( byref e as EmitCtx, byref g as MirGlobal ) as string

    dim as long w = e.tgt->layout.wcharBytes
    if g.isUtf16 then w = 2
    dim as string ety = "i16"
    if w = 4 then ety = "i32"
    dim as long n = g.wcharCount + 1        '' the terminating NUL
    dim as string r = "[" & str( n ) & " x " & ety & "] ["
    for i as long = 0 to g.wcharCount - 1
        if i > 0 then r += ", "
        r += ety & " " & str( e.m->wcharPool[g.wcharFirst + i] )
    next
    if g.wcharCount > 0 then r += ", "
    r += ety & " 0]"
    return r
end function

'' WHO MAY SEE A VARIABLE, as LLVM spells it.
''
'' 'internal' is C's 'static': one module's object, invisible to the linker. fbc writes
'' every DIM SHARED and every static local that way, and without it two modules each
'' declaring one were a duplicate symbol.
''
'' 'common' is C's TENTATIVE DEFINITION -- declared, visible, and not yet given a value,
'' so the linker MERGES the copies instead of refusing them. That is what fbc emits for
'' 'common shared' and for an uninitialised static member, and the rule is whether an
'' initializer was WRITTEN, not what it says: '= 0' is a definition and lands in .bss as
'' an ordinary external symbol. LLVM requires a common global to be zero-initialised,
'' which is exactly the case this answers for.
''
'' The default -- neither word -- is external.
private function VarLinkage( byref e as EmitCtx, byref g as MirGlobal ) as string
    if g.isInternal then return "internal "
    if g.isTentative = false then return iif( g.isHidden, "hidden ", "" )
    dim as boolean valued = g.hasInit orelse (len( g.initBytes ) > 0)
    if valued = false then valued = (g.initReloc >= 0) orelse (g.initRelocFn <> 0)
    if valued = false then valued = (g.ptrCount > 0)
    if valued then return ""
    return "common "
end function

private sub EmitGlobal( byref e as EmitCtx, byref g as MirGlobal )
    dim as string nm = GlobalName( e, g.name )

    '' DECLARED HERE, DEFINED ELSEWHERE -- 'object's RTTI record lives in the runtime.
    '' Without 'external' an empty table would read as a real one with no entries.
    if g.isExternal then
        '' ...AND AN EXTERN VARIABLE, whose type is its own rather than a pointer:
        '' 'extern CLSID_ShellLink as const GUID' is 16 bytes, and declaring it as a
        '' pointer would let a read of it take 8.
        dim as string ety = "ptr"
        if g.isVar then ety = LlvmType( cast( MirType, g.ty ), g.size )
        '' ...AND A DLL'S, on Windows (T85): 'dllimport' makes LLVM load the address from
        '' '__imp_<name>', which is all an import library defines for DATA -- unlike a
        '' function, a variable has no thunk. ELF resolves it through the GOT unasked.
        dim as string dllimp = ""
        if g.isDllImport andalso (e.tgt->objFormat = OBJ_COFF) then dllimp = "dllimport "
        e.outp += nm & " = external " & dllimp & "global " & ety & chr( 10 )
        return
    end if

    '' A WIDE LITERAL IS TESTED FIRST, and it is a STRING TOO -- AddWideStringUnits
    '' sets isString AND isWide, because the merge lists and the dump both ask "is
    '' this a string" before asking how wide it is. Testing isString first therefore
    '' returned on every wide literal and this branch, and WideArray with it, was
    '' dead code from the day it was written: every wstring literal reached the
    '' linker as its SOURCE BYTES, one per character, and the runtime read those
    '' bytes as uint16 code units. 'dim as string k = wstr( "fOoBaR" )' printed
    '' '????' -- three CJK characters made out of six ASCII ones, none of which
    '' converts back to narrow -- and a 'wstring * N' field read past the end of a
    '' global half the size it should be.
    if g.isWide then
        e.outp += nm & " = private unnamed_addr constant " & WideArray( e, g ) & _
                  ", align " & str( iif( g.isUtf16, 2, e.tgt->layout.wcharBytes ) ) & chr( 10 )
        return
    end if

    '' 'private' because a literal is not a symbol anyone links against, and
    '' 'unnamed_addr' because two identical literals may share storage -- which is
    '' what MIR has already done by merging them.
    if g.isString then
        dim as long n = len( g.bytes ) + 1
        e.outp += nm & " = private unnamed_addr constant [" & str( n ) & " x i8] " & _
                  CString( g.bytes & chr( 0 ) ) & ", align 1" & chr( 10 )
        return
    end if

    '' A VTABLE OR AN RTTI RECORD: a run of pointer-sized words, each a null, another
    '' global's address, or a FUNCTION's address BY NAME -- by name because the
    '' function may be defined in another module and have no index here.
    if g.isPtrTable then
        dim as string body
        for i as long = 0 to g.ptrCount - 1
            if i > 0 then body += ", "
            dim as long k = e.m->ptrKinds[g.ptrFirst + i]
            dim as ulong ref = e.m->ptrRefs[g.ptrFirst + i]
            select case k
            case 0
                body += "ptr null"
            case 1
                if cast( long, ref ) >= e.m->globals.Count then
                    Ice( e, "a pointer table entry naming a global that does not exist" )
                    return
                end if
                body += "ptr " & GlobalName( e, e.m->globals[cast( long, ref )].name )
            case 2
                body += "ptr @""" & e.names->Spelling( cast( Tko.InternId, ref ) ) & """"
            case else
                Ice( e, "a pointer table entry of an unknown kind" )
                return
            end select
        next
        e.outp += nm & " = " & VarLinkage( e, g ) & "global [" & str( g.ptrCount ) & _
                  " x ptr] [" & body & _
                  "], align " & str( e.tgt->layout.pointerBits \ 8 ) & chr( 10 )
        return
    end if

    '' A DATA BLOCK is a packed array of { int16 TYPE; ptr NODE }. PACKED, because the
    '' pair is 2 + 8 bytes with no padding between entries -- an unpacked struct would
    '' align each one to 8 and the runtime walks the block by stride.
    if g.isData then
        dim as string body
        for i as long = 0 to g.dataCount - 1
            if i > 0 then body += ", "
            dim as long dt = e.m->dataTypes[g.dataFirst + i]
            dim as long dr = e.m->dataRefs[g.dataFirst + i]
            dim as string p = "ptr null"
            if dr >= 0 then
                if dr >= e.m->globals.Count then
                    Ice( e, "a data entry naming a global that does not exist" )
                    return
                end if
                p = "ptr " & GlobalName( e, e.m->globals[dr].name )
            end if
            body += "<{ i16, ptr }> <{ i16 " & str( dt ) & ", " & p & " }>"
        next
        e.outp += nm & " = global [" & str( g.dataCount ) & " x <{ i16, ptr }>] [" & _
                  body & "], align 8" & chr( 10 )
        return
    end if

    if g.isVar = false then
        Ice( e, "a global that is neither storage nor a literal" )
        return
    end if
    EmitVarGlobal( e, g, nm )
end sub

'' The packed-struct initialiser of a ptrMixed global -- see EmitVarGlobal.
private sub EmitMixedGlobal_ _
    ( byref e as EmitCtx, byref g as MirGlobal, byref nm as string )

    dim as long pw = e.tgt->layout.pointerBits \ 8
    dim as string img = g.initBytes
    while len( img ) < g.size
        img += chr( 0 )
    wend
    dim as string mtys, mvals
    dim as long at = 0
    for i as long = 0 to g.ptrCount - 1
        dim as long off = e.m->ptrOffs[g.ptrFirst + i]
        if (off < at) orelse (off + pw > g.size) then
            Ice( e, "a relocation outside its object, or out of order" )
            return
        end if
        if off > at then
            if len( mtys ) > 0 then mtys += ", " : mvals += ", "
            mtys += "[" & str( off - at ) & " x i8]"
            mvals += "[" & str( off - at ) & " x i8] " & CString( mid( img, at + 1, off - at ) )
        end if
        dim as long k = e.m->ptrKinds[g.ptrFirst + i]
        dim as ulong ref = e.m->ptrRefs[g.ptrFirst + i]
        dim as string pv = "ptr null"
        select case k
        case 1
            if cast( long, ref ) >= e.m->globals.Count then
                Ice( e, "a relocation naming a global that does not exist" )
                return
            end if
            pv = "ptr " & GlobalName( e, e.m->globals[cast( long, ref )].name )
        case 2
            pv = "ptr @" & chr( 34 ) & e.names->Spelling( cast( Tko.InternId, ref ) ) & chr( 34 )
        end select
        if len( mtys ) > 0 then mtys += ", " : mvals += ", "
        mtys += "ptr"
        mvals += pv
        at = off + pw
    next
    if at < g.size then
        if len( mtys ) > 0 then mtys += ", " : mvals += ", "
        mtys += "[" & str( g.size - at ) & " x i8]"
        mvals += "[" & str( g.size - at ) & " x i8] " & CString( mid( img, at + 1, g.size - at ) )
    end if
    dim as string mdbg = ""
    if (e.dbg <> 0) andalso (g.isExternal = false) then
        mdbg = DbgGlobal( *e.dbg, g.sym, e.names->Spelling( g.name ), g.isInternal )
    end if
    e.outp += nm & " = " & VarLinkage( e, g ) & "global <{ " & mtys & " }> <{ " & mvals & _
              " }>, align " & str( AlignOf( e, MT_AGG, g.size ) ) & mdbg & chr( 10 )
end sub

'' A DIM SHARED VARIABLE. The initialiser is part of the DEFINITION and not a store
'' executed in main -- 'static int32 H$ = 5;' is what fbc writes -- so it appears here
'' or nowhere.
sub EmitVarGlobal _
    ( byref e as EmitCtx, byref g as MirGlobal, byref nm as string )

    dim as MirType vt = cast( MirType, g.ty )
    dim as string ty = LlvmType( vt, g.size )
    dim as string init_ = "zeroinitializer"

    '' A VARIABLE MAY CARRY A POINTER TABLE TOO, and only the vtable branch above
    '' knew how to write one. 'static as fntype fn = ( @subr_cb, @func_cb )' over a
    '' UDT of two procedure pointers reaches lowering as ptrKinds/ptrRefs -- the
    '' MIR dump prints '= [ SUBR_CB, FUNC_CB ]' -- and then came out here as
    '' 'zeroinitializer', because the byte-image branch below cannot hold a
    '' relocation and the single-relocation branch after it holds exactly one.
    ''
    '' So the record was all zeroes and 'fn.s( )' called a null pointer. Nothing
    '' said so: tests/mir/static-ptr-record checks the MIR, where the words are
    '' present, and stops there.
    ''
    '' A MIXED IMAGE -- addresses among data -- is a PACKED STRUCT of the image's byte
    '' runs with a 'ptr' at each relocation's offset: '<{ ptr @ga, [8 x i8] c"..." }>'.
    '' Packed, so nothing is padded that the image does not already pad.
    if g.ptrMixed andalso (g.ptrCount > 0) then
        EmitMixedGlobal_( e, g, nm )
        return
    end if

    '' ONLY WHEN THE WORDS ARE THE WHOLE OBJECT. A UDT with a pointer field and an
    '' integer one is not a table, and writing it as '[n x ptr]' would shorten it.
    if g.ptrCount > 0 then
        dim as long pw = e.tgt->layout.pointerBits \ 8
        if (g.ptrCount * pw) = g.size then
            dim as string tbody
            for i as long = 0 to g.ptrCount - 1
                if i > 0 then tbody += ", "
                dim as long k = e.m->ptrKinds[g.ptrFirst + i]
                dim as ulong ref = e.m->ptrRefs[g.ptrFirst + i]
                select case k
                case 0
                    tbody += "ptr null"
                case 1
                    if cast( long, ref ) >= e.m->globals.Count then
                        Ice( e, "a pointer word naming a global that does not exist" )
                        return
                    end if
                    tbody += "ptr " & GlobalName( e, e.m->globals[cast( long, ref )].name )
                case 2
                    tbody += "ptr @""" & e.names->Spelling( cast( Tko.InternId, ref ) ) & """"
                case else
                    Ice( e, "a pointer word of an unknown kind" )
                    return
                end select
            next
            e.outp += nm & " = " & VarLinkage( e, g ) & "global [" & str( g.ptrCount ) & _
                      " x ptr] [" & tbody & "], align " & str( pw ) & chr( 10 )
            return
        end if
    end if

    if vt <> MT_AGG then
        if g.hasInit then
            select case vt
            case MT_F32 : init_ = LlvmFloatConst( g.initFlt, true )
            case MT_F64 : init_ = LlvmFloatConst( g.initFlt, false )
            case else   : init_ = str( g.initInt )
            end select
        else
            init_ = "0"
            if vt = MT_PTR then init_ = "null"
            if (vt = MT_F32) orelse (vt = MT_F64) then init_ = "0.0"
        end if
        '' An UNINITIALISED pointer global is still 'null' rather than '0': LLVM will
        '' not take an integer for a pointer initialiser.
        if (vt = MT_PTR) andalso g.hasInit then
            if g.initInt = 0 then init_ = "null"
            '' ...AND A NONZERO ADDRESS IS A CONSTANT EXPRESSION, 'inttoptr': 'dim shared pany as any
            '' ptr = cptr( any ptr, 15 )' -- fbc writes 'static void* PANY$ = (void*)15ull;'
            '' (dim/global-init.bas). 'ptr 15' went to clang and it refused the module.
            if g.initInt <> 0 then init_ = "inttoptr (i64 " & str( g.initInt ) & " to ptr)"
        end if
    elseif len( g.initBytes ) > 0 then
        '' AN AGGREGATE'S INITIAL VALUE IS THE BYTE IMAGE OF ITS STORAGE, which is what
        '' a field-by-field initialiser with its offsets already is. It is exactly
        '' 'size' bytes and gets no terminator: this is an object, not a literal.
        dim as string img = g.initBytes
        if len( img ) > g.size then img = left( img, g.size )
        while len( img ) < g.size
            img += chr( 0 )
        wend
        init_ = CString( img )
    end if

    '' AN ADDRESS AS AN INITIAL VALUE IS A RELOCATION, not a number: 'static px as UDT
    '' ptr = @x' is neither of the two branches above -- one holds a constant and the
    '' other a byte image, and the address of another global is neither.
    if g.initReloc >= 0 then
        if g.initReloc >= e.m->globals.Count then
            Ice( e, "a relocation naming a global that does not exist" )
            return
        end if
        dim as string baseSym = GlobalName( e, e.m->globals[g.initReloc].name )
        if g.initRelocOff <> 0 then
            init_ = "getelementptr (i8, ptr " & baseSym & ", i64 " & _
                    str( g.initRelocOff ) & ")"
        else
            init_ = baseSym
        end if
    elseif g.initRelocFn <> 0 then
        init_ = "@""" & e.names->Spelling( g.initRelocFn ) & """"
    end if

    '' AN ADDRESS IN AN INTEGER SLOT IS A ptrtoint. 'static f as uinteger =
    '' cptr( uinteger, @s )' is an address written into an INTEGER global, and a bare
    '' symbol there is 'global variable reference must have pointer type' -- LLVM
    '' will not narrow a relocation implicitly. It is a constant expression, which
    '' is what a static initialiser has to be.
    dim as boolean isReloc = (g.initReloc >= 0)
    if isReloc = false then isReloc = (g.initRelocFn <> 0)
    if isReloc andalso (vt <> MT_PTR) andalso (vt <> MT_AGG) then
        init_ = "ptrtoint (ptr " & init_ & " to " & LlvmType( vt ) & ")"
    end if

    dim as string gdbg = ""
    if (e.dbg <> 0) andalso (g.isExternal = false) then gdbg = DbgGlobal( *e.dbg, g.sym, e.names->Spelling( g.name ), g.isInternal )
    e.outp += nm & " = " & VarLinkage( e, g ) & "global " & ty & " " & init_ & _
              ", align " & str( AlignOf( e, vt, g.size ) ) & gdbg & chr( 10 )
end sub
