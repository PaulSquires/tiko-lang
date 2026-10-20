' A fixed-length string assigned or initialised from a PAREN-LESS call: a string
' property, a method, and a static one. tiko passed the getter's CODE ADDRESS to
' fb_StrAssign as the source descriptor, and the program faulted.
type Person
    as string t
    declare property Tag() as string
    declare function Tg() as string
    declare static function St() as string
end type
property Person.Tag() as string
    return t
end property
function Person.Tg() as string
    return t & "!"
end function
static function Person.St() as string
    return "static"
end function
dim as Person pp
pp.t = "Ada"
dim as zstring * 16 z1 = pp.Tag
print z1
dim as zstring * 16 z2
z2 = pp.Tg
print z2
dim as string * 8 f1 = pp.Tag
print "[" & f1 & "]"
dim as zstring * 16 z3 = Person.St
print z3
