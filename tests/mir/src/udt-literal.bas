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
''
'' BOTH SIDES OF THE PAIRING ARE FLATTENED. fbc flattens an initialiser completely --
'' 'type<Outer>( type<P>( 1, 2 ), 3 )' is three stores at 0, 4 and 8, not one aggregate
'' store and one scalar. Flattening only the FIELDS paired leaf 0 with the whole inner
'' literal: 'o.inner.a' got a sign-extended aggregate, 'o.inner.b' got 3, and 'o.n' got
'' nothing. It lowered and it verified. A leaf that is still an aggregate is refused
'' outright now, so the two lists cannot silently disagree again.
type Outer
    as P    inner
    as long n
end type
dim as Outer o = type<Outer>( type<P>( 1, 2 ), 3 )
dim as P short_ = type<P>( 42 )

'' AN ARRAY FIELD contributes its ELEMENTS, one leaf each, and takes them from a
'' '{ ... }' list. Measured: fbc turns 'as ubyte d4( 0 to 7 )' initialised from
'' '{ &hC0, 0, 0, 0, 0, 0, 0, &h46 }' into eight byte stores at offsets 8..15, not one
'' aggregate store. Refusing it declined every GUID in fb/comptr.bi, which is how COM
'' declares every IID.
type GUID
    as ulong  d1
    as ushort d2
    as ushort d3
    as ubyte  d4( 0 to 7 )
end type
dim as GUID iid = type<GUID>( &h00020400, &h0000, &h0000, _
                              { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )

'' AN AGGREGATE VALUE COVERS A WHOLE FIELD, not one leaf. Measured: 'dim y as T3 =
'' ( x, 31, 301 )' over a T3 whose first field is a T1 is '__builtin_memcpy( &Y, &X, 4 )'
'' for that field and scalar stores for the rest. Pairing value i with leaf i coerced a
'' whole object into an i32 slot -- a sign-extended aggregate -- and wrote every field
'' after it one place early.
type T1
    as long a
end type
type T3 extends T1
    as long b
    as long c
end type
dim as T1 base1 = ( 11 )
dim as T3 y = ( base1, 31, 301 )

'' The SAME object written flat. fbc accepts both spellings and emits the same three
'' stores, so the flattening has to be greedy on the value side too.
dim as Outer flatOuter = ( 1, 2, 3 )

'' AS A RESULT ASSIGNMENT. The result slot IS the object, so this is the declaration
'' initialiser with the result's type standing in for the declared one.
''
'' ONLY THE 'type( ... )' SPELLING IS LEGAL HERE. Measured: fbc accepts
'' 'function = type( 5, 6 )' and rejects 'function = ( 5, 6 )' with error 7, expecting
'' ')' where the comma is. The two build the same node, so the parser marks which was
'' written -- sharing NF_UNTIL's bit, which is N_DO's and cannot appear on a tuple.
function MakeP( ) as P
    function = type( 1, 2 )
end function

function MakePTyped( ) as P
    function = type<P>( 3, 4 )
end function
