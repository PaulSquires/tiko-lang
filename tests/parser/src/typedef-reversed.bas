'' 'type as integer myint' -- the reversed typedef. Measured against fbc: the plain
'' spelling, a qualified pointer type, a procedure type, and a COMMA LIST that declares
'' every name, which three corpus files use.
''
'' It had to be tested before DeclName, which happily takes 'as' as the type's name:
'' the type was called 'as', the next token was not AS, and the parser fell through to
'' the aggregate body hunting an 'end type' that was never coming.

type as integer MyInt
type U as ulong
type as const U ptr ConstUPtr
type as function( as integer ) as integer PFunc
type as integer TwoA, TwoB

'' The ordinary spelling is untouched.
type Plain as integer

dim a as MyInt
dim b as ConstUPtr
dim c as PFunc
dim d as TwoA
dim e as TwoB
dim f as Plain

print 1
