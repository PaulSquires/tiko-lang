'' lowerinitalign.bas -- AlignInitValues_: the leaf each initialiser value starts at.
'' #included by lowerudtlit.bas, inside its namespace: it uses FlattenUdtFields_ and that
'' unit's other private helpers.

'' THE LEAF EACH VALUE STARTS AT, found by walking the values against the FIELDS rather
'' than flattening both and pairing them by position. Measured on fbc-modern:
''
''     dim as foo a = ( 1, { 2 }, { 5, 6 } )     f1 = 2 0 0, f3 = 5 6
''     dim as Q   q = ( ( 1 ), 3 )               p = ( 1, 0 ), z = 3
''
'' -- a NESTED list fills its own field and pads it, and the next value goes to the next
'' field. Pairing flattened values by position wrote f1 = 2 5 6, f3 = 0 0 and p = ( 1, 3 ),
'' z = 0, silently. A value WITHOUT brackets still flows on into a UDT field's leaves,
'' which fbc also accepts ('type<Outer>( 1, 2, 3 )'). Each field's leaves are read off
'' FlattenUdtFields_'s own offsets, so the two cannot disagree. Any shape this does not
'' model answers false and the caller pairs by position as before.
declare function AlignUdt_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval leaf0 as long, byval lst as Tko.NodeId, _
      byref ci as long, byref vNode as FB.Array( of ulong ), byref vStart as FB.Array( of ulong ), _
      byval depth as long ) as boolean

private function IsBracketed_( byref c as Ctx, byval v as Tko.NodeId ) as boolean
    select case c.ast->Kind( v )
    case Tko.N_TUPLE, Tko.N_PAREN, Tko.N_INITIALIZER : return true
    end select
    return false
end function

private function ListCount_( byref c as Ctx, byval lst as Tko.NodeId ) as long
    return c.ast->lists[cast( long, c.ast->nodes[cast( long, lst )].data )].count
end function

private function ListAt_( byref c as Ctx, byval lst as Tko.NodeId, byval i as long ) as Tko.NodeId
    return cast( Tko.NodeId, c.ast->children[c.ast->lists[cast( long, c.ast->nodes[cast( long, lst )].data )].first + i] )
end function

'' ONE UDT-TYPED SLOT -- a field or an element -- at leaf 'start', from list position ci.
private function AlignUdtSlot_ _
    ( byref c as Ctx, byval ut as Tko.TypeId, byval start as long, byval lst as Tko.NodeId, _
      byref ci as long, byref vNode as FB.Array( of ulong ), byref vStart as FB.Array( of ulong ), _
      byval depth as long ) as boolean

    dim as Tko.NodeId v = ListAt_( c, lst, ci )
    if IsBracketed_( c, v ) then
        ci += 1
        dim as long sub_ = 0
        if AlignUdt_( c, ut, start, v, sub_, vNode, vStart, depth + 1 ) = false then return false
        return (sub_ >= ListCount_( c, v ))
    end if
    dim as Tko.TypeId vt = c.info->TypeOf_( v )
    if vt <> Tko.TYPE_NONE then
        if c.types->Kind( c.types->Unqualify( vt ) ) = Tko.TK_UDT then
            vNode.Push( cast( ulong, v ) ) : vStart.Push( cast( ulong, start ) )
            ci += 1
            return true
        end if
    end if
    return AlignUdt_( c, ut, start, lst, ci, vNode, vStart, depth + 1 )   '' unbracketed: flows on
end function

private function AlignElem_ _
    ( byref c as Ctx, byval et as Tko.TypeId, byval start as long, byval lst as Tko.NodeId, _
      byref ci as long, byref vNode as FB.Array( of ulong ), byref vStart as FB.Array( of ulong ), _
      byval depth as long ) as boolean

    if (c.types->Kind( et ) = Tko.TK_UDT) andalso (IsStringType( c, et ) = false) then
        return AlignUdtSlot_( c, et, start, lst, ci, vNode, vStart, depth )
    end if
    dim as Tko.NodeId v = ListAt_( c, lst, ci )
    select case c.ast->Kind( v )
    case Tko.N_TUPLE, Tko.N_INITIALIZER : return false
    end select
    vNode.Push( cast( ulong, v ) ) : vStart.Push( cast( ulong, start ) )
    ci += 1
    return true
end function

