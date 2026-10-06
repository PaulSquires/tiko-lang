'' A UDT reaches a pointer only through a POINTER cast. fbc: a numeric cast into 'any ptr' is 24
'' (181 by assignment), a string or 'byref as zstring' cast into 'zstring ptr' 24.
type N
  v as integer = 77
  declare operator cast( ) as integer
end type
operator N.cast( ) as integer
  return this.v
end operator
type S
  x as integer
  declare operator cast( ) as string
end type
operator S.cast( ) as string
  return "s"
end operator
dim as N nv
dim as S sv
dim as any ptr a = nv
print a
dim as any ptr b
b = nv
dim as zstring ptr z = sv
type R
    s as zstring * 8 = "hello"
    declare operator cast( ) byref as zstring
end type
operator R.cast( ) byref as zstring
    return this.s
end operator
dim as R rv
dim as zstring ptr zp
zp = rv
