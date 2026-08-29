'' A GENERIC CALLED WITH A UNARY EXPRESSION. There was no N_UNARY case in the
'' inference walk, so 'ExitEarly( -4 )' inferred nothing and declined while
'' 'ExitEarly( 4 )' on the line above instantiated -- the last declining statement in
'' generics/lambda-in-generic.bas.
''
'' Measured with '#print typeof', and the sign operators and NOT do NOT follow the
'' same rule:
''
''     -b -s -ul -q -uq -i -ui    INTEGER      every integral operand
''     -f                         SINGLE
''     -d                         DOUBLE
''     -bo                        fbc error 20, type mismatch
''     not bo                     BOOLEAN
''     not ui, not uq             UINTEGER     the 64-bit unsigned pair
''     not ub, not us, not ul     INTEGER      a narrower unsigned fits
''     not f, not d               INTEGER
''
'' -- so '-' forces SIGNED where 'not' keeps an operand that already fills the integer
'' width unsigned, and neither is BinaryResult over (t,t): 'uq - uq' is UINTEGER where
'' '-uq' is INTEGER.
function Ident( of T )( byval x as T ) as T
    return x
end function

dim as long n = 4
dim as single f = 1.5
dim as ulongint uq = 1
dim as boolean bo = false

print Ident( 4 )
print Ident( -4 )
print Ident( -n )
print Ident( -f )
print Ident( not n )
print Ident( not uq )
print Ident( not bo )
