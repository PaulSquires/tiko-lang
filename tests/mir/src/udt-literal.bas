'' 'type<P>( 5, 6 )' -- THE ANONYMOUS UDT LITERAL. 789 corpus lines and 36 lines of the
'' runtime headers write one, and it was not recognised at all.
''
'' THE FAILURE WAS SILENT. The expression parser read it as '(type < P) > (5, 6)' --
'' two comparisons over a name that binds to nothing -- so it produced a boolean-shaped
'' tree where an object belonged. A parameter defaulted from one emitted a phantom local
'' and NO CALL AT ALL, and the golden recorded that as correct for as long as it stood.
''
'' Measured: it is EXACTLY the parenthesised field list with the type written out. fbc
'' emits the same field stores for 'type<P>( 5, 6 )' as for '( 5, 6 )'.
type P
    as ulong  a
    as ushort b
end type

'' As a DECLARATION INITIALISER, where the type is also the declaration's.
dim as P d = ( 3, 4 )
dim as P e = type<P>( 5, 6 )

'' As a VALUE -- an argument. fbc builds a temporary and field-initialises it:
''     struct $1P TMP$5$0;  *(uint32*)&TMP$5$0 = 9u;  ...  Q( TMP$5$0 )
declare sub Q( byval p as P )
Q( type<P>( 9, 10 ) )

'' As a BYREF argument, where the temporary's ADDRESS is what is passed.
declare sub R( byref p as P )
R( type<P>( 11, 12 ) )

'' As a PARAMETER DEFAULT, which is the shape that exposed the misparse: the call site
'' writes no argument at all, so the default is the only thing there is to lower.
declare sub S( byref p as P = type<P>( 7, 8 ) )
S( )

'' KNOWN DIFFERENCE, recorded rather than left to be rediscovered: fbc also zeroes the
'' TRAILING PADDING of each object -- 'memset( &TMP + 6, 0, 2 )' for the two bytes after
'' 'b'. tiko-lang zeroes the tail only from the first field with NO VALUE, so a fully
'' written literal leaves its padding untouched. Not observable except through memcmp of
'' whole objects, and it predates the literal: the bare '( 3, 4 )' form does the same.
''
'' A NESTED literal, and a partial field list -- the tail is zeroed from the first
'' field with no value to the end of the object.
type Outer
    as P    inner
    as long n
end type
dim as Outer o = type<Outer>( type<P>( 1, 2 ), 3 )
dim as P short_ = type<P>( 42 )
