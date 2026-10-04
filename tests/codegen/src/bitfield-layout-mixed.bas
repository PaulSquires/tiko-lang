type B1
  a : 1 as boolean
  b : 1 as boolean
  c as byte
end type
type B2 field = 1
  a as byte
  b : 12 as long
  c : 12 as long
  d as byte
end type
type B3
  a : 31 as long
  b : 2 as long
  c : 1 as byte
end type
type B4
  a : 7 as ubyte
  b : 2 as ubyte
  c : 7 as ushort
  d : 10 as ushort
end type
type B5
  a as byte
  b : 40 as longint
  c : 30 as longint
end type
type B6
  a : 3 as integer
  b as short
  c : 3 as integer
end type
type B7
  a : 5 as long
  union
    u : 3 as long
    v as byte
  end union
  w : 4 as long
end type
print "B1 "; sizeof(B1); offsetof(B1, c)
print "B2 "; sizeof(B2); offsetof(B2, d)
print "B3 "; sizeof(B3)
print "B4 "; sizeof(B4)
print "B5 "; sizeof(B5)
print "B6 "; sizeof(B6); offsetof(B6, b)
print "B7 "; sizeof(B7)
dim as B1 x1 : x1.a = true : x1.b = false : x1.c = 3
print "B1 vals "; x1.a; x1.b; x1.c
dim as B2 x2 : x2.b = 4095 : x2.c = -1 : x2.d = 9
print "B2 vals "; x2.b; x2.c; x2.d
dim as B3 x3 : x3.a = -1 : x3.b = 3 : x3.c = 1
print "B3 vals "; x3.a; x3.b; x3.c
dim as B4 x4 : x4.a = 127 : x4.b = 3 : x4.c = 127 : x4.d = 1023
print "B4 vals "; x4.a; x4.b; x4.c; x4.d
dim as B5 x5 : x5.b = &hFFFFFFFFFFll : x5.c = 12345
print "B5 vals "; x5.b; x5.c
dim as B6 x6 : x6.a = 7 : x6.b = -2 : x6.c = 5
print "B6 vals "; x6.a; x6.b; x6.c
dim as B7 x7 : x7.a = 31 : x7.u = 5 : x7.w = 9
print "B7 vals "; x7.a; x7.u; x7.v; x7.w
x3.a += 1
print "B3 inc "; x3.a; x3.b
x4.a = 200
print "B4 trunc "; x4.a; x4.b
