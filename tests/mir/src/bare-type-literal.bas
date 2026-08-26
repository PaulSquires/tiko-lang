'' 'x = type( )' -- A BARE TYPE LITERAL, which names no type of its own: it means a
'' default-constructed temporary of whatever the DESTINATION is.
''
'' The DECLARATION form 'dim as T y = type( )' already worked, because there the type is
'' written one line up. The ASSIGNMENT had nothing to construct from and produced
'' nothing at all -- and it cannot be answered in Check, which types bottom-up: the type
'' comes from the destination and from nowhere else.
''
'' MEASURED, AND THE TEMPORARY IS NOT AN IMPLEMENTATION DETAIL -- it is observable
'' through the destructor:
''
''   _ZN1TC1Ev( &TMP$2$0 );
''   __builtin_memcpy( &X$0, &TMP$2$0, 4 );
''   _ZN1TD1Ev( &TMP$2$0 );
''
'' -- construct a temporary, copy it in, destroy it, and destroy it at the end of the
'' STATEMENT rather than of the scope. Constructing straight into the destination would
'' skip that destructor, which is exactly what structs/temp-var-dtors.bas counts.
type T
    declare constructor( )
    declare destructor( )
    as long n
end type

constructor T( )
    this.n = 1
end constructor

destructor T( )
end destructor

dim as T y = type( )
print y.n

dim z as T
z = type( )
print z.n
