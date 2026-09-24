'' lowerreport.bas -- what '--dump-ir' prints after the IR: the summary line and the
'' breakdown of every statement that did not lower. Moved out of driver.bas on 2026-09-24
'' for the 1500-line cap; nothing about it changed in the move.

#include once "driver/lowerreport.bi"

namespace Tko.Driver

sub PrintLowerReport _
    ( byref ctx as Tko.CompilerContext, byref lst as Tko.Mir.LowerStats, byref sum_ as string )

    print sum_
    '' The breakdown of what did NOT lower, printed only when there is
    '' something to say. One 'skipped' total invites guessing at the next
    '' thing to implement; this is read off instead.
    for i as long = 0 to lst.skippedKind.Count - 1
        if lst.skippedKind[i] = 0 then continue for
        print "  unlowered " & _
              Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
              str( lst.skippedKind[i] )
    next
    '' Declines part-way THROUGH a statement, by what they were inside.
    for i as long = 0 to lst.innerKind.Count - 1
        if lst.innerKind[i] = 0 then continue for
        print "  inside " & _
              Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
              str( lst.innerKind[i] )
    next
    for i as long = 0 to lst.skippedIntrOp.Count - 1
        print "  unlowered intrinsic " & _
              Tko.TokenKindName( cast( Tko.TokenKind, lst.skippedIntrOp[i] ) ) & _
              " " & str( lst.skippedIntrN[i] )
    next
    '' WHY the N_AMBIGUOUS statements declined -- the bucket that is 90% of
    '' the total, split into the halves that need different work.
    if lst.ambCallUnbound > 0 then
        print "  amb call-unbound " & str( lst.ambCallUnbound )
    end if
    if lst.ambCallNoCode > 0 then
        print "  amb call-nocode " & str( lst.ambCallNoCode )
    end if
    if lst.ambAssign > 0 then
        print "  amb assign " & str( lst.ambAssign )
        if lst.ambAssignUntyped > 0 then
            print "  amb-assign-untyped " & str( lst.ambAssignUntyped )
        end if
        for i as long = 0 to lst.ambAssignKinds.Count - 1
            if lst.ambAssignKinds[i] = 0 then continue for
            print "  amb-assign-kind " & str( i ) & " " & _
                  str( lst.ambAssignKinds[i] )
        next
        for i as long = 0 to lst.ambAssignValKinds.Count - 1
            if lst.ambAssignValKinds[i] = 0 then continue for
            print "  amb-assign-val " & _
                  Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
                  str( lst.ambAssignValKinds[i] )
        next
    end if
    if lst.ambResultNoSlot > 0 then
        print "  amb result-noslot " & str( lst.ambResultNoSlot )
        for i as long = 0 to lst.resultNoSlotKinds.Count - 1
            if lst.resultNoSlotKinds[i] = 0 then continue for
            print "  result-noslot-kind " & str( i ) & " " & _
                  str( lst.resultNoSlotKinds[i] )
        next
    end if
    if lst.varByref > 0 then print "  var byref " & str( lst.varByref )
    if lst.ambOther > 0 then print "  amb other " & str( lst.ambOther )
    '' Which LINE of the lowering gave up, which is the thing to go and read.
    for i as long = 0 to lst.skipSiteN.Count - 1
        print "  skip-site " & _
              ctx.names.Spelling( cast( Tko.InternId, lst.skipSiteFile[i] ) ) & _
              ":" & str( lst.skipSiteLine[i] ) & " " & str( lst.skipSiteN[i] )
    next
    for i as long = 0 to lst.ambUnboundShape.Count - 1
        if lst.ambUnboundShape[i] = 0 then continue for
        print "  amb-unbound-shape " & _
              Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
              str( lst.ambUnboundShape[i] )
    next
    for i as long = 0 to lst.ambOtherShape.Count - 1
        if lst.ambOtherShape[i] = 0 then continue for
        print "  amb-other-shape " & _
              Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
              str( lst.ambOtherShape[i] )
    next
    for i as long = 0 to lst.ambOtherClass.Count - 1
        if lst.ambOtherClass[i] = 0 then continue for
        print "  amb-other-class " & str( i ) & " " & str( lst.ambOtherClass[i] )
    next
    if lst.ambMemberBaseTyped > 0 then
        print "  amb member-base-typed " & str( lst.ambMemberBaseTyped )
    end if
    if lst.ambMemberBaseUntyped > 0 then
        print "  amb member-base-untyped " & str( lst.ambMemberBaseUntyped )
    end if
    for i as long = 0 to lst.ambMemberNames.Count - 1
        print "  amb-member-name " & _
              ctx.names.Spelling( cast( Tko.InternId, lst.ambMemberNames[i] ) )
    next
    for i as long = 0 to lst.ambUnboundNames.Count - 1
        print "  amb-unbound-name " & _
              ctx.names.Spelling( cast( Tko.InternId, lst.ambUnboundNames[i] ) )
    next
end sub

end namespace
