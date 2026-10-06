'' lowercastpick.bas -- WHICH 'operator cast' a lowered string term calls. Moved out of
'' lowersub.bas, which includes it; the choice itself is Check's StrCastPick (castpick.bas).

function UserCastToStr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
      byref raw as boolean ) as boolean

    raw = false
    dim as Tko.TypeId t = c.info->TypeOf_( id )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false

    dim as Tko.SymbolId cs = UdtMemberNamed_( c, t, "cast" )
    if cs = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( cs )
    if s = 0 then return false

    '' THE OVERLOAD THAT YIELDS A STRING. 'operator cast' can be declared several
    '' times over different targets -- as long, as string, as zstring -- and they hang
    '' off one symbol as a chain, so the first is not necessarily the right one.
    dim as Tko.SymbolId cur
    dim as Tko.SymbolId want = Tko.SYMBOL_NONE
    dim as boolean wantRaw = false
    for pass as long = 0 to 1
        cur = cs
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
            dim as Tko.TypeId rt = cse->type_
            if rt <> Tko.TYPE_NONE then
                dim as longint zn
                if IsStringType( c, rt ) then
                    want = cur
                    wantRaw = false
                    exit while
                elseif StrSwapKind_( c, rt, zn ) = 1 then
                    want = cur
                    wantRaw = true
                    exit while
                else
                    '' A BARE 'zstring' -- no length -- which is what a BYREF conversion
                    '' operator returns: 'operator cast( ) byref as zstring', and fbc's own
                    '' C says the result is a plain 'char*'. It is neither the TK_ARRAY a
                    '' 'zstring * N' variable is nor IsStringType, so both tests above miss
                    '' it, and byref makes it a POINTER to that -- which is why both
                    '' spellings are accepted here.
                    dim as Tko.TypeId inner = rt
                    if c.types->Kind( inner ) = Tko.TK_POINTER then
                        inner = c.types->Inner( inner )
                    end if
                    if inner <> Tko.TYPE_NONE then
                        if c.types->Kind( inner ) = Tko.TK_BUILTIN then
                            if c.types->BuiltinOf( inner ) = Tko.TY_ZSTRING then
                                want = cur
                                wantRaw = true
                                exit while
                            end if
                        end if
                    end if
                end if
            end if
            cur = cse->nextOverload
        wend
        if want <> Tko.SYMBOL_NONE then exit for
    next
    if want = Tko.SYMBOL_NONE then return false

    dim as MirValue self_
    if UdtSelfAddr_( c, id, self_ ) = false then return false
    dim as MirValue r = EmitMemberCall( c, want, self_, MT_PTR )
    if r.kind = cast( ubyte, MV_NONE ) then return false

    if wantRaw = false then
        outv = r
        return true
    end if

    raw = true
    outv = r
    return true
end function

