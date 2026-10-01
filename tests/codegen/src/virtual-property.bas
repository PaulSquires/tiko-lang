'' T49: a virtual PROPERTY dispatches through the vptr, as a virtual method does -- getter,
'' setter, indexed, string-valued, unqualified inside a method -- and 'base.P' stays direct.
'' C shows T47's rule for properties: B's virtual P is overridden, B's plain Item is hidden.
type A extends Object
    declare virtual property P( ) as long
    declare virtual property P( byval v as long )
    declare virtual property Item( byval i as long ) as long
    declare virtual property Name( ) as string
    declare function Report( ) as string
    stored as long
end type
property A.P( ) as long : return 1 : end property
property A.P( byval v as long ) : stored = v : end property
property A.Item( byval i as long ) as long : return i : end property
property A.Name( ) as string : return "A" : end property
function A.Report( ) as string
    return "P=" & P & " Name=" & Name     '' unqualified, inside a method
end function

type B extends A
    declare virtual property P( ) as long override
    declare property P( byval v as long ) override
    declare property Item( byval i as long ) as long override
    declare virtual property Name( ) as string override
end type
property B.P( ) as long : return 2 + base.P : end property    '' base.P stays A's
property B.P( byval v as long ) : stored = v * 10 : end property
property B.Item( byval i as long ) as long : return i * 100 : end property
property B.Name( ) as string : return "B" : end property

type C extends B
    declare property P( ) as long override                      '' B's P is virtual: overrides
    declare property Item( byval i as long ) as long            '' B's Item is not: hides
end type
property C.P( ) as long : return 30 : end property
property C.Item( byval i as long ) as long : return -1 : end property

sub Show( byref x as A )
    print "byref A:"; x.P; x.Item( 3 ); " "; x.Name; " | "; x.Report( )
end sub

dim as B bb
dim as A ptr pa = @bb
print "A ptr on B:"; pa->P; pa->Item( 2 ); " "; pa->Name
pa->P = 7
print "setter via A ptr stored:"; bb.stored
Show( bb )
dim as C cc
dim as A ptr pc = @cc
dim as B ptr pb = @cc
print "A ptr on C:"; pc->P; pc->Item( 2 ); "  B ptr on C:"; pb->P; pb->Item( 2 )
dim as A aa
print "plain A:"; aa.P; aa.Item( 2 ); " "; aa.Name
