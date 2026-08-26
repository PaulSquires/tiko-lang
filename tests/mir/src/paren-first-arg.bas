'' 'proc (x), y' IS ONE CALL WITH TWO ARGUMENTS, the first of them parenthesised.
''
'' The postfix parser takes '(x)' as the call's whole ARGUMENT LIST, so what follows the
'' ')' was read as more paren-less arguments and the comma produced an ELIDED one:
'' 'proc1 (4), 4' came out as 'proc1( 4 )' followed by <elided> and 4, and the statement
'' declined. structs/anon-param.bas writes ten of them.
''
'' MEASURED, all three shapes, which together say what the rule is:
''
''   p2 (4), 4      ->  4, 4       two arguments
''   p3 (1), 2, 3   ->  1, 2, 3    three
''   p2 (1, 2)      ->  1, 2       the paren IS the list -- nothing follows it
''
'' -- so: A COMMA AFTER THE CLOSING PAREN means the group was the FIRST ARGUMENT.
''
'' Only the ONE-ARGUMENT group is lifted. 'p2 (1, 2), 3' would make the group a TUPLE
'' argument, which is a different question and is left declining rather than guessed at.
sub p2( byval a as integer, byval b as integer )
    print a, b
end sub

sub p3( byval a as integer, byval b as integer, byval c as integer )
    print a, b, c
end sub

p2 1, 1
p2( 2, 2 )
p2 (4), 4
p2 (1, 2)
p3 (1), 2, 3
p2 type<integer>5, 5
p2 (type<integer>6), 6
