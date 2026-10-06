#include "fbc-int/array.bi"
type TS
	__ as integer
	static a2(any,any) as integer
end type
static TS.a2(any,any) as integer
sub s
	static a1(any) as integer
	dim p as FBC.FBARRAY ptr = FBC.ArrayDescriptorPtr( a1() )
	print p->element_len; p->dimensions; p->flags
	static a0() as integer
	dim q as FBC.FBARRAY ptr = FBC.ArrayDescriptorPtr( a0() )
	print q->element_len; q->dimensions; q->flags
end sub
s
dim x as TS
dim r as FBC.FBARRAY ptr = FBC.ArrayDescriptorPtr( x.a2() )
print r->element_len; r->dimensions; r->flags
dim shared sh(any) as integer
dim t as FBC.FBARRAY ptr = FBC.ArrayDescriptorPtr( sh() )
print t->element_len; t->dimensions; t->flags
