'' strcastcheck.bas -- A UDT IN A STRING CONTEXT WHOSE BEST CAST REACHES NO STRING. #included from
'' latesweeps2.bas, in its namespace and over its Ctx.
''
'' The pick is fbc's (castpick.bas): every 'operator cast' scored against the context's target,
'' the best taken. When the best is a POINTER or a NUMBER the conversion does not exist -- a
'' 'zstring ptr' cast is not text to fbc -- and a tie is ambiguous. Measured on fbc-modern over
'' the P-C matrix (tka-probes/phase4/pc): print is error 24, an initialiser 24, an assignment
'' 181, '&' 20, a tie 98. tiko converted the pointer as if it were text.

private function StrCtxFit_( byref c as Ctx, byval t as TypeId, byval target as long ) as long
    return Tko.Check.UdtStrCastFit( *c.ast, *c.syms, *c.types, *c.names, t, target )
end function

'' PRINT of a UDT that prints through a cast (PrintsViaCast_ -- Unprintable_ reports the rest).
sub CheckPrintStrCast_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_PRINT then return
    if sp->extra <> 0 then return   '' PRINT USING has its own grammar
    for i as long = 0 to sp->count - 1
        dim as NodeId it = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = N_PRINT_SEP then
            if c.ast->stmts[cast( long, c.ast->nodes[cast( long, it )].data )].op = cast( ushort, KW_USING ) then return
            continue for
        end if
        dim as TypeId u = ValueType_( c, c.info->TypeOf_( it ) )
        if (u = TYPE_NONE) orelse (c.types->Kind( u ) <> TK_UDT) then continue for
        if PrintsViaCast_( c, u ) = false then continue for
        select case StrCtxFit_( c, u, Tko.Check.CT_STRING )
        case 1
            c.diags->Report( TKO0871, PointRange( c.ast->Loc( it ) ), c.types->Name( u ), "print" )
            return
        case 2
            c.diags->Report( TKO0660, PointRange( c.ast->Loc( it ) ), "operator cast" )
            return
        end select
    next
end sub

'' A UDT INTO A STRING DESTINATION -- JudgeConversion_'s question for 'string' and 'ustring'.
'' True when it reported.
function JudgeStrCast_ _
    ( byref c as Ctx, byval at as NodeId, byval udt as TypeId, byval dst as TypeId ) as boolean

    dim as long target = 0
    if c.types->Kind( dst ) = TK_BUILTIN then
        select case c.types->BuiltinOf( dst )
        case TY_STRING  : target = Tko.Check.CT_STRING
        case TY_USTRING : target = Tko.Check.CT_USTRING
        end select
    end if
    '' NOT 'wstring * N': fbc is not consistent there -- over casts to long and double the
    '' initialiser compiles (and is dropped), over long alone it is 24 -- so it keeps its old rule
    '' (tests/diagnostics/udt-numcast-string).
    if target = 0 then return false
    select case StrCtxFit_( c, udt, target )
    case 1
        c.diags->Report( TKO0738, PointRange( c.ast->Loc( at ) ) )
        return true
    case 2
        c.diags->Report( TKO0660, PointRange( c.ast->Loc( at ) ), "operator cast" )
        return true
    end select
    return false
end function
