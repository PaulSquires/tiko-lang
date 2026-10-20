' A property named without 'this.' inside its own type's methods -- set and read -- and one
' spelled like the COLOR keyword, as fbc's OpenGL fbgl example writes it.
type Gl
    declare constructor()
    declare property color(byval c as ulong)
    declare property color() as ulong
    declare property size(byval n as integer)
    declare property size() as integer
    declare function Describe() as string
    as ulong cur
    as integer sz
end type
property Gl.color(byval c as ulong)
    cur = c
end property
property Gl.color() as ulong
    return cur
end property
property Gl.size(byval n as integer)
    sz = n
end property
property Gl.size() as integer
    return sz
end property
constructor Gl()
    color = &hffffff
    size = 3
end constructor
function Gl.Describe() as string
    size = size + 1
    return hex(color) & " " & size
end function
dim as Gl g
print g.Describe()
