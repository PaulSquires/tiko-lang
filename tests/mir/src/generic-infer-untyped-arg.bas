'' A GENERIC OVERLOAD MUST NOT BE BOUND ON AN ARGUMENT IT COULD NOT TYPE. fb/string.bi included
'' fb/array.bi, whose 'Contains( of T )( byref a as Array( of T ), byref v as T )' headed one
'' FB.Contains chain with the string overloads. Inference skipped the first parameter when its
'' argument was a METHOD call (which it does not type), took T from the literal, and bound
'' 'contains<15>' -- so the concrete ustring overloads were never scored and fbsqlite's tests
'' stopped at TKO0632.
''
'' std/strings and std/containers are two modules now, and their Contains two names, so the
'' chain is declared HERE (2026-10-10): the runtime's string overloads and a generic over a
'' minimal array type, in one namespace, as the header had them.
''
'' fbc prints: true false true false false
namespace N
    extern "C"
        declare function Contains overload alias "fb_StrContains" _
            ( byref s as const string, byref match as const ustring, _
              byval ignoreCase as boolean = false ) as boolean
        declare function Contains overload alias "fb_UStrContains" _
            ( byref s as const ustring, byref match as const ustring, _
              byval ignoreCase as boolean = false ) as boolean
    end extern
    type Arr( of T )
        as T items( any )
    end type
    function Contains( of T )( byref a as Arr( of T ), byref v as T ) as boolean
        for i as integer = 0 to ubound( a.items )
            if a.items( i ) = v then return true
        next
        return false
    end function
end namespace
type Cell
	as ustring t
	declare function AsText( ) as ustring
end type
function Cell.AsText( ) as ustring
	return t
end function
type Holder
	as Cell c
	declare function Value( ) as Cell
end type
function Holder.Value( ) as Cell
	return c
end function
dim as string s = "a second line"
print N.Contains( s, "second line" )
print N.Contains( s, chr( 10 ) )
dim as Holder h
h.c.t = "x second line"
print N.Contains( h.Value( ).AsText( ), "second line" )
print N.Contains( h.Value( ).AsText( ), chr( 10 ) )
print N.Contains( h.c.AsText( ), "Инженеринг" )
