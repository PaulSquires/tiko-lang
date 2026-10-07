'' lowercastpick.bas -- WHICH 'operator cast' a lowered string term calls. Moved out of
'' lowersub.bas, which includes it; the choice itself is Check's StrCastPick (castpick.bas).

'' WHAT A UDT TERM IS IN A STRING CONTEXT, by fbc's own pick: the cast that scores best against
'' STRING (castpick.bas) -- which is the target print, '&', a string assignment and a string
'' argument ask with. 0 when the score decides nothing (no cast, a tie, or a pointer or number
'' winning -- Check's diagnostics), and the callers keep their own walk; else 1 narrow (string,
'' byref zstring), 2 ustring, 3 wide (byref wstring). SYM is the winner.
''
'' Measured differences from the walks it overrides, each an fbc-modern pick:
''     [byref as zstring, as string]       the STRING one, either order (walk: the first)
''     [as ustring, as string]             STRING          (walk: the first)
''     [as ustring, byref as zstring]      the ZSTRING one (walk: the first)
''     [as ustring, byref as wstring]      USTRING, a UTF-16 term -- StrTermFlavour_ said WIDE
function ScoredStrTerm_( byref c as Ctx, byval t as Tko.TypeId, byref sym as Tko.SymbolId ) as long
    sym = Tko.SYMBOL_NONE
    '' A BUILT-IN'S OVERLOAD PICK, when one is being lowered (castForce, IntrCastForce_): the cast
    '' fbc's overload resolution chose is the one called, whatever the string table would say.
    if c.castForce <> 0 then
        dim as Tko.SymbolId fcur = UdtMemberNamed_( c, c.types->Unqualify( t ), "cast" )
        while fcur <> Tko.SYMBOL_NONE
            if fcur = cast( Tko.SymbolId, c.castForce ) then
                sym = fcur
                select case Tko.Check.CastResultClass( *c.ast, *c.syms, *c.types, fcur )
                case Tko.Check.CR_USTRING : return 2
                case Tko.Check.CR_WCHAR, Tko.Check.CR_WCHARPTR : return 3
                end select
                return 1
            end if
            fcur = c.syms->SymbolAt( fcur )->nextOverload
        wend
    end if
    dim as long oc, cls
    dim as long tg = c.strCastTarget
    if tg = 0 then tg = Tko.Check.CT_STRING
    dim as Tko.SymbolId s = Tko.Check.StrCastPick( *c.ast, *c.syms, *c.types, *c.names, t, tg, oc, cls )
    if oc <> Tko.Check.CP_OK then return 0
    sym = s
    select case cls
    case Tko.Check.CR_USTRING : return 2
    case Tko.Check.CR_WCHAR   : return 3
    end select
    return 1
end function

'' IS A UDT TERM WIDE in a string context? The score's answer, else the old one: a wstring cast
'' and no narrow one.
function UdtTermWide_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    dim as Tko.SymbolId sym
    dim as long k = ScoredStrTerm_( c, t, sym )
    if k <> 0 then return (k = 3)
    if WideCastOverload_( c, t ) = Tko.SYMBOL_NONE then return false
    return (HasNarrowStrCast_( c, t ) = false)
end function

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

    '' FBC'S PICK FIRST (ScoredStrTerm_): a narrow or ustring winner is the cast; a wide one means
    '' this is not a narrow term at all. Only when the score decides nothing does the walk below.
    dim as Tko.SymbolId scored
    dim as long sk = ScoredStrTerm_( c, t, scored )
    if sk = 3 then return false
    if sk <> 0 then
        dim as MirValue sself
        if UdtSelfAddr_( c, id, sself ) = false then return false
        outv = EmitMemberCall( c, scored, sself, MT_PTR )
        if outv.kind = cast( ubyte, MV_NONE ) then return false
        dim as long scls = Tko.Check.CastResultClass( *c.ast, *c.syms, *c.types, scored )
        raw = (scls = Tko.Check.CR_CHAR) orelse (scls = Tko.Check.CR_CHARPTR)   '' a char* either way
        return true
    end if

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
    dim as Tko.SymbolId scored
    dim as long sk = ScoredStrTerm_( c, t, scored )     '' fbc's pick, as UserCastToStr_ takes it
    if sk <> 0 then return (sk = 2)
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