function AlignUdt_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval leaf0 as long, byval lst as Tko.NodeId, _
      byref ci as long, byref vNode as FB.Array( of ulong ), byref vStart as FB.Array( of ulong ), _
      byval depth as long ) as boolean

    if depth > 8 then return false
    dim as long ui = c.udts->Find( t )
    if ui < 0 then return false
    dim as FB.Array( of ulong ) lo, lty, lft
    if FlattenUdtFields_( c, t, 0, lo, lty, 0, lft ) = false then return false
    dim as long n = ListCount_( c, lst )
    dim as long li = 0
    '' A UNION, or any member overlapping an earlier one, is not modelled.
    if IsUnionType_( c, t ) then return false
    dim as long prevEnd = 0
    for i as long = 0 to c.udts->udts[ui].count - 1
        dim as Tko.UdtField ptr fld = @c.udts->fields[c.udts->udts[ui].first + i]
        dim as Tko.TypeId ft = c.types->Unqualify( fld->type_ )
        dim as long fsz = SizeOfType( c, ft )
        if (fsz > 0) andalso (fld->offset < prevEnd) then return false
        if fld->offset + fsz > prevEnd then prevEnd = fld->offset + fsz
        dim as long a = li, b = li
        if (a < lo.Count) andalso (cast( long, lo[a] ) < fld->offset) then return false
        while (b < lo.Count) andalso (cast( long, lo[b] ) < fld->offset + fsz)
            b += 1
        wend
        li = b
        if b = a then continue for
        if ci >= n then return true   '' the rest takes its defaults
        dim as longint fsn
        dim as long fsk = StrSwapKind_( c, ft, fsn )
        if (c.types->Kind( ft ) = Tko.TK_UDT) andalso (IsStringType( c, ft ) = false) then
            if AlignUdtSlot_( c, ft, leaf0 + a, lst, ci, vNode, vStart, depth ) = false then return false
        elseif (c.types->Kind( ft ) = Tko.TK_ARRAY) andalso (c.types->IsDynArray( ft ) = false) andalso _
               (fsk <> 1) andalso (fsk <> 2) andalso (fsk <> 4) then
            if fsk = 3 then return false   '' fbc refuses a 'string * N' field in a list
            dim as Tko.TypeId et = c.types->Unqualify( c.types->Inner( ft ) )
            dim as long ne = c.types->ElemCount( ft )
            if (ne <= 0) orelse (((b - a) mod ne) <> 0) then return false
            dim as long pe = (b - a) \ ne
            dim as Tko.NodeId v = ListAt_( c, lst, ci )
            if c.ast->Kind( v ) = Tko.N_INITIALIZER then
                ci += 1
                dim as long c2 = 0
                for j as long = 0 to ne - 1
                    if c2 >= ListCount_( c, v ) then exit for
                    if AlignElem_( c, et, leaf0 + a + j * pe, v, c2, vNode, vStart, depth + 1 ) = false then return false
                next
                if c2 < ListCount_( c, v ) then return false
            else
                for j as long = 0 to ne - 1
                    if ci >= n then exit for
                    if AlignElem_( c, et, leaf0 + a + j * pe, lst, ci, vNode, vStart, depth + 1 ) = false then return false
                next
            end if
        else
            dim as Tko.NodeId v = ListAt_( c, lst, ci )
            select case c.ast->Kind( v )
            case Tko.N_TUPLE, Tko.N_INITIALIZER : return false
            end select
            vNode.Push( cast( ulong, v ) ) : vStart.Push( cast( ulong, leaf0 + a ) )
            ci += 1
        end if
    next
    return true
end function

'' The whole initialiser: true when every value found its field and none was left over.
function AlignInitValues_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval init as Tko.NodeId, _
      byref vNode as FB.Array( of ulong ), byref vStart as FB.Array( of ulong ) ) as boolean

    if t = Tko.TYPE_NONE then return false
    t = c.types->Unqualify( t )
    '' ...OR A STATIC ARRAY OF THEM, one element's leaves after another (FoldAggInit_):
    '' '{ ( 1 ), ( 2 ) }' over a two-field UDT is ( 1, 0 ), ( 2, 0 ), not ( 1, 2 ), ( 0, 0 ).
    if c.types->Kind( t ) = Tko.TK_ARRAY then
        if c.types->IsDynArray( t ) orelse (c.types->types[cast( long, t )].dims <> 1) then return false
        if c.ast->Kind( init ) <> Tko.N_INITIALIZER then return false
        dim as Tko.TypeId aet = c.types->Unqualify( c.types->Inner( t ) )
        if (c.types->Kind( aet ) <> Tko.TK_UDT) orelse IsStringType( c, aet ) then return false
        dim as FB.Array( of ulong ) po, pty, pft
        if FlattenUdtFields_( c, aet, 0, po, pty, 0, pft ) = false then return false
        dim as long ane = c.types->ElemCount( t )
        dim as long aci = 0
        for j as long = 0 to ane - 1
            if aci >= ListCount_( c, init ) then exit for
            if AlignElem_( c, aet, j * po.Count, init, aci, vNode, vStart, 1 ) = false then return false
        next
        if aci < ListCount_( c, init ) then return false
        return (vNode.Count > 0)
    end if
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    select case c.ast->Kind( init )
    case Tko.N_TUPLE, Tko.N_PAREN
    case else
        return false
    end select
    dim as long ci = 0
    if AlignUdt_( c, t, 0, init, ci, vNode, vStart, 0 ) = false then return false
    if ci < ListCount_( c, init ) then return false
    return (vNode.Count > 0)
end function
