'' THE CONSTRUCTOR AND DESTRUCTOR FBC WRITES FOR YOU.
''
'' 'dim as T x : x.s = "hi"' used to hand fb_StrAssign a descriptor full of whatever
'' the stack held, which the runtime reads as an existing allocation and frees. Not a
'' leak -- a crash, from a program with no diagnostic against it.
''
'' Every rule below was measured from fbc's own C output.

'' A string field: needs both. The constructor zeroes the descriptor, the destructor
'' releases it.
type HasStr
    a as long
    s as string
end type

'' A dynamic array field: needs both, and the descriptor is BUILT rather than zeroed.
type HasArr
    d( any ) as long
end type

'' POD: needs NEITHER, and nothing at all is emitted for it. The negative control.
type Pod
    x as long
    y as long
end type

'' Chaining. A WRITTEN constructor still gets the base call and the field
'' initialisation in front of its own statements; a WRITTEN destructor still gets the
'' field releases and the base call after them. fbc prepends and appends rather than
'' replacing, so this is not only about types that declare nothing.
type BaseW
    declare constructor( )
    declare destructor( )
    a as long
end type
constructor BaseW( ) : end constructor
destructor BaseW( ) : end destructor

type DerivedW extends BaseW
    declare constructor( )
    declare destructor( )
    b as string
end type
constructor DerivedW( )
    this.b = "hi"
end constructor
destructor DerivedW( ) : end destructor

'' A dynamic array member stops the ASSIGNMENT from being synthesised, and nothing
'' else: fbc copies one with fb_ArrayRedimTo and an element loop, and an assignment
'' that skipped the array would look like the field had been handled.
sub copies( )
    dim as HasStr a
    '' The COPY CONSTRUCTOR: the default one's body followed by the assignment, which
    '' is how fbc writes it -- so the descriptor is zeroed and then assigned rather
    '' than assigned over one that was never initialised.
    dim as HasStr b = a
    '' ...and the ASSIGNMENT. A whole-aggregate store here left two objects owning one
    '' buffer, and both were released at scope exit: a double free, not a leak.
    a = b
end sub
copies( )

'' A MODULE-LIFETIME OBJECT IS STILL CONSTRUCTED. fbc emits a '_GLOBAL__I' and a
'' '_GLOBAL__D' carrying GCC's constructor and destructor attributes, runs the globals
'' in DECLARATION order in the first and in EXACT REVERSE in the second -- including
'' the reversal within an array.
''
'' Without them the descriptor was uninitialised for the whole program, and the first
'' assignment through it freed whatever was in the image at that address.
dim shared as HasStr sh1
dim shared as HasStr sh2
dim shared as HasStr shArr( 0 to 1 )

'' NOT DONE: a STATIC local. fbc constructs one LAZILY -- a guard flag and an atexit
'' thunk, measured -- and putting one in the module initialiser would run it before the
'' procedure it belongs to was ever called.

'' AN ARRAY OF T IS N OBJECTS, and 'new T' is one more. Both were allocated and
'' constructed NOTHING: three uninitialised descriptors, and the first assignment
'' through one freed whatever the stack held.
''
'' Elements are constructed forward and destroyed in REVERSE, which is what 'delete[]'
'' was measured doing.
''
sub allocs( )
    dim as HasStr arr( 0 to 2 )
    arr( 1 ).s = "x"
    dim as HasStr ptr p = new HasStr
    delete p
end sub
allocs( )

sub use( )
    dim as HasStr h
    h.s = "x"
    dim as HasArr q
    dim as Pod p
    p.x = 1
    dim as DerivedW d
end sub
use( )
