'' lowermodinit.bas -- EmitModuleInit_: the module initialiser and finaliser.
'' Split out of lowerimpl.bas on 2026-09-10 for the 1500-line cap; nothing about the
'' code changed in the move.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' THE MODULE INITIALISER AND FINALISER.
''
'' fbc emits '_GLOBAL__I' and '_GLOBAL__D' carrying GCC's constructor and destructor
'' attributes, runs the globals in DECLARATION order in the first and in EXACT REVERSE
'' in the second -- measured, including the reversal within an array.
''
'' Without them 'dim shared as T g' over a type holding a string left the descriptor
'' uninitialised for the whole program, and the first assignment through it freed
'' whatever was in the image at that address.
sub EmitModuleInit_( byref c as Ctx )
    if c.modInitGlobal.Count = 0 then return

    for pass as long = 0 to 1
        dim as boolean isCtor = (pass = 0)
        dim as Tko.InternId nm = c.names->GetString( iif( isCtor, "_GLOBAL__I", "_GLOBAL__D" ) )
        dim as MirFunction ptr f = c.m->AddFunction( nm, MT_VOID )
        f->isDefinition = true
        '' INTERNAL, as fbc emits them (llvm-nm: 't', measured 2026-09-26): every module
        '' with such a global defines both names, so two of them failed the link with
        '' "duplicate symbol: _GLOBAL__I". global_ctors keeps them alive.
        f->isPrivate = true
        f->isModuleCtor = isCtor
        f->isModuleDtor = (isCtor = false)

        dim as MirFunction ptr savedF = c.f
        dim as long savedB = c.curBlock
        c.f = f
        c.st->functions += 1
        c.curBlock = NewBlock( c, "entry" )

        dim as long n = c.modInitGlobal.Count
        for k as long = 0 to n - 1
            dim as long i = iif( isCtor, k, n - 1 - k )
            dim as Tko.TypeId gt = cast( Tko.TypeId, c.modInitType[i] )
            dim as MirValue ga
            ga.kind = cast( ubyte, MV_GLOBAL )
            ga.ty = cast( ubyte, MT_PTR )
            ga.id = c.modInitGlobal[i]

            if c.types->Kind( gt ) = Tko.TK_UDT then
                if isCtor then
                    '' A NAMED CONSTRUCTOR FIRST. See the note in InitSharedGlobal: the
                    '' declaration chose one, and the zero-arity lookup below would run
                    '' a different constructor and drop the arguments.
                    dim as Tko.NodeId mic = Tko.NODE_NONE
                    if i < c.modInitCall.Count then
                        mic = cast( Tko.NodeId, c.modInitCall[i] )
                    end if
                    if mic <> Tko.NODE_NONE then
                        if CtorCallOnAddr_( c, ga, gt, mic ) then continue for
                        '' ...OR A VALUE FOR A CONVERTING ONE: 'dim shared as DWSTRING g = "abc"'.
                        '' Its temporaries die here, since no statement end follows.
                        dim as long sm = c.strTemps.Count, wm = c.wstrTemps.Count, um = c.udtTemps.Count
                        dim as boolean conv = LowerConvCtorInit_( c, -1, gt, mic, @ga )
                        ReleaseUdtTemps_( c, um ) : ReleaseWstrTemps_( c, wm ) : ReleaseStrTemps_( c, sm )
                        if conv then continue for
                    end if
                    dim as Tko.SymbolId ct = StructorWithArity( c, StructorOf( c, gt, "__ctor" ), 0 )
                    if ct <> Tko.SYMBOL_NONE then
                        dim as FB.Array( of ulong ) none1
                        EmitStructorCall( c, ct, -1, @ga, @none1 )
                    elseif TypeNeedsInit_( c, gt ) then
                        CallImplicitCtor_( c, gt, ga )
                    end if
                    '' ...AND A COLLECTION INITIALISER'S CALLS, now that it exists:
                    '' 'dim shared a as Array( of long ) = { 1, 2 }'. symbols/collinit.bas.
                    if i < c.modInitColl.Count then
                        LowerCollInitCalls_( c, cast( Tko.NodeId, c.modInitColl[i] ) )
                    end if
                else
                    dim as Tko.SymbolId dt = StructorWithArity( c, StructorOf( c, gt, "__dtor" ), 0 )
                    if dt <> Tko.SYMBOL_NONE then
                        dim as FB.Array( of ulong ) none2
                        EmitStructorCall( c, dt, -1, @ga, @none2 )
                    elseif TypeNeedsDtor_( c, gt ) then
                        CallImplicitDtor_( c, gt, ga )
                    end if
                end if
            else
                '' AN ARRAY OF THEM, element by element -- and the reversal applies
                '' WITHIN the array too, which is what fbc's own _GLOBAL__D does.
                dim as boolean wants = false
                if isCtor then
                    wants = ArrayElemNeedsInit_( c, gt )
                else
                    wants = ArrayElemNeedsDtor_( c, gt )
                end if
                if wants then EmitArrayElemsAt_( c, ga, gt, isCtor )
            end if
        next

        Terminate( c, MTERM_RET, -1, -1, NoVal( ) )
        c.f = savedF
        c.curBlock = savedB
    next
end sub

'' The priority a module structor WROTE, from the parser's side table, or 0 for none.
function StructorPrioOf_( byref c as Ctx, byval id as Tko.NodeId ) as long
    for i as long = 0 to c.ast->structorPrio.Count - 2 step 2
        if cast( Tko.NodeId, c.ast->structorPrio[i] ) = id then
            return cast( long, c.ast->structorPrio[i + 1] )
        end if
    next
    return 0
end function

end namespace
