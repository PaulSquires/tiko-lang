dim as zstring * 32+1 aa, bb, cc
dim as zstring ptr pa, pb, pc
pa = @aa : pb = @bb : pc = @cc
dim as integer condtrue = -1, condfalse = 0
*pa = "1234" : *pb = "5678"
*pc = iif( -1, *pa, *pb )
print *pc
*pc = iif( condfalse, *pa, *pb )
print *pc
print *pc = *pa + *pb, *pc = *pb
*pc = iif( condtrue, hex( 123 ), hex( 456 ) )
print *pc
*pc = *pa + *pb
print *pc, len( *pc )
