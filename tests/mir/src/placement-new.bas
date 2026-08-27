'' PLACEMENT NEW -- 'new( p ) T'. It allocates nothing: the pointer written is the
'' object, cast to the type. Measured against fbc, and the four shapes differ only in
'' what runs inside the null guard:
''
''     new( p ) Plain            memset( TMP, 0, 8 )      -- no ctor, so it zeroes
''     new( p ) WithCtor         _ZN8WITHCTORC1Ev( TMP )  -- and NO memset beside it
''     new( p ) WithBoth( 7 )    _ZN8WITHBOTHC1Eu7INTEGER( TMP, 7 )
''     new( p ) integer( 111 )   *TMP = 111
''
'' The last one is not placement-specific: 'new integer( 111 )' DROPPED its initialiser
'' entirely -- calloc's zeroing stood in for it and the statement verified with the 111
'' nowhere in the output.
''
'' Before this the parser ate the placement parenthesis and reported 'expected )' at the
'' type name; where it did not error, 'new( buf ) T' produced an N_NEW with no target
'' and no children, and the allocation silently vanished.

type Plain
    dim as integer a
end type
type WithCtor
    dim as integer a
    declare constructor()
end type
constructor WithCtor()
    a = 9
end constructor
type WithBoth
    dim as integer a
    declare constructor()
    declare constructor( byval n as integer )
end type
constructor WithBoth()
    a = 1
end constructor
constructor WithBoth( byval n as integer )
    a = n
end constructor
dim as any ptr buf = allocate( 256 )
dim as Plain ptr pa = new( buf ) Plain
dim as WithCtor ptr pb = new( buf ) WithCtor
dim as WithBoth ptr pc = new( buf ) WithBoth( 7 )
dim as integer ptr pd = new( buf ) integer( 111 )
print pa->a, pb->a, pc->a, *pd
deallocate( buf )

'' ...and the ARRAY form, which allocates nothing either and zeroes a trivial element
'' type itself -- there is no calloc to have done it.
dim as any ptr buf2 = allocate( 256 )
dim as integer ptr qa = new( buf2 ) integer[3]
dim as Plain ptr qb = new( buf2 ) Plain[3]
dim as WithCtor ptr qc = new( buf2 ) WithCtor[3]
print qa[0], qb[1].a, qc[2].a
deallocate( buf2 )
