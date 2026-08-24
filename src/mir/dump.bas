'' dump.bas -- the textual form of MIR.
''
'' This is not a debugging convenience: docs/plan/13 makes emitted IR a GOLDEN TEST
'' surface, so the text is the thing being asserted on. It is written to be diffable --
'' one instruction per line, fixed order, no addresses or ids that shift when
'' unrelated code changes.

#include once "mir/dump.bi"

namespace Tko.Mir

private function ValStr _
    ( byref f as MirFunction, byref v as MirValue, byref names as Tko.Interner, _
      byval m as MirModule ptr = 0 ) as string

    select case v.kind
    case MV_TEMP        : return "%" & str( v.id )
    case MV_CONST_INT
        '' The id field is 32 bits, so a negative constant is read back SIGNED --
        '' otherwise the -1 that means "a var-length string descriptor" prints as
        '' 4294967295. Constants carried inline are limited to 32 bits by that field;
        '' a wider one needs a const instruction, which is what LowerExpr emits.
        return str( cast( longint, cast( long, v.id ) ) )
    case MV_LOCAL
        if cast( long, v.id ) < f.locals.Count then
            return "@" & names.Spelling( f.locals[cast( long, v.id )].name )
        end if
        return "@?" & str( v.id )
    case MV_PARAM       : return "$" & str( v.id )
    case MV_GLOBAL
        '' Named, not numbered: a golden diff should not churn because an unrelated
        '' literal was added ahead of this one in the table.
        if m <> 0 then
            if cast( long, v.id ) < m->globals.Count then
                return "@@" & names.Spelling( m->globals[cast( long, v.id )].name )
            end if
        end if
        return "@@?" & str( v.id )
    case MV_UNDEF       : return "undef"
    end select
    return "_"
end function

private function BlockName _
    ( byref f as MirFunction, byval idx as long, byref names as Tko.Interner ) as string

    if (idx < 0) orelse (idx >= f.blocks.Count) then return "bb?"
    dim as Tko.InternId l = f.blocks[idx].label
    if l = 0 then return "bb" & str( idx )
    return names.Spelling( l )
end function

private function InstStr _
    ( byref f as MirFunction, byref ins as MirInst, byref m as MirModule, _
      byref names as Tko.Interner ) as string

    dim as MirOp op = cast( MirOp, ins.op )
    dim as string s = "    "
    if OpHasResult( op ) andalso (ins.result <> 0) then
        s += "%" & str( ins.result ) & " = "
    end if
    s += OpName( op )

    select case op
    case M_CONST
        s += " " & TypeName( cast( MirType, ins.ty ) ) & " "
        if (ins.ty = cast( ubyte, MT_F32 )) orelse (ins.ty = cast( ubyte, MT_F64 )) then
            s += str( ins.fimm )
        else
            s += str( ins.imm )
        end if

    case M_FIELD_ADDR
        s += " " & ValStr( f, ins.a, names, @m ) & ", " & str( ins.imm )

    case M_ALLOCA
        dim as long li = cast( long, ins.imm )
        s += " " & TypeName( cast( MirType, ins.ty ) )
        if (li >= 0) andalso (li < f.locals.Count) then
            s += " " & names.Spelling( f.locals[li].name )
        end if

    case M_FUNC_ADDR
        '' The function's NAME, which is what makes the dump readable; the index it
        '' actually carries would say nothing.
        s += " " & TypeName( cast( MirType, ins.ty ) ) & " "
        if cast( long, ins.callee ) < m.functions.Count then
            s += names.Spelling( m.functions[cast( long, ins.callee )]->name )
        else
            s += "?" & str( ins.callee )
        end if

    case M_CALL, M_CALL_RTL, M_CALL_IND
        s += " " & TypeName( cast( MirType, ins.ty ) ) & " "
        if op = M_CALL_IND then
            '' The callee is a VALUE here, not a table index.
            s += ValStr( f, ins.a, names, @m )
        elseif cast( long, ins.callee ) < m.functions.Count then
            s += names.Spelling( m.functions[cast( long, ins.callee )]->name )
        else
            s += "?" & str( ins.callee )
        end if
        s += "("
        for i as long = 0 to ins.count - 1
            if i > 0 then s += ", "
            dim as MirValue av
            dim as long slot = (ins.first + i) * 2
            if (slot + 1) < m.argPool.Count then
                av.kind = cast( ubyte, m.argPool[slot] )
                av.id = m.argPool[slot + 1]
            end if
            s += ValStr( f, av, names, @m )
        next
        s += ")"

    case else
        dim as long n = OpArity( op )
        if n >= 1 then s += " " & ValStr( f, ins.a, names, @m )
        if n >= 2 then s += ", " & ValStr( f, ins.b, names, @m )
    end select
    return s
