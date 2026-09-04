'' verify.bas -- the structural rules MIR must satisfy.
''
'' The rules implemented here are the ones this slice of phase 6 can check. The two
'' that matter most and are NOT here yet are dominance ("every value is defined before
'' use, in a dominating block") and cleanup-edge coverage ("every scope-exit edge
'' passes through its cleanup block") -- the second is the rule docs/plan/09 calls the
'' one that pays for the whole verifier, and it cannot be checked before the cleanup
'' model exists. Claiming a verifier is complete when it is not would be worse than
'' having none, so the gaps are listed rather than glossed.

#include once "mir/verify.bi"

namespace Tko.Mir

private sub Fail _
    ( byref r as VerifyResult, byref where_ as string, byref why as string )

    r.failures += 1
    r.report += "  " & where_ & ": " & why & chr( 10 )
end sub

function Verify _
    ( byref m as MirModule, byref names as Tko.Interner, _
      byval strict as boolean = false ) as VerifyResult

    dim as VerifyResult r

    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isDefinition = false then continue for
        dim as string fn = names.Spelling( f->name )

        if f->blocks.Count = 0 then
            Fail( r, fn, "a definition with no blocks" )
            continue for
        end if

        '' Which temps have been defined. Not dominance -- that needs a CFG walk --
        '' but it does catch a use of a temp that was never produced at all.
        dim as FB.Array( of ubyte ) defined_
        for i as long = 0 to f->nextTemp
            defined_.Push( 0 )
        next

        '' ...AND WHICH SLOTS HAVE STORAGE. A slot is named by MV_LOCAL and reserved by
        '' M_ALLOCA, and nothing checked that the second ever happened. The ABI pass
        '' pushed its new allocas into the entry block while the entry block was itself
        '' being rebuilt, the rebuild dropped them, and every rule here still passed --
        '' clang was what noticed, with "use of undefined value '%s10'".
        ''
        '' Collected in a first sweep because an alloca may follow a use in program
        '' ORDER: the entry block is where they all live, but a later block's use is
        '' seen before the entry block is finished being read only if the walk is
        '' single-pass. Two passes is simpler than reasoning about that.
        dim as FB.Array( of ubyte ) allocated_
        for i as long = 0 to f->locals.Count
            allocated_.Push( 0 )
        next
        for bi as long = 0 to f->blocks.Count - 1
            for ii as long = 0 to f->blocks[bi].insts.Count - 1
                dim as MirInst ptr ai = @f->blocks[bi].insts[ii]
                if cast( MirOp, ai->op ) <> M_ALLOCA then continue for
                dim as long sl = cast( long, ai->imm )
                if (sl >= 0) andalso (sl < allocated_.Count) then allocated_[sl] = 1
            next
        next

        for bi as long = 0 to f->blocks.Count - 1
            dim as MirBlock ptr b = @f->blocks[bi]
            dim as string bn = fn & ":" & str( bi )

            '' Rule 1: every block ends in exactly one terminator.
            if b->term = cast( ubyte, MTERM_NONE ) then
                Fail( r, bn, "block has no terminator" )
            end if

            '' Rule 2: every referenced block exists and belongs to this function.
            dim as MirTermKind tk = cast( MirTermKind, b->term )
            if (tk = MTERM_BR) orelse (tk = MTERM_CONDBR) then
                if (b->target < 0) orelse (b->target >= f->blocks.Count) then
                    Fail( r, bn, "branch target " & str( b->target ) & " does not exist" )
                end if
            end if
            if tk = MTERM_CONDBR then
                if (b->target2 < 0) orelse (b->target2 >= f->blocks.Count) then
                    Fail( r, bn, "false target " & str( b->target2 ) & " does not exist" )
                end if
            end if

            for i as long = 0 to b->insts.Count - 1
                dim as MirInst ptr ins = @b->insts[i]
                dim as MirOp op = cast( MirOp, ins->op )
                dim as string iw = bn & ":" & str( i ) & " " & OpName( op )

                '' Rule 6: alloca appears only in the entry block.
                if (op = M_ALLOCA) andalso (bi <> 0) then
                    Fail( r, iw, "alloca outside the entry block" )
                end if

                '' Rule 4, in the form available without a full signature table: an
                '' opcode that produces a value must have a result temp, and one that
                '' does not must not.
                '' A void call is the one result-producing opcode that legitimately
                '' has no result: there is no value to name.
                dim as boolean wantsResult = OpHasResult( op )
                if ins->ty = cast( ubyte, MT_VOID ) then wantsResult = false
                if wantsResult then
                    if ins->result = 0 then
                        Fail( r, iw, "result-producing opcode with no result temp" )
                    elseif cast( long, ins->result ) < defined_.Count then
                        if defined_[cast( long, ins->result )] <> 0 then
                            Fail( r, iw, "temp %" & str( ins->result ) & " defined twice" )
                        end if
                        defined_[cast( long, ins->result )] = 1
                    end if
                elseif ins->result <> 0 then
                    Fail( r, iw, "opcode with no result carries a result temp" )
                end if

                '' Rule 9c: a slot that is USED must have been ALLOCATED. See the
                '' sweep above for what this is for. A GLOBAL is storage in its own
                '' right and is not allocated by anything here.
                if ins->a.kind = cast( ubyte, MV_LOCAL ) then
                    dim as long sl = cast( long, ins->a.id )
                    if (sl >= 0) andalso (sl < allocated_.Count) then
                        if allocated_[sl] = 0 then
                            Fail( r, iw, "uses slot " & str( sl ) & _
                                  " which is never allocated" )
                        end if
                    end if
                end if
                if ins->b.kind = cast( ubyte, MV_LOCAL ) then
                    dim as long sl = cast( long, ins->b.id )
                    if (sl >= 0) andalso (sl < allocated_.Count) then
                        if allocated_[sl] = 0 then
                            Fail( r, iw, "uses slot " & str( sl ) & _
                                  " which is never allocated" )
                        end if
                    end if
                end if

                '' Operands that name a temp must name one that exists.
                dim as long n = OpArity( op )
                if n >= 1 then
                    if ins->a.kind = cast( ubyte, MV_TEMP ) then
                        if defined_[cast( long, ins->a.id )] = 0 then
                            Fail( r, iw, "uses %" & str( ins->a.id ) & " before it is defined" )
                        end if
                    end if
                end if
                if n >= 2 then
                    if ins->b.kind = cast( ubyte, MV_TEMP ) then
                        if defined_[cast( long, ins->b.id )] = 0 then
                            Fail( r, iw, "uses %" & str( ins->b.id ) & " before it is defined" )
                        end if
                    end if
                end if

                '' Rule 9b: a CALL passes exactly as many arguments as the callee
                '' declares. docs/plan/09 rule 5. It could not be checked while a
                '' function recorded only an arity and the arity of a declaration was
                '' whatever its first call site happened to push -- the two agreed by
                '' construction and the rule was vacuous. Now the signature comes from
                '' the DECLARATION and this is a real check.
                ''
                '' A VARIADIC callee is checked as a MINIMUM: the tail is what it is.
                if (op = M_CALL) orelse (op = M_CALL_RTL) then
                    dim as long ci = cast( long, ins->callee )
                    if (ci >= 0) andalso (ci < m.functions.Count) then
                        dim as MirFunction ptr cf = m.functions[ci]
                        if cf <> 0 then
                            dim as boolean bad = false
                            if cf->isVariadic then
                                bad = (ins->count < cf->paramCount)
                            else
                                bad = (ins->count <> cf->paramCount)
                            end if
                            if bad then
                                Fail( r, iw, "calls " & names.Spelling( cf->name ) & _
                                    " with " & str( ins->count ) & " arguments, " & _
                                    "which declares " & str( cf->paramCount ) )
                            end if
                        end if
                    end if
                end if

                '' Rule 10: a STORE's value must have the destination slot's type.
                ''
                '' MIR has no implicit conversions, so a mismatch is a WRONG STORE --
                '' 64 bits into a 32-bit slot, emitted and never complained about. One
                '' was found by accident when a member finally got a type and a 'trunc'
                '' appeared beside a store that had never had one; nothing in the
                '' verifier had objected to it, which is what this rule is for.
                ''
                '' A LOCAL or a GLOBAL destination, which are the two that write their
                '' slot's type down. A computed field address has none to compare
                '' against, and guessing would make the rule lie. MT_AGG is excluded on
                '' both sides: an aggregate is copied rather than loaded and stored
                '' whole, so its 'type' is not a width.
                if op = M_STORE then
                    dim as long slotTy = -1
                    if ins->a.kind = cast( ubyte, MV_LOCAL ) then
                        if (ins->a.id >= 0) andalso (ins->a.id < f->locals.Count) then
                            slotTy = cast( long, f->locals[ins->a.id].ty )
                        end if
                    elseif ins->a.kind = cast( ubyte, MV_GLOBAL ) then
                        if (ins->a.id >= 0) andalso (ins->a.id < m.globals.Count) then
                            if m.globals[ins->a.id].isVar then
                                slotTy = cast( long, m.globals[ins->a.id].ty )
                            end if
                        end if
                    end if
                    dim as long valTy = cast( long, ins->b.ty )
                    dim as boolean checkable = (slotTy >= 0) andalso _
                        (slotTy <> cast( long, MT_AGG )) andalso _
                        (valTy <> cast( long, MT_AGG )) andalso _
                        (valTy <> cast( long, MT_VOID ))
                    if checkable andalso (slotTy <> valTy) then
                        Fail( r, iw, "stores " & TypeName( cast( MirType, valTy ) ) & _
                                     " into a " & TypeName( cast( MirType, slotTy ) ) & _
                                     " slot" )
                    end if
                end if

                '' A void value can be produced but never consumed.
                if OpHasResult( op ) andalso (ins->ty = cast( ubyte, MT_VOID )) then
                    if (op <> M_CALL) andalso (op <> M_CALL_RTL) andalso _
                       (op <> M_CALL_IND) then
                        Fail( r, iw, "non-call opcode produces void" )
                    end if
                end if
            next
        next

        '' Rule 9: no block is unreachable from entry -- but only under STRICT.
        '' Reachability is a fixed point over the terminators, cheap here because a
        '' block has at most two successors.
        if strict = false then continue for
        dim as FB.Array( of ubyte ) seen
        for i as long = 0 to f->blocks.Count - 1
            seen.Push( 0 )
        next
        seen[0] = 1
        dim as boolean changed = true
        while changed
            changed = false
            for bi as long = 0 to f->blocks.Count - 1
                if seen[bi] = 0 then continue for
                dim as MirBlock ptr b = @f->blocks[bi]
                dim as MirTermKind tk = cast( MirTermKind, b->term )
                if (tk = MTERM_BR) orelse (tk = MTERM_CONDBR) then
                    if (b->target >= 0) andalso (b->target < f->blocks.Count) then
                        if seen[b->target] = 0 then
                            seen[b->target] = 1
                            changed = true
                        end if
                    end if
                end if
                if tk = MTERM_CONDBR then
                    if (b->target2 >= 0) andalso (b->target2 < f->blocks.Count) then
                        if seen[b->target2] = 0 then
                            seen[b->target2] = 1
                            changed = true
                        end if
                    end if
                end if
            next
        wend
        for bi as long = 0 to f->blocks.Count - 1
            if seen[bi] = 0 then
                Fail( r, fn & ":" & str( bi ), "block is unreachable from entry" )
            end if
        next
    next

    return r
end function

end namespace
