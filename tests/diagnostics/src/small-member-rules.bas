'' THREE SMALL RULES MEASURED AGAINST FBC.
''   A bydesc parameter declared 'array(any)' has a known rank: 'array(1, 2)' inside the
''   procedure is error 36 exactly as outside.
''   A parameter default may not name a LOCAL, and a local array's element counts (272).
''   A nested type or typedef reached through an INSTANCE is not a field (18);
''   through the type's own name it is the ordinary qualified spelling.
type UDT
    dim as integer i
    type Int_ as long
    enum E_
        e1
    end enum
end type
dim shared g(0 to 1) as integer
dim locali(0 to 1) as integer
dim u as UDT
dim ok1 as UDT.Int_ = 1
dim ok2 as integer = UDT.e1

sub okRank( array(any) as integer )
    print array(1)
end sub
sub okDefault( byval p as integer = g(0) )
end sub

sub badRank( array(any) as integer )
    print array(1, 2)
end sub
sub badDefault( byval p as integer = locali(0) )
end sub
u.Int_ = 0
