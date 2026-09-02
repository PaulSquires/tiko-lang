'' THREE RULES MEASURED AGAINST FBC.
''   A static-storage scalar is initialised from a constant (error 11): 'dim shared i =
''   x' over another shared variable, 'static i = x' inside a sub, a fixed string from a
''   string variable. A literal, a constant, an address and a plain 'dim' are fine.
''   'dim shared' inside a scope block is error 96 (61 inside a sub); 'static' is fine.
''   The first redim of a rank-0 dynamic array fixes its rank (36 afterwards).
dim shared x as integer
dim s as string = "a"
const K = 5
dim shared ok1 as integer = 1
dim shared ok2 as integer = K
dim shared ok3 as integer ptr = @x
dim ok4 as integer = x
dim arr() as integer
redim arr(0 to 0)
print arr(0)
redim arr(0 to 3)
scope
    static okStatic as integer
end scope

dim shared bad1 as integer = x
dim shared bad2 as zstring * 32 = s
sub s1( )
    dim v as integer
    static bad3 as integer = v
end sub
scope
    dim shared bad4 as integer
end scope
print arr(0, 0)
redim arr(0 to 0, 0 to 0)
