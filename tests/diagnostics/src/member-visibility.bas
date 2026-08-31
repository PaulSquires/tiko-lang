'' 'private:' AND 'protected:' INSIDE A TYPE -- fbc error 202, "Illegal member access".
'' A PRIVATE member may be named only from inside its own type's procedures; a PROTECTED
'' one from those and from a DERIVED type's.
''
'' A PASS OF ITS OWN, after Check, and that is the whole reason it exists. The question
'' needs two things at once: WHICH MEMBER -- which only Check knows, because a field means
'' nothing until its base has a type -- and WHICH PROCEDURE ENCLOSES THE USE, which Check
'' does not track and Resolve cannot answer for a field.
''
'' A CONST OR A STATIC INSIDE A TYPE BODY IS A MEMBER TOO: 'T.SECRET' from outside is the
'' same error as a private field, and only fields and procedures were being marked.
type T
    open_ as integer
    private:
    hidden as integer
    const SECRET = 123
    declare sub hiddenMethod( )
    '' A nested ENUM is a member too -- structs/obj_access_const.bas writes
    '' 'Test.first.one' over a private one, and fbc answers error 202.
    enum Hidden_
        ONE = 1
    end enum
    protected:
    shared_ as integer
end type

sub T.hiddenMethod( )
    '' From inside its own type, every member is reachable.
    hidden = 1
    shared_ = 2
end sub

type Derived extends T
    declare sub reach( )
end type

sub Derived.reach( )
    '' PROTECTED reaches down the derivation chain...
    shared_ = 3
end sub

dim shared as T x
dim shared as Derived d

'' -- refused ------------------------------------------------------------------
sub outside( )
    x.hidden = 1
    x.shared_ = 2
    dim as integer n = T.SECRET
    d.shared_ = 3
    dim as integer e = T.Hidden_.ONE
end sub

'' -- accepted -----------------------------------------------------------------
sub alsoOutside( )
    x.open_ = 1
    d.open_ = 2
end sub

'' -- A PRIVATE CONSTRUCTOR OR DESTRUCTOR IS REACHED BY DECLARING THE TYPE ------
''
'' fbc's error 204, "The default constructor has no public access", and 206 for the
'' destructor. No member access is written anywhere: 'dim as T x' CALLS T's default
'' constructor and its destructor.
''
'' THE WHOLE OVERLOAD CHAIN, not its head: fb/comptr.bi's ComInit declares a PRIVATE copy
'' constructor first and a PUBLIC default one after it. What a bare declaration calls is
'' the constructor that REQUIRES NO ARGUMENT.
type PrivCtor
    dummy as integer
    private:
    declare constructor( )
end type

constructor PrivCtor( )
end constructor

type PrivDtor
    dummy as integer
    private:
    declare destructor( )
end type

destructor PrivDtor( )
end destructor

type PubDefault
    dummy as integer
    private:
    declare constructor( byref rhs as PubDefault )
    public:
    declare constructor( byval mode as integer = 0 )
end type

constructor PubDefault( byref rhs as PubDefault )
end constructor

constructor PubDefault( byval mode as integer )
end constructor

'' -- refused ------------------------------------------------------------------
sub structorsRefused( )
    dim as PrivCtor a
    dim as PrivDtor b
    dim as PrivCtor arr( 0 to 1 )
end sub

'' -- accepted -----------------------------------------------------------------
sub structorsAccepted( )
    '' A defaulted parameter still makes it the DEFAULT constructor, and it is public.
    dim as PubDefault ok_
    '' A POINTER constructs nothing.
    dim as PrivCtor ptr p
end sub
