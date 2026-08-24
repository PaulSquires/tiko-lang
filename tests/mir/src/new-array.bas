'' 'new T[n]' -- THE ARRAY FORM, which was refused outright.
''
'' Measured from what fbc emits for 'new C[3]' over a type with a constructor:
''
''     void* vr = calloc( 12ull, 1ull );          n * sizeof( T ), folded into the
''     TMP2 = (struct C*)vr;                      first argument as the scalar form does
''     if( TMP2 == 0 ) goto DONE;
''     TMP4 = TMP2;  TMP3 = 3ull;
''     LOOP: if( TMP3 == 0 ) goto DONE;
''           _ZN1CC1Ev( TMP4 );                   one constructor call per element
''           TMP4 = (struct C*)((uint8*)TMP4 + 4);
''           TMP3 = TMP3 - 1;
''           goto LOOP;
''     DONE: P = TMP2;
''
'' -- so the count is a RUNTIME value, the loop counts down, and the whole thing is
'' guarded by the same null check the scalar form has. There is no cookie: a trivial
'' destructor needs no count and fbc emits none.
''
'' THE COUNT IS EVALUATED ONCE. 'new ClassUDT[sidefx( )]' is how functions/paraminit
'' writes it, precisely to check that.
dim shared as long calls

function sidefx( ) as long
	calls += 1
	return 3
end function

type C
	as long i
	declare constructor( )
end type

constructor C( )
	this.i = 5
end constructor

dim as C ptr p = new C[3]
print p[0].i, p[2].i
delete[] p

dim as C ptr q = new C[sidefx( )]
print q[0].i, calls
delete[] q

'' A SCALAR ELEMENT NEEDS NO LOOP AT ALL: calloc has already zeroed the storage.
dim as long ptr r = new long[4]
r[0] = 1
r[3] = 9
print r[0], r[3]
delete[] r

'' ...and the scalar form beside it, unchanged.
dim as C ptr s = new C
print s->i
delete s
