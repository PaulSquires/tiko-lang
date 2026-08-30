'' AN ENUM MEMBER MAY COLLIDE WITH A NAME ALREADY DECLARED BESIDE IT, and fbc does not
'' reject it: the EXISTING name keeps the bare spelling and the member stays reachable
'' as 'E.K'. Measured -- 'const GlobalConst1 = 111' ahead of an enum whose second member
'' is also GlobalConst1 prints 111 for the bare name and 2 for 'Enum1.GlobalConst1'.
''
'' tiko-lang printed 111 FOR BOTH: an enum's inner scope WAS the enclosing scope, so
'' 'E.K' was a lookup of plain 'K' next to the enum, and the pre-existing constant
'' answered it. A wrong constant, lowered and verified, with only a duplicate
'' declaration diagnostic to hint at it. namespace/enum.bas and structs/inherit-type-2
'' are both this.
''
'' 'enum E explicit' publishes NOTHING unqualified -- fbc says error 42 for a bare
'' member -- while 'E.A' still reads 5 and the member after it 6.
const GlobalConst1 = 111

enum Enum1
    Enum1Const1 = 1
    GlobalConst1
end enum

print GlobalConst1
print Enum1.GlobalConst1
print Enum1.Enum1Const1

enum Enum2 explicit
    A = 5
    B
end enum

print Enum2.A
print Enum2.B

'' A member repeated WITHIN one enum is still a duplicate: the enum's own scope is
'' where that is caught, now that the enclosing one no longer sees every member.
dim z as Enum2
print z
