'' lowermember.bas -- InitMember_ and DestroyMember_: one field's initialisation and
'' one field's release, for the synthesised structors. Split out of lowerimpl.bas on
'' 2026-09-10 for the 1500-line cap; nothing about the code changed in the move.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' Defined in lowerstrkind.bas: which fixed-string flavour a type is, and its length.
'' Declared here because this is its own compilation unit.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long


'' One member's initialisation, whatever it turns out to be.
sub InitMember_ _
    ( byref c as Ctx, byref addr as MirValue, byval ft as Tko.TypeId )

    if addr.kind = cast( ubyte, MV_NONE ) then return
    if IsStringType( c, ft ) then
        '' A var-length string is a descriptor, and an UNZEROED one is what made
        '' fb_StrAssign free a pointer that was never allocated.
        if StrSwapKind_( c, ft, 0 ) = 0 then ZeroStrDescriptor( c, addr )
        return
    end if
    if c.types->IsDynArray( ft ) then
        InitDynArrayDesc( c, addr, ft )
        return
    end if

    '' A FIXED ARRAY FIELD, and this branch was simply missing.
    ''
    '' DestroyMember_ below grew a TK_ARRAY branch -- it destroys every element of a
    '' fixed array of strings through fb_ArrayDestructStr -- and its twin here did
    '' not. So a type holding 'as string items(0 to 3)' got a synthesised
    '' constructor that emitted NOTHING and a destructor that freed four descriptors
    '' nobody had written: 'dim as B3 a' then one assignment exits 0xC0000374 where
    '' fbc prints and returns 0. The missing half turned a leak into a crash.
    ''
    '' Measured, fbc zeroes the WHOLE FIELD in one go and does nothing else:
    ''
    ''     static void _ZN2B3C1Ev( struct $2B3* THIS$1 )
    ''     { __builtin_memset( (FBSTRING*)THIS$1, 0, 96ll ); }
    ''
    '' -- 96 bytes, four 24-byte descriptors, no per-element call. A UDT ELEMENT with
    '' a real constructor still needs its own loop and is NOT modelled here: fbc
    '' emits one, and which shape a FIELD should take is the same open choice
    '' DestroyMember_ records for its own UDT-element case. Zeroing is right for the
    '' string element that crashes today and harmless under a constructor that would
    '' overwrite it, so the zero-fill goes in and the element loop stays owed.
    if c.types->Kind( ft ) = Tko.TK_ARRAY then
        dim as long asz2 = SizeOfType( c, ft )
        if asz2 <= 0 then return
        dim as FB.Array( of ulong ) zargs2
        zargs2.Push( cast( ulong, addr.kind ) )
        zargs2.Push( cast( ulong, addr.id ) )
        zargs2.Push( cast( ulong, MV_CONST_INT ) ) : zargs2.Push( 0 )
        zargs2.Push( cast( ulong, MV_CONST_INT ) )
        zargs2.Push( cast( ulong, asz2 ) )
        EmitRtl( c, RTL_MEMSET, zargs2 )
        return
    end if

    if c.types->Kind( ft ) <> Tko.TK_UDT then return

    dim as Tko.SymbolId ctor = StructorWithArity( c, StructorOf( c, ft, "__ctor" ), 0 )
    if ctor <> Tko.SYMBOL_NONE then
        dim as FB.Array( of ulong ) none_
        EmitStructorCall( c, ctor, -1, @addr, @none_ )
        return
    end if
    if TypeNeedsInit_( c, ft ) then CallImplicitCtor_( c, ft, addr )
end sub

end namespace
