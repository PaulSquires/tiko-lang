'' 'f.bar 1' -- AN OVERLOADED MEMBER CALLED AS A STATEMENT. A call written without
'' parentheses is not an N_CALL node: it is the statement's own callee and children, so
'' nothing costed its arguments and lowering used whatever Resolve had bound -- the HEAD
'' of the overload chain. Check already re-costs one whose callee is a plain N_IDENT;
'' an N_MEMBER callee is the same statement and was not covered.
''
'' Here the head is the SUB, so 'f.bar 1' passed a receiver and an argument to something
'' declaring only a receiver: 'calls FOO.BAR with 2 arguments, which declares 1'.
''
'' Measured against fbc, which prints '1 0 -1': the parenthesised call and the statement
'' call both reach the FUNCTION, and only the bare 'f.bar' reaches the sub.
type foo
    as integer sub_called = 0

    declare sub bar
    declare function bar( byval i as integer ) as integer
end type

sub foo.bar
    sub_called = -1
end sub

function foo.bar( byval i as integer ) as integer
    function = i
end function

dim as foo f

print f.bar( 1 )
f.bar 1
print f.sub_called
f.bar
print f.sub_called
