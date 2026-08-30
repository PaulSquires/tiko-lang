'' A '#define' IS SCOPED, because fbc's preprocessor shares the compiler's scoped
'' symbol table. Measured by running fbc:
''
''     sub a( ) : #define M 1 : print M : end sub
''     sub b( ) : #define M 2 : print M : end sub    accepted, prints 1 then 2
''     sub a( ) : #define M 1 : end sub : print M    error 42, M not declared
''     two SCOPE blocks, same name                   accepted, 1 then 2
''
'' tiko-lang's preprocessor is a separate pass over a flat table, so the second
'' definition was "macro 'M' is already defined" and the file was lost from there.
'' pp/token-pasting.bas redefines four macros in each of six TEST bodies, and fbcunit's
'' TEST expands to 'sub ... end sub'.
''
'' Only SUB, FUNCTION and SCOPE are tracked. fbc scopes to any block, a FOR body
'' included, but a form counted wrongly would undefine a macro EARLY -- breaking code
'' that works -- where a form left out only leaves tiko-lang as permissive as it was.
sub a( )
    #define M 1
    print M
end sub

sub b( )
    #define M 2
    print M
end sub

function f( ) as integer
    #define M 3
    '' 'function = expr' is a RESULT ASSIGNMENT and opens no block of its own.
    function = M
end function

scope
    #define M 4
    print M
end scope

scope
    #define M 5
    print M
end scope

a
b
print f( )
