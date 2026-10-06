'' MID statement into a string*N: the destination's tagged length reaches fb_StrAssignMid intact.
dim as string * 8 f = "abcdefgh"
mid( f, 3, 2 ) = "XY"
print "["; f; "]"
mid( f, 7 ) = "1234"
print "["; f; "]"
dim as string * 3 g = "abc"
mid( g, 2, 5 ) = "zzzzz"
print "["; g; "]"
type T
    s as string * 6
end type
dim as T t
t.s = "tttttt"
mid( t.s, 1, 3 ) = "QQQ"
print "["; t.s; "]"
