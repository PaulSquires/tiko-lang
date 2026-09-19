'' '...' MAY NOT BE THE FIRST PARAMETER -- fbc's error 313, asked before 312 and before
'' the overload rule, so each line below is 313 alone. Each is refused on exactly the line
'' fbc-modern 1.20 and 1.10.1 refuse it (2026-09-19); tiko-lang accepted them all.

declare sub vf1 cdecl( ... )
declare sub vf2( ... )
sub vf3 cdecl( ... )
end sub
dim pvf as sub cdecl( ... )
type TVF as function cdecl( ... ) as long
declare sub vf4 cdecl( ..., byval a as long )
declare sub vf5 cdecl overload( ... )
namespace NVF
    declare sub vf6 cdecl( ... )
end namespace
extern "C"
    declare sub vf7( ... )
end extern
dim pvt as typeof( sub cdecl( ... ) )

type HasThis
    x as long
    cb as sub cdecl( ... )
    declare static sub s cdecl( ... )
    '' A method's hidden THIS is its first parameter, so these two are NOT 313: the
    '' first is accepted, the constructor is the overload rule's (fbc's 143).
    declare sub m cdecl( ... )
    declare constructor cdecl( ... )
end type
'' ...but a member DEFINITION is 313 all the same.
sub HasThis.m cdecl( ... )
end sub
type TOp
    x as long
end type
declare operator + cdecl( ... ) as TOp
