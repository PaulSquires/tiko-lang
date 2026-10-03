'' A local named like a CONST or PROCEDURE of the scope its procedure or block was opened in.
'' See tests/diagnostics/outer-value-names.test. Lines marked REFUSED are fbc's error 4.

namespace N
const C1 = 1
sub P2( )
end sub
declare function P3( ) as long
sub Q1 overload( byval a as long )
end sub
sub Q1 overload( byval a as string )
end sub
dim shared as long V1
type A1 as long
function GX( of T )( byval v as T ) as T
	return v
end function

sub s1( )
	dim as long C1 = 2                          '' REFUSED
	dim as long P2 = 2                          '' REFUSED
	dim as long P3 = 2                          '' REFUSED
	dim as long Q1 = 2                          '' REFUSED
	dim as long V1 = 2
	dim as long A1 = 2
	dim as long GX = 2
	dim as long Later = 2
end sub

sub s2( byval c1 as long )                      '' REFUSED
	if c1 then
		static as long p2                       '' REFUSED
	end if
	for p3 as long = 1 to 2                     '' REFUSED
	next
end sub

function g( of T )( byval v as T ) as long
	dim as long C1 = 2
	return C1
end function

type K
	f as long
	declare sub m( byval C1 as long )
end type
sub K.m( byval C1 as long )
	dim as long P2 = C1
end sub

const Later = 3

namespace M
sub s3( )
	dim as long C1 = 2
end sub
end namespace
end namespace

const G1 = 1
function F1( ) as long
	var G1 = 2                                  '' REFUSED
	const F1 = 3                                '' REFUSED
	return 0
end function

scope
	redim as long G1( 2 )                       '' REFUSED
end scope

using N
sub s4( )
	dim as long C1 = 2
end sub
