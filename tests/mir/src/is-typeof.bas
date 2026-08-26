'' 'a IS T' -- the RTTI type test, which did not exist: it was not an operator, not a
'' type, and not lowered. Between virtual/rtti.bas and generics/inheritance.bas it is
'' thirty declines, and it is how any FreeBASIC program asks what it is holding.
''
'' PRECEDENCE MEASURED, not assumed. '-1 = a is Dog' is -1, so IS binds TIGHTER than
'' '=' -- read the other way round it would be '(-1 = a) is Dog', which does not
'' compile -- and 'a is Dog andalso 1' compiles, so it is tighter than ANDALSO too.
'' Its RIGHT OPERAND IS A TYPE NAME rather than an expression, so nothing binds to its
'' right and its level only says how much of the left it takes.
''
'' Lowering is measured too:
''
''   int32 vr$2 = fb_IsTypeOf( (void*)A$0, (void*)&_ZTSN3DOGE );
''
'' -- the object's ADDRESS and the named type's RTTI record, both of which the vtable
'' work already produced. '*p is Dog' passes the pointer itself, which is the same
'' address by another route. The result is LONG, and it is 0 or -1.
type Animal extends Object
    declare virtual sub speak( )
end type
sub Animal.speak( ) : end sub

type Dog extends Animal
end type

type Cat extends Animal
end type

dim d as Dog
dim byref a as Animal = d
dim as Animal ptr p = @d

print (a is Dog), (a is Cat)
print (*p is Dog), (*p is Cat)

'' the precedence measurements themselves
print -1 = a is Dog
if a is Dog andalso 1 then print "andalso"
