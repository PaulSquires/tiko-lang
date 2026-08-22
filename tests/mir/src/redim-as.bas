'' 'redim foo( 1 to 2 ) as integer' DECLARES foo as well as sizing it.
''
'' It is how a dynamic array is brought into existence in one line, and the corpus's own
'' redim test writes nothing else. Both Collect and Resolve skipped every REDIM outright
'' -- correctly for the plain form, which re-dimensions an array that already exists --
'' so the array was never declared, never typed, and lowering had no symbol, no type and
'' no descriptor to build. Every one produced NO CODE AT ALL.
''
'' The 'as' clause is what tells the two forms apart, and it has to be read off the
'' ITEM rather than the statement: 'redim as long baz( 0 to 2 )' puts it there too and
'' means the same thing.
''
'' The declared type is a DYNAMIC array whatever bounds were written -- the whole point
'' of the form is that they are set at run time.

sub P( )
    redim foo( 1 to 2 ) as integer
    redim bar( 0 to 1 ) as double
    redim as long baz( 0 to 2 )

    '' The plain form still declares nothing, and still re-dimensions what is there.
    dim as long a( any )
    redim a( 0 to 4 )
    redim preserve a( 0 to 9 )
    erase a
end sub