'' (Moved from lowerwstr.bas at its 1500-line cap.)
'' The 'operator cast' overload that yields a WSTRING, called on 'id'. Returns the
'' uint16* it gives back.
function UserCastToWide_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId want = WideCastOverload_( c, c.info->TypeOf_( id ) )
    if want = Tko.SYMBOL_NONE then return false
    '' ...AND FBC'S PICK OVER IT (ScoredStrTerm_): when a narrow or ustring cast outscores the
    '' wide one, that one is called and WIDENED -- measured, 'u & wstr( "x" )' over [as string,
    '' byref as wstring] is the string cast then fb_StrToWstr, in either declaration order. Asked
    '' only of a type WITH a wide cast: callers try this to choose a path, and a narrow-only type
    '' must keep answering no ('dim ru as wstring * 50 = mid( uu, 1 )' is fb_StrMid, then assign).
    dim as Tko.SymbolId scored
    dim as long sk = ScoredStrTerm_( c, c.info->TypeOf_( id ), scored )
    if (sk = 1) orelse (sk = 2) then return NarrowToWideTemp_( c, id, outv )
    if (sk = 3) andalso (scored <> Tko.SYMBOL_NONE) then want = scored   '' 'byref as wstring' or a 'wstring ptr' -- fbc's pick

    '' A PAREN-LESS CALL IS A CALL: LowerAddr on a bare procedure name is its CODE address,
    '' which 'AfxGetExePathName & "\x"' handed the cast as 'this' -- tracks died in wcslen.
    '' Called as MT_AGG, what the definition returns (MT_PTR made the ABI pass decline the
    '' function), then copied to a temporary for an address, as UdtSelfAddr_ does; the
    '' call's own result slot is the one registered for destruction.
    dim as MirValue self_, brv
    dim as Tko.Symbol ptr bs = 0
    dim as Tko.NodeKind ik = c.ast->Kind( id )
    if (ik = Tko.N_IDENT) orelse (ik = Tko.N_MEMBER) then bs = c.syms->SymbolAt( c.info->RefOf( id ) )
    if (bs <> 0) andalso (bs->kind = cast( ubyte, Tko.SYM_PROC )) then
        dim as long bsz = SizeOfType( c, c.types->Unqualify( c.info->TypeOf_( id ) ) )
        if bsz <= 0 then return false
        if LowerBareProcCall_( c, id, MT_AGG, brv ) = false then return false
        self_.kind = cast( ubyte, MV_LOCAL ) : self_.ty = cast( ubyte, MT_PTR )
        self_.id = NewTempLocal( c, MT_AGG, bsz )
        if cast( long, self_.id ) < 0 then return false
        StoreThrough( c, self_, brv )
    elseif UdtSelfAddr_( c, id, self_ ) = false then   '' an operator's result has no address
        return false
    end if
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    outv = EmitMemberCall( c, want, self_, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' THE TARGET A DESTINATION ASKS WITH. A ustring or wstring destination fed DIRECTLY by a UDT asks
'' fbc's cast pick with USTRING or WSTRING (castpick.bas) -- measured, 'dim as ustring s = u' over
'' [as string, byref as zstring] calls the zstring cast and 'w = u' over [as string, byref as
'' wstring] the wstring one -- while a UDT inside a concatenation asks with STRING whatever the
'' destination ('w = u & wstr( "x" )' calls the string cast). So only a direct term sets it, and
'' only the OUTERMOST destination decides: a chain lowered as 'assign the first term, then
'' concat-assign' re-enters here with that term as if it were direct, and must keep STRING.
private function DirectUdtSource_( byref c as Ctx, byval value as Tko.NodeId ) as boolean
    if value = Tko.NODE_NONE then return false
    dim as Tko.NodeId uv = Unparen_( c, value )
    '' A CONCATENATION IS NEVER ONE, even where Check leaves it typed as a UDT term's type.
    if c.ast->Kind( uv ) = Tko.N_BINARY then return false
    return IsUdtValue_( c, uv )
end function

function LowerStringAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval target as Tko.NodeId, _
      byval value as Tko.NodeId, byval dstFlavour as long ) as boolean
    dim as boolean isU = IsUStringType( c, c.info->TypeOf_( target ) )
    if target = Tko.NODE_NONE then isU = IsUStringDest_( c, dst )
    if dstFlavour >= 0 then isU = (dstFlavour = 1)
    dim as long saveT = c.strCastTarget
    if c.strCastTarget = 0 then c.strCastTarget = iif( isU andalso DirectUdtSource_( c, value ), Tko.Check.CT_USTRING, Tko.Check.CT_STRING )
    dim as boolean ok = LowerStringAssignTo_( c, dst, target, value, dstFlavour )
    c.strCastTarget = saveT
    return ok
