' PsApp finding F5: a string stored into a pointer is fbc's error 181. Every line marked
' "refused" is refused by fbc-modern; the rest compile there.
type T
    p as const wstring ptr
end type
const KLASS = wstr( "X" )
const NARROW = "Y"
dim as T t
t.p = KLASS                             ' refused: the PsApp shape, an ICE before
dim as zstring ptr z
z = NARROW                              ' refused
dim as any ptr a
a = "x"                                 ' refused: tiko stored the literal's address
dim as string s = "abc"
z = s                                   ' refused
dim as ustring u = "abc"
z = u                                   ' refused
z = "a" & "b"                           ' refused
function f( ) as zstring ptr
    return "abc"                        ' refused
end function
function g( ) as zstring ptr
    function = "abc"                    ' refused
end function
' Fine: the characters' address, a pointer, a character through a pointer.
z = strptr( s )
a = @s
dim as zstring ptr ok = z
dim as ubyte ptr b = cast( ubyte ptr, z )
dim as integer n = z[0]
