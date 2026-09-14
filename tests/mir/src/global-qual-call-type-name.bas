'' '..Name( )' where the global scope holds a TYPE and a PROCEDURE of that name -- the
'' Windows headers' 'type INITCOMMONCONTROLSEX' beside 'InitCommonControlsEx', which
'' AfxNova's CWindow constructor calls as '..InitCommonControlsEx( @icc )'.
type tagINITTHING
    as long dwSize
    as long dwICC
end type
type INITTHING as tagINITTHING

extern "Windows"
declare function InitThing( byval p as const INITTHING ptr ) as long
end extern

namespace Ns
    type Win
        as long ok
        declare constructor( )
    end type
    constructor Win( )
        dim icx as INITTHING
        icx.dwSize = sizeof( icx )
        icx.dwICC = 7
        ..InitThing( @icx )
        ok = ..InitThing( @icx )
    end constructor
end namespace

dim as Ns.Win w
