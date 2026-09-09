'' A BYVAL UDT ARGUMENT TO 'threadcall', which fbc describes with a COMPOSITE
'' descriptor: the code 12, then the field COUNT, then one description per field,
'' recursively -- and the ADDRESS arrives ONCE, after the whole run. All of it measured
'' on win64, 2026-09-09, with 'fbc64 -r'; the lines below are that C output verbatim,
'' one probe per shape.
''
''     type One   : z as long : end type
''     type Two   : p as short : q as short : end type
''     type Three : a as Two : b as double : c as long : end type
''     type Deep  : x as One : y as integer : end type
''     type PtrF  : p as any ptr : q as byte : end type
''
''     sOne( o1 )    fb_ThreadCall( &SONE,   0, 0ll, 1,  6,                    &O1 )
''     sTwo( t2 )    fb_ThreadCall( &STWO,   0, 0ll, 1,  12,2, 4, 4,           &T2 )
''     sThree( t3 )  fb_ThreadCall( &STHREE, 0, 0ll, 1,  12,3, 12,2,4,4, 11,6, &T3 )
''     sDeep( dd )   fb_ThreadCall( &SDEEP,  0, 0ll, 1,  12,2, 6, 8,           &DD )
''     sPtrF( pf )   fb_ThreadCall( &SPTRF,  0, 0ll, 1,  12,2, 13, 2,          &PF )
''
'' THE COLLAPSE IS OF THE CODE, NOT OF THE DESCRIPTOR. A UDT with exactly ONE field
'' takes THAT FIELD'S code -- 'One' is 6, not '12,1,6' -- but when the single field is
'' itself a MULTI-field UDT the code collapses to 12 and the fields then written out
'' are the OUTER type's, count 1:
''
''     type OneUdt : only as Two    : end type    12,1, 12,2,4,4
''     type OneOne : only as OneUdt : end type    12,1, 12,1, 12,2,4,4
''
'' Reading it as "collapse the whole descriptor" writes '12,2,4,4' for OneUdt, which is
'' a different struct.
''
'' 'EXTENDS' DOES NOT FLATTEN -- the base is field number one, described like any other
'' UDT field: 'type Derived extends Two : d1 as double : end type' is
'' '12,2, 12,2,4,4, 11'. HANDOFF recorded the opposite; the probe says otherwise.
''
'' A 'zstring * N' FIELD IS DESCRIBED AS ONE UBYTE -- '12,2, 3, 6' for
'' '{ zs as zstring * 8, n as long }'. The runtime builds an ffi_type out of the run,
'' so eight bytes are described as one and the marshalled copy is short. That is an fbc
'' DEFECT and it is matched on purpose: the ground truth is fbc executed, and diverging
'' would make a tiko-built program behave differently from an fbc-built one for no
'' measurement's sake.
''
'' A VARIABLE PASSES ITS OWN ADDRESS and an rvalue gets a temporary: measured,
'' 'threadcall sTwo( mkTwo( ) )' is '..., 12ll, 2ll, 4ll, 4ll, &TMP$10$0'.
''
'' WHAT fbc REFUSES, each measured as its error 288 and each a DECLINE here: a UNION
'' member, an ANONYMOUS union, a BITFIELD, a fixed ARRAY field, a var-len STRING field,
'' a 'string * N' or 'wstring * N' field, a BOOLEAN field, and a type declared
'' 'field = N'. None of them is in this file.
''
'' Checked against fbc's emitted C and not against a run: the runtime's fb_ThreadCall
'' is libffi, which this build does not link, so threadcall does not execute its body
'' in this environment.

type One
	z as long
end type

type Two
	p as short
	q as short
end type

type Three
	a as Two
	b as double
	c as long
end type

type Deep
	x as One
	y as integer
end type

type PtrF
	p as any ptr
	q as byte
end type

type Derived extends Two
	d1 as double
end type

type OneUdt
	only as Two
end type

type OneOne
	only as OneUdt
end type

type ZsF
	zs as zstring * 8
	n as long
end type

sub sOne( byval o as One )
end sub

sub sTwo( byval t as Two )
end sub

sub sThree( byval t as Three )
end sub

sub sDeep( byval d as Deep )
end sub

sub sPtrF( byval p as PtrF )
end sub

sub sDer( byval d as Derived )
end sub

sub sOneUdt( byval o as OneUdt )
end sub

sub sOneOne( byval o as OneOne )
end sub

sub sZs( byval z as ZsF )
end sub

function mkTwo( ) as Two
	dim as Two t
	return t
end function

dim as One o1
dim as Two t2
dim as Three t3
dim as Deep dd
dim as PtrF pf
dim as Derived dv
dim as OneUdt ou
dim as OneOne oo
dim as ZsF zf
dim as any ptr h

h = threadcall sOne( o1 )
h = threadcall sTwo( t2 )
h = threadcall sThree( t3 )
h = threadcall sDeep( dd )
h = threadcall sPtrF( pf )
h = threadcall sDer( dv )
h = threadcall sOneUdt( ou )
h = threadcall sOneOne( oo )
h = threadcall sZs( zf )
h = threadcall sTwo( mkTwo( ) )
