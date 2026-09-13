'' 'FUNCTION = <value of another type>' INTO A UDT RETURNED THROUGH THE HIDDEN POINTER
'' calls the type's CONVERTING 'operator let', as an ordinary assignment does. fbc-modern
'' prints, and tiko now prints too:
''
''    l:ab l:cd l:hi
''
'' The result path only looked for a let taking the result's OWN type and otherwise
'' copied the value's bytes over the object: a 'wstring * 16' went in as 32 bytes, over a
'' STRING descriptor, and the program died with 0xC0000374. AfxNova's
'' AfxPathRemoveBackslashEx does it with a 'wstring * 32768', and the 65536-byte aggregate
'' load crashed clang itself, in instruction selection.
type DW
    s as string
    declare constructor( )
    declare constructor( byref w as const wstring )
    declare destructor( )
    declare operator let( byref w as const wstring )
end type
constructor DW( )
end constructor
constructor DW( byref w as const wstring )
    s = "c:" & w
end constructor
destructor DW( )
end destructor
operator DW.let( byref w as const wstring )
    s = "l:" & w
end operator
function fa( byref wp as const wstring, byval k as integer ) as DW
    dim as wstring * 16 buf = wp
    if k then
        function = buf
    else
        function = wp
    end if
end function
function fb( byval pw as wstring ptr ) as DW
    function = *pw
end function
dim as wstring * 8 hw = "hi"
print fa( "ab", 1 ).s; " "; fa( "cd", 0 ).s; " "; fb( @hw ).s
