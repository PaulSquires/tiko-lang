'' 'extends A, B': fbc's 17 at line 9 (fbc-modern 1.20). tiko kept A and dropped B.
type A extends object
    a as long
end type
type B extends object
    b as long
end type
type C1 extends A
end type
type C extends A, B
    c as long
end type