end function

function DumpModule _
    ( byref m as MirModule, byref names as Tko.Interner ) as string

    dim as string outp = ""
    '' Globals come first so a function body's diff is not disturbed by one being
    '' added.
    for i as long = 0 to m.globals.Count - 1
        if m.globals[i].isData then
            '' A DATA block prints as its entries. TYPE is the datum's CHARACTER
            '' LENGTH, not a datatype, and -1 marks the terminator -- whose NODE is
            '' the next block, or nothing.
            outp += "global data " & names.Spelling( m.globals[i].name ) & " ["
            for k as long = 0 to m.globals[i].dataCount - 1
                dim as long e = m.globals[i].dataFirst + k
                if k > 0 then outp += ","
                outp += " " & m.dataTypes[e] & " -> "
                if m.dataRefs[e] < 0 then
                    outp += "null"
                else
                    outp += names.Spelling( m.globals[m.dataRefs[e]].name )
                end if
            next
            outp += " ]" & chr( 10 )
        elseif m.globals[i].isPtrTable then
            '' A vtable or an RTTI record: a run of pointer-sized words. '0' is a null
            '' word, '@name' the address of another global, and a bare name a
            '' FUNCTION's address -- which may be declared in another module, so it is
            '' named rather than indexed.
            dim as string pk = "global ptrs "
            if m.globals[i].isExternal then pk = "extern ptrs "
            outp += pk & names.Spelling( m.globals[i].name ) & " ["
            for k as long = 0 to m.globals[i].ptrCount - 1
                dim as long e = m.globals[i].ptrFirst + k
                if k > 0 then outp += ","
                select case m.ptrKinds[e]
                case 0 : outp += " 0"
                case 1 : outp += " @" & names.Spelling( _
                             m.globals[cast( long, m.ptrRefs[e] )].name )
                case else : outp += " " & names.Spelling( cast( Tko.InternId, m.ptrRefs[e] ) )
                end select
            next
            outp += " ]" & chr( 10 )
        elseif m.globals[i].isString then
            '' A wide literal prints its SOURCE text with an L prefix, the way the
            '' source spells it. Printing the widened bytes would put embedded NULs
            '' in the dump.
            dim as string pfx = "global str "
            if m.globals[i].isWide then pfx = "global wstr "
            outp += pfx & names.Spelling( m.globals[i].name ) & " " & _
                    chr( 34 ) & m.globals[i].bytes & chr( 34 ) & chr( 10 )
        elseif m.globals[i].isVar then
            '' A DIM SHARED variable. The initialiser is part of the definition, the
            '' way fbc emits 'static int32 H$ = 5;', so it is printed here and not as
            '' a store somewhere.
            outp += "global var " & TypeName( cast( MirType, m.globals[i].ty ) ) & _
                    " " & names.Spelling( m.globals[i].name )
            if m.globals[i].ty = cast( ubyte, MT_AGG ) then
                outp += " size " & str( m.globals[i].size )
            end if
            if m.globals[i].hasInit then
                '' A FLOAT initialiser prints as a float: printing initInt for one
                '' would show 0 beside a global that has a value. An AGGREGATE prints
                '' its bytes in hex, which is what it is.
                if len( m.globals[i].initBytes ) > 0 then
                    outp += " = bytes"
                    for bi as long = 0 to len( m.globals[i].initBytes ) - 1
                        outp += " " & hex( asc( mid( m.globals[i].initBytes, bi + 1, 1 ) ), 2 )
                    next
                elseif (m.globals[i].ty = cast( ubyte, MT_F32 )) orelse _
                       (m.globals[i].ty = cast( ubyte, MT_F64 )) then
                    '' A NON-FINITE VALUE PRINTS ITS BITS. 'str( )' renders every NaN
                    '' as 'nan' whatever its sign, and the sign is exactly what a test
                    '' comparing a bit pattern is looking at -- numbers/infnan is that
                    '' test and its own comment says so. INF too, for the same reason:
                    '' the two of them are the values this dump has to be able to tell
                    '' apart.
                    dim as double fv = m.globals[i].initFlt
                    if (fv <> fv) orelse (fv > 1.7976931348623157e308) orelse _
                       (fv < -1.7976931348623157e308) then
                        '' IN THE GLOBAL'S OWN WIDTH: an f32 holds a float, and
                        '' printing the double's 64 bits beside it would name a value
                        '' the global cannot hold.
                        if m.globals[i].ty = cast( ubyte, MT_F32 ) then
                            dim as single sv = cast( single, fv )
                            dim as ulong sb = *cptr( ulong ptr, @sv )
                            outp += " = 0x" & hex( sb, 8 )
                        else
                            dim as ulongint bits_ = *cptr( ulongint ptr, @fv )
                            outp += " = 0x" & hex( bits_, 16 )
                        end if
                    else
                        outp += " = " & str( fv )
                    end if
                else
                    outp += " = " & str( m.globals[i].initInt )
                end if
            end if
            outp += chr( 10 )
        end if
    next
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for

        if f->isModuleCtor then outp += "attribute constructor" & chr( 10 )
        if f->isModuleDtor then outp += "attribute destructor" & chr( 10 )
        outp += iif( f->isDefinition, "func ", "declare " )
        outp += TypeName( cast( MirType, f->retTy ) ) & " " & _
                names.Spelling( f->name ) & "("
        for i as long = 0 to f->paramCount - 1
            if i > 0 then outp += ", "
            outp += "$" & str( i )
        next
        outp += ")"
        if f->isDefinition = false then
            outp += chr( 10 )
            continue for
        end if
        outp += " {" & chr( 10 )

        '' Locals are listed before the blocks so a diff of the body is not disturbed
        '' by a slot being added.
        for i as long = 0 to f->locals.Count - 1
            outp += "  local " & TypeName( cast( MirType, f->locals[i].ty ) ) & " " & _
                    names.Spelling( f->locals[i].name )
            if f->locals[i].ty = cast( ubyte, MT_AGG ) then
                outp += " size " & str( f->locals[i].size )
            end if
            outp += chr( 10 )
        next

        for bi as long = 0 to f->blocks.Count - 1
            dim as MirBlock ptr b = @f->blocks[bi]
            outp += "  " & BlockName( *f, bi, names ) & ":" & chr( 10 )
            for i as long = 0 to b->insts.Count - 1
                outp += InstStr( *f, b->insts[i], m, names ) & chr( 10 )
            next
            select case cast( MirTermKind, b->term )
            case MTERM_RET
                if b->cond.kind = cast( ubyte, MV_NONE ) then
                    outp += "    ret" & chr( 10 )
                else
                    outp += "    ret " & ValStr( *f, b->cond, names, @m ) & chr( 10 )
                end if
            case MTERM_BR
                outp += "    br " & BlockName( *f, b->target, names ) & chr( 10 )
            case MTERM_CONDBR
                outp += "    condbr " & ValStr( *f, b->cond, names, @m ) & ", " & _
                        BlockName( *f, b->target, names ) & ", " & _
                        BlockName( *f, b->target2, names ) & chr( 10 )
            case MTERM_UNREACHABLE
                outp += "    unreachable" & chr( 10 )
            case else
                '' Printed rather than hidden: a block with no terminator is exactly
                '' what the verifier exists to catch, and the dump should show it.
                outp += "    <NO TERMINATOR>" & chr( 10 )
            end select
        next
        outp += "}" & chr( 10 )
    next
    return outp
end function

end namespace
