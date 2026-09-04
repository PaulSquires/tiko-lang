'' arrayquery-parity.bas -- LBOUND/UBOUND, ArrayLen/Size, GetDesc, ResetDesc
'' and the two bound-table calculators: eight entry points.
''
'' NEEDS-GEN-LLVM
''
'' THE ASYMMETRIES THAT LOOK LIKE BUGS AND ARE NOT:
''
''   A missing dimension gives LBOUND 0 and UBOUND -1. Making them agree would
''   break every `lbound > ubound` unallocated-array test in FB.
''
''   Dimension 0 queries the dimTb. LBOUND(a,0) is 1 unconditionally -- even
''   for an unallocated array, even for a NULL-data descriptor. UBOUND(a,0) is
''   the dimension count when allocated and 0 when not, so it too drops below
''   LBOUND's 1 exactly when the array is unallocated.
''
''   ResetDesc KEEPS element_len and dimensions and masks flags to three bits.
''   The descriptor is inspected field by field below, before and after.
''
''   hArrayCalcDiff takes UNSIGNED dimensions; a one-dimensional array makes
''   `dimensions - 1` zero and a naive descending loop underflow. Asked here
''   with 1, 2, 3 and 0 dimensions.
#include once "fbc-int/array.bi"

extern "c"
	declare function pCalcElem alias "fb_hArrayCalcElements" ( byval d as uinteger, byval lb as integer ptr, byval ub as integer ptr ) as uinteger
	declare function pCalcDiff alias "fb_hArrayCalcDiff" ( byval d as uinteger, byval lb as integer ptr, byval ub as integer ptr ) as integer
end extern

extern "rtlib"
	declare function pLen alias "fb_ArrayLen" ( byval a as any ptr ) as uinteger
	declare function pSize alias "fb_ArraySize" ( byval a as any ptr ) as uinteger
	declare function pDesc alias "fb_ArrayGetDesc" ( byval a as any ptr ) as any ptr
	declare function pLB alias "fb_ArrayLBound" ( byval a as any ptr, byval d as integer ) as integer
	declare function pUB alias "fb_ArrayUBound" ( byval a as any ptr, byval d as integer ) as integer
	'' NOT pReset: PRESET is a FreeBASIC graphics statement, and the clash is
	'' reported as a duplicated definition rather than a keyword error.
	declare sub pResetDesc alias "fb_ArrayResetDesc" ( byval a as any ptr )
end extern

dim as long i = any, k = any
dim as integer lb(0 to 3) = { 0, 0, 0, 0 }
dim as integer ub(0 to 3) = { 0, 0, 0, 0 }

print "-- the bound-table calculators, 1..4 dimensions and the zero case"
dim as integer L1(0 to 3) = { 1, -5, 0, 3 }
dim as integer U1(0 to 3) = { 10, 5, 0, 3 }
for k = 0 to 3
	for i = 0 to k
		lb(i) = L1(i) : ub(i) = U1(i)
	next
	print "d="; k + 1; " elems="; pCalcElem( k + 1, @lb(0), @ub(0) ); _
	      " diff="; pCalcDiff( k + 1, @lb(0), @ub(0) )
next
print "d=0 diff="; pCalcDiff( 0, @lb(0), @ub(0) )
'' Every lower bound zero: the displacement must come out 0 for any rank.
for k = 0 to 3
	for i = 0 to 3
		lb(i) = 0 : ub(i) = 4
	next
	print "zero-lb d="; k + 1; " elems="; pCalcElem( k + 1, @lb(0), @ub(0) ); _
	      " diff="; pCalcDiff( k + 1, @lb(0), @ub(0) )
next

print "-- real arrays: fixed, dynamic allocated, dynamic erased"
dim as long fixed1(1 to 10)
dim as long fixed3(-2 to 2, 0 to 3, 5 to 7)
redim as double dyn1(3 to 9)
redim as double dyn2(0 to 4, -1 to 1)

sub report( byval a as any ptr, byval nm as zstring ptr )
	print *nm; ": len="; pLen(a); " size="; pSize(a); " desc<>0="; iif(pDesc(a) <> 0, 1, 0)
	dim as long d = any
	for d = -1 to 5
		print "   dim"; d; " lb="; pLB(a, d); " ub="; pUB(a, d)
	next
end sub

report( FBC.ArrayDescriptorPtr( fixed1() ), @"fixed1" )
report( FBC.ArrayDescriptorPtr( fixed3() ), @"fixed3" )
report( FBC.ArrayDescriptorPtr( dyn1() ), @"dyn1" )
report( FBC.ArrayDescriptorPtr( dyn2() ), @"dyn2" )

erase dyn1
print "after ERASE:"
report( FBC.ArrayDescriptorPtr( dyn1() ), @"dyn1-erased" )

print "-- GetDesc is the identity"
print "same="; iif( pDesc( FBC.ArrayDescriptorPtr( fixed3() ) ) = FBC.ArrayDescriptorPtr( fixed3() ), 1, 0 )

print "-- ResetDesc: field by field, before and after"
redim as long victim(2 to 8, 1 to 3)
dim as FBC.FBARRAY ptr vd = FBC.ArrayDescriptorPtr( victim() )
print "before: elemlen="; vd->element_len; " dims="; vd->dimensions; _
      " size="; vd->size; " flags="; vd->flags; _
      " lb1="; pLB(vd,1); " ub1="; pUB(vd,1); " lb2="; pLB(vd,2); " ub2="; pUB(vd,2)
pResetDesc( vd )
print "after:  elemlen="; vd->element_len; " dims="; vd->dimensions; _
      " size="; vd->size; " flags="; vd->flags; _
      " lb0="; pLB(vd,0); " ub0="; pUB(vd,0); _
      " lb1="; pLB(vd,1); " ub1="; pUB(vd,1); " lb2="; pLB(vd,2); " ub2="; pUB(vd,2)
print "len="; pLen(vd); " size="; pSize(vd)

print "-- NULL descriptor: Len and Size accept it, the accessors do not"
print "len(null)="; pLen(0); " size(null)="; pSize(0); " desc(null)<>0="; iif(pDesc(0) <> 0, 1, 0)

print "done"