end function

function LowerWideAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as long, _
      byval value as Tko.NodeId ) as boolean
    dim as long saveT = c.strCastTarget
    if c.strCastTarget = 0 then c.strCastTarget = iif( DirectUdtSource_( c, value ), Tko.Check.CT_WSTRING, Tko.Check.CT_STRING )
    dim as boolean ok = LowerWideAssignTo_( c, dst, n, value )
    c.strCastTarget = saveT
    return ok
end function

'' THE DECLARATION FORM -- 'dim as ustring s = u' -- which never reaches LowerStringAssignTo.
function LowerStringInit _
    ( byref c as Ctx, byval slot as long, byval target as Tko.NodeId, _
      byval value as Tko.NodeId ) as boolean
    dim as boolean isU = false
    if slot >= 0 then isU = IsUStringType( c, c.f->locals[slot].frontendType )
    if isU = false then isU = IsUStringType( c, c.info->TypeOf_( target ) )
    dim as long saveT = c.strCastTarget
    if c.strCastTarget = 0 then c.strCastTarget = iif( isU andalso DirectUdtSource_( c, value ), Tko.Check.CT_USTRING, Tko.Check.CT_STRING )
    dim as boolean ok = LowerStringInit_( c, slot, target, value )
    c.strCastTarget = saveT
    return ok
end function

'' LEFT, RIGHT AND THE VAL FAMILY: the cast fbc's OVERLOAD resolution reaches (Check.IntrStrOvlPick)
'' -- not the string table's -- is the one their operand calls: 'left( x, 1 )' over [as string,
'' byref as zstring] calls the zstring cast, 'val( x )' over [byref as wstring, as zstring ptr]
'' the wstring one. 0 for any other call, or when the pick is not clean (Check reported it).
function IntrCastForce_( byref c as Ctx, byval id as Tko.NodeId ) as long
    if c.ast->Kind( id ) <> Tko.N_CALL then return 0
    dim as Tko.ListPayload ptr cp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (cp->count < 1) orelse (cp->target = Tko.NODE_NONE) then return 0
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return 0
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )].name ) )
    if instr( " left right val valint vallng valuint valulng ", " " & nm & " " ) = 0 then return 0
    if CallsUserProcNamedLikeBuiltin( c, id ) then return 0
    dim as Tko.TypeId at = c.types->Unqualify( c.info->TypeOf_( cast( Tko.NodeId, c.ast->children[cp->first] ) ) )
    if c.types->Kind( at ) <> Tko.TK_UDT then return 0
    dim as long oc, prm
    dim as Tko.SymbolId s = Tko.Check.IntrStrOvlPick( *c.ast, *c.syms, *c.types, *c.names, at, (nm = "left") orelse (nm = "right"), oc, prm )
    if oc <> Tko.Check.CP_OK then return 0
    return cast( long, s )
end function

declare function LowerWideRvalueB_( byref c as Ctx, byval value as Tko.NodeId, byref outv as MirValue ) as boolean
declare function LowerUStrIntrinB_( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

'' The four entry points that lower these calls, each under the call's own force -- set for its
'' operand and restored on the way out, so it never reaches anything else.
function LowerStrRvalue( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    dim as long cfs = c.castForce : c.castForce = IntrCastForce_( c, id )
    function = LowerStrRvalueB_( c, id, outv ) : c.castForce = cfs
end function
function LowerStrNumCall_( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    dim as long cfs = c.castForce : c.castForce = IntrCastForce_( c, id )
    function = LowerStrNumCallB_( c, id, outv ) : c.castForce = cfs
end function
function LowerWideRvalue( byref c as Ctx, byval value as Tko.NodeId, byref outv as MirValue ) as boolean
    dim as long cfs = c.castForce : c.castForce = IntrCastForce_( c, value )
    function = LowerWideRvalueB_( c, value, outv ) : c.castForce = cfs
end function
function LowerUStrIntrin_( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    dim as long cfs = c.castForce : c.castForce = IntrCastForce_( c, id )
    function = LowerUStrIntrinB_( c, id, outv ) : c.castForce = cfs
end function
