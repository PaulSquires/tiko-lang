'' A STATIC LOCAL OBJECT: constructed once behind a guard, at the declaration, and
'' destroyed through an atexit thunk.
type SO
    as long i
    declare constructor( byval a as long )
    declare destructor( )
end type

constructor SO( byval a as long )
    this.i = a
end constructor

destructor SO( )
end destructor

'' No destructor at all, so no thunk and no atexit -- only the guard and the
'' constructor.
type SC
    as long i
    declare constructor( )
end type

constructor SC( )
    this.i = 9
end constructor

sub P( byval q as long )
    '' A plain scalar static is storage with a compile-time initialiser and gets no
    '' guard of any kind.
    static as long n = 7
    static as SO a = SO( 1 )
    static as SC b
    n += 1
    print n, a.i, b.i
    if q > 0 then
        '' Inside a branch: not constructed until the branch runs, and it has a guard
        '' of its own.
        static as SO c = SO( 2 )
        print c.i
    end if
end sub

P( 1 )
