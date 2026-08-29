'' 'dim u as U = iif( c, a, b )' -- AN IIF FEEDING A CONVERTING CONSTRUCTOR.
''
'' Measured, fbc builds ONE var-length temporary, initialises it in EACH BRANCH, and
'' constructs the UDT from its data pointer:
''
''     if( EXPR == 0 ) goto else;
''       fb_StrInit( &TMP, -1, T1, 50, 0 ); goto join;
''     else: fb_StrInit( &TMP, -1, T2, 50, 0 );
''     join: _ZN1UC1EPKc( &A, *(char**)&TMP );
''           fb_StrDelete( &TMP );
''
'' -- NOT a pointer per arm, which is what the note in ZstrDataOf_ previously guessed.
''
'' The var-length arms already worked; the FIXED ones did not, and the reason is that
'' Check DOES type an iif over two 'zstring * N' arms -- as 'zstring * N' -- so it took
'' the fixed row, asked an iif for an ADDRESS it has not got, and stopped. The iif is
'' now asked BEFORE the kind tests, which is where the shape is decided.
type U
    _data as zstring * 64
    declare constructor( )
    declare constructor( byval rhs as const zstring const ptr )
    declare operator cast( ) byref as const zstring
end type
constructor U( ) : end constructor
constructor U( byval rhs as const zstring const ptr )
    if rhs <> 0 then this._data = *rhs
end constructor
operator U.cast( ) byref as const zstring
    operator = this._data
end operator

dim shared expr as boolean = true
dim t1 as zstring * 50 = "one"
dim t2 as zstring * 50 = "two"
dim v1 as string = "three"
dim v2 as string = "four"

'' Fixed-length arms -- the shape that declined.
dim a1 as U = iif( expr, t1, t2 )
'' ...and the var-length pair beside it, which did not.
dim a2 as U = iif( expr, v1, v2 )

dim r1 as zstring * 50 = a1
dim r2 as zstring * 50 = a2
print r1, r2
