dim shared as wstring * 10 wa = "PTR"
dim shared as wstring * 10 wb = "REF"
type W1
    as long v
    declare operator cast( ) as wstring ptr
    declare operator cast( ) byref as wstring
end type
operator W1.cast( ) as wstring ptr : return @wa : end operator
operator W1.cast( ) byref as wstring : return wb : end operator
type W2
    as long v
    declare operator cast( ) byref as wstring
    declare operator cast( ) as wstring ptr
end type
operator W2.cast( ) byref as wstring : return wb : end operator
operator W2.cast( ) as wstring ptr : return @wa : end operator
type N1
    as long v
    declare operator cast( ) as zstring ptr
    declare operator cast( ) as string
end type
operator N1.cast( ) as zstring ptr : return @"ZPTR" : end operator
operator N1.cast( ) as string : return "STR" : end operator
dim as W1 x1 : dim as W2 x2 : dim as N1 y1
print x1, x2, y1
dim as wstring * 20 s1 = x1, s2 = x2
print s1, s2
dim as string t1 = y1
print t1
dim as wstring ptr q1 = x1
print *q1
print "<" & x1 & ">"; "<" & y1 & ">"
