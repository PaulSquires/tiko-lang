'' AN OPERATOR INVOKED IMPLICITLY IS STILL A MEMBER ACCESS -- fbc error 202 -- and so is
'' an aggregate initialiser or a let( ) unpacking that fills a hidden field, and an enum
'' constant declared inside a private or protected section. A constructor reached through
'' 'new' is fbc's 204 (the default one) or 205 (the copy), the same refusal. Every line
'' below was measured: the refused ones name a private or protected member, and the
'' accepted ones are the same shape with the member public or the use inside the type.
type SelfOps
    as integer i
    private:
    declare operator +=( byref as SelfOps )
    declare operator @( ) as SelfOps ptr
end type
operator SelfOps.+=( byref other as SelfOps )
end operator
operator SelfOps.@( ) as SelfOps ptr
    operator = @this
end operator
type PublicOps
    as integer i
    declare operator +=( byref as PublicOps )
    declare operator @( ) as PublicOps ptr
end type
operator PublicOps.+=( byref other as PublicOps )
end operator
operator PublicOps.@( ) as PublicOps ptr
    operator = @this
end operator
type Alloc
    as integer i
    protected:
    declare operator new( byval as uinteger ) as Alloc ptr
    declare operator delete( byval as Alloc ptr )
end type
operator Alloc.new( byval size as uinteger ) as Alloc ptr
    operator = 0
end operator
operator Alloc.delete( byval p as Alloc ptr )
end operator
type Conv
    as integer i
    private:
    declare operator cast( ) as integer
end type
operator Conv.cast( ) as integer
    operator = 0
end operator
type Counter
    public:
        n as integer
        declare operator next( byref cond as Counter, byref stp as Counter ) as integer
        declare operator step( byref stp as Counter )
    protected:
        declare operator for( byref stp as Counter )
end type
operator Counter.for( byref x as Counter )
end operator
operator Counter.next( byref cond as Counter, byref stp as Counter ) as integer
    return 0
end operator
operator Counter.step( byref stp as Counter )
end operator
type HiddenCtor
    as integer i
    private:
    declare constructor( )
end type
constructor HiddenCtor( )
end constructor
type HiddenCopy
    as integer i
    declare constructor( )
    private:
    declare constructor( byref as HiddenCopy )
end type
constructor HiddenCopy( )
end constructor
constructor HiddenCopy( byref rhs as HiddenCopy )
end constructor
type HiddenField
    protected:
    as integer i
end type
type PublicField
    as integer i
end type
type Owner
    as integer i
    private:
    enum E
        MYCONST = 123
    end enum
    public:
    declare sub reachable( )
end type
sub Owner.reachable( )
    dim as integer n = MYCONST
end sub
type Heir extends Owner
    declare sub blocked( )
end type
sub Heir.blocked( )
    dim as integer n = MYCONST
end sub
dim as SelfOps so
dim as PublicOps po
dim as Conv cv
dim as Counter ct
dim as integer n
so += so
po += po
dim as SelfOps ptr sp1 = @so
dim as PublicOps ptr pp1 = @po
dim as Alloc ptr ap = new Alloc
delete ap
n = cv
dim as integer n2 = cv
dim as Conv cv2 = cv
for i as Counter = ct to ct step ct
next
dim as HiddenCtor ptr hp = new HiddenCtor
dim as HiddenCtor ptr hv = new HiddenCtor[5]
dim as HiddenCopy hc
dim as HiddenCopy ptr cp = new HiddenCopy( hc )
dim as HiddenField hf = ( 3 )
dim as HiddenField hf2 = type<HiddenField>( 3 )
dim as PublicField pf = ( 3 )
dim as HiddenField hf3
let( n ) = hf3
dim as PublicField pf3
let( n ) = pf3
print Owner.MYCONST
