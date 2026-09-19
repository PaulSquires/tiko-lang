'' '...' IS ONLY FOR A CDECL PROCEDURE -- fbc's error 312. A procedure that writes no
'' convention takes its extern block's, or else the target's: stdcall on Windows, cdecl
'' on Linux. Each refusal below is on exactly the line fbc-modern 1.20 and 1.10.1 refuse
'' for win64 and fbc-modern's Linux build refuses for Linux (2026-09-19); tiko-lang
'' accepted every one.

'' Refused on every target: a convention written, or given by a Windows block.
declare sub vStd stdcall( byval a as long, ... )
declare sub vPas pascal( byval a as long, ... )
extern "Windows"
declare sub vWin( byval a as long, ... )
declare sub vWinCb cdecl( byval cb as sub( byval a as long, ... ) )
end extern
extern "Windows-MS"
declare sub vWinMs( byval a as long, ... )
end extern
dim pStd as function stdcall( byval a as long, ... ) as long

'' fbc then reports nothing more for the statement -- not the overload rule, not a
'' convention that contradicts the DECLARE.
declare sub vStdOv stdcall overload( byval a as long, ... )
declare sub vMis cdecl( byval a as long, ... )
sub vMis stdcall( byval a as long, ... )
end sub
type VCtor
    x as long
    declare constructor stdcall( byval a as long, ... )
end type

'' Refused on Windows only, where writing no convention is writing stdcall.
declare sub vPlain( byval a as long, ... )
declare function vFn( byval a as long, ... ) as long
sub vDef( byval a as long, ... )
end sub
extern "rtlib"
declare sub vRtl( byval a as long, ... )
end extern
type VMem
    x as long
    declare sub m( byval a as long, ... )
    declare static sub s( byval a as long, ... )
end type
dim pPlain as sub( byval a as long, ... )
type VAlias as function( byval a as long, ... ) as long
'' The definition's own convention, not its declaration's.
declare sub vCdeclDecl cdecl( byval a as long, ... )
sub vCdeclDecl( byval a as long, ... )
end sub
'' A member defined outside the 'extern "C"' block its type was declared in.
extern "C"
type VExtC
    x as long
    declare static sub m( byval a as long, ... )
end type
end extern
sub VExtC.m( byval a as long, ... )
end sub
'' A refused variadic member still blocks the member after it, on both targets.
type VSet
    x as long
    declare sub m( byval a as long, ... )
    declare sub m( byval a as double )
end type

'' Accepted everywhere: written cdecl, and the C and C++ blocks, whose default is cdecl.
declare sub okCdecl cdecl( byval a as long, ... )
dim pOk as sub cdecl( byval a as long, ... )
extern "C"
declare sub okC( byval a as long, ... )
dim pOkC as sub( byval a as long, ... )
end extern
extern "C++"
declare sub okCxx( byval a as long, ... )
end extern
extern "Windows"
declare sub okWinCdecl cdecl( byval a as long, ... )
end extern

'' A procedure TYPE inside 'typeof', which the parser reads speculatively and so used
'' to report nothing from: stdcall is refused on both targets, no convention on Windows.
dim pTyStd as typeof( sub stdcall( byval a as long, ... ) )
dim pTyPlain as typeof( sub( byval a as long, ... ) )
