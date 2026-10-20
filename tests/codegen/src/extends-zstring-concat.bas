' A type that EXTENDS ZSTRING, assigned a concatenation through 'operator let( byref as zstring )'.
type vZ extends zstring
    dim as string s
    declare operator cast() byref as zstring
    declare operator let(byref z as zstring)
end type
operator vZ.cast() byref as zstring
    return *strptr(this.s)
end operator
operator vZ.let(byref z as zstring)
    this.s = z
end operator
dim as vZ v
v = "abc"
v = v & "def"
v = "x" & v & "y"
v &= "!"
v &= v
print v
type pZ extends zstring
    dim as string s
    declare operator cast() byref as zstring
    declare operator let(byval pz as const zstring ptr)
end type
operator pZ.cast() byref as zstring
    return *strptr(this.s)
end operator
operator pZ.let(byval pz as const zstring ptr)
    this.s = *pz
end operator
dim as pZ w
w = "ab"
w &= space(2) & "c"
print "["; w; "]"