'' WHETHER THE STRING 'operator cast' UserCastToStr_ PICKS RETURNS A USTRING (T39). Its
'' result is then a UTF-16 descriptor, and every consumer that keyed on the ITEM's type
'' -- a UDT, so "narrow" -- printed its bytes as narrow text: an 'operator cast( ) as
'' ustring' returning "(4, 6)" printed '(', NUL, '4', NUL, ',', NUL and stopped, where
'' assigning it to a ustring first gave "(4, 6)". The same overload, chosen the same way.
function UdtCastIsUStr_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur
    for pass as long = 0 to 1
        cur = UdtMemberNamed_( c, t, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
            dim as Tko.TypeId rt = cse->type_
            if rt <> Tko.TYPE_NONE then
                dim as longint zn
                if IsStringType( c, rt ) then return IsUStringType( c, rt )
                if StrSwapKind_( c, rt, zn ) = 1 then return false
            end if
            cur = cse->nextOverload
        wend
    next
    return false
end function

'' THE SAME QUESTION ON THE WIDE SIDE: the 'operator cast' that yields a WSTRING.
''
'' UserCastToStr_ answers for 'string' and 'zstring' only, and the wide half of the
'' rule was simply absent. Measured, fbc accepts
''
''     type B extends wstring
''         declare operator cast( ) byref as const wstring
''     end type
''     print cint( bv )        -- 123, through the cast
''
'' and tiko compared the OBJECT to zero instead: 'icmp ne [34 x i8] %t7, 0', which is
'' not an instruction, so the module was refused.
''
'' A BYREF WIDE RESULT IS ALREADY A 'uint16*', which is exactly what the wide VAL
'' entry points take -- there is no descriptor to borrow, and so no raw/temp
'' distinction of the kind the narrow path needs.
function UserCastToWstr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur
    for pass as long = 0 to 1
        cur = UdtMemberNamed_( c, t, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
            dim as Tko.TypeId rt = c.types->Unqualify( cse->type_ )
            '' Through a REFERENCE or a POINTER: 'byref as wstring' is either spelling
            '' by the time it reaches here, and both mean the same buffer.
            if c.types->Kind( rt ) = Tko.TK_REFERENCE then
                rt = c.types->Unqualify( c.types->Inner( rt ) )
            elseif c.types->Kind( rt ) = Tko.TK_POINTER then
                rt = c.types->Unqualify( c.types->Inner( rt ) )
            end if
            if rt <> Tko.TYPE_NONE then
                if c.types->Kind( rt ) = Tko.TK_BUILTIN then
                    if c.types->BuiltinOf( rt ) = Tko.TY_WSTRING then
                        dim as MirValue self_
                        if UdtSelfAddr_( c, id, self_ ) = false then return false
                        outv = EmitMemberCall( c, cur, self_, MT_PTR )
                        return (outv.kind <> cast( ubyte, MV_NONE ))
                    end if
                end if
            end if
            cur = cse->nextOverload
        wend
    next
    return false
end function

'' (Moved from lowerwstr.bas at its 1500-line cap.)
'' THE 'operator cast' OVERLOAD THAT YIELDS A WSTRING, or nothing. Split out because
'' the CONCATENATION and COMPARISON paths have to know whether a term is wide BEFORE
'' anything is emitted for it, and the only way to find out is this walk: 'operator
'' cast' may be declared several times over different targets, so the chain is walked
'' rather than its head taken.
function WideCastOverload_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( t ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur
    for pass as long = 0 to 1
        cur = UdtMemberNamed_( c, t, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
            dim as Tko.TypeId rt = cse->type_
            if rt <> Tko.TYPE_NONE then
                '' BYREF makes it a POINTER to the wstring, so both spellings count -- and a
                '' REFERENCE is the third, which 'byref as const wstring' resolves to. CONST
                '' is stripped with it: 'const wstring' is the same wstring.
                dim as Tko.TypeId inner = c.types->Unqualify( rt )
                if c.types->Kind( inner ) = Tko.TK_REFERENCE then
                    inner = c.types->Unqualify( c.types->Inner( inner ) )
                end if
                if c.types->Kind( inner ) = Tko.TK_POINTER then
                    inner = c.types->Unqualify( c.types->Inner( inner ) )
                end if
                if IsWideString_( c, inner ) then return cur
                if inner <> Tko.TYPE_NONE then
                    if c.types->Kind( inner ) = Tko.TK_BUILTIN then
                        if c.types->BuiltinOf( inner ) = Tko.TY_WSTRING then return cur
                    end if
                end if
            end if
            cur = cse->nextOverload
        wend
    next
    return Tko.SYMBOL_NONE
end function

'' WHETHER A UDT HAS A NARROW STRING CAST -- to string, zstring (byref or a pointer) or ustring. A
'' narrow context takes it over a wide one: measured, fbc's 'dim as string s = x' and 'ucase( x )'
'' over a type casting to string and to wstring call the STRING cast, in either declaration
'' order; tiko called the wstring one and transcoded it (TermIsWide_, lowerwstr.bas).
function HasNarrowStrCast_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur = UdtMemberNamed_( c, t, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = c.types->Unqualify( cs->type_ )
        if c.types->Kind( rt ) = Tko.TK_REFERENCE then rt = c.types->Unqualify( c.types->Inner( rt ) )
        if c.types->Kind( rt ) = Tko.TK_POINTER then rt = c.types->Unqualify( c.types->Inner( rt ) )
        if c.types->Kind( rt ) = Tko.TK_BUILTIN then
            select case c.types->BuiltinOf( rt )
            case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_USTRING : return true
            end select
        end if
        cur = cs->nextOverload
    wend
    return false
end function
