'' A STRING AND A NUMBER DO NOT CONVERT INTO EACH OTHER BY ASSIGNMENT -- fbc error 181 in
'' every direction: a literal, a byte, an integer, a double, a fixed zstring, a byte
'' through a pointer, and a string index (which is a byte). The initialiser form was
'' already refused; this is the same question one line later.
'' And 'operator []' is never static (232) and always returns something (68).
type Ok
    i as integer
    declare operator []( byval i as integer ) as integer
end type
operator Ok.[]( byval i as integer ) as integer
    operator = i
end operator

dim s as string = "a", t as string
dim z as zstring * 8 = "a"
dim b as byte, n as integer, d as double
dim p as byte ptr

t = s
n = b
z = s

s = 65
s = n
b = s
n = s
n = z
*p = s
t = s[1]

type Bad
    i as integer
    declare static operator []( byval i as integer ) as integer
    declare operator []( byval i as long )
end type
