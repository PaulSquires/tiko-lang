'' TWO SHAPES, both measured against fbc.
''
'' '@somevar' AS A DATA ITEM IS A RELOCATION, and a descriptor entry IS one -- its ref
'' names a global. Measured:
''
''   data @"fOObAR", @mydbl, 5
''   { (int16)-2, (void*)"fOObAR" }, { (int16)-2, (void*)&MYDBL$ },
''   { (int16)1, (void*)"5" }, { (int16)-1, (void*)0ull }
''
'' Refusing it cost far more than the one item: a block with any unfoldable entry emits
'' NOTHING, which leaves the module with no data head at all -- so every DATA and every
'' RESTORE in the file declined too.
''
'' A DISCARDED STRING RESULT IS STILL A CALL, and it is released:
''
''   hex( i )    FBSTRING* vr = fb_HEX_i( (uint32)I ); fb_hStrDelTemp( vr );
''   whex( i )   uint16* vr = fb_WstrHex_i( (uint32)I ); fb_WstrDelete( vr );
''
'' Those callees answer only through the string-DESCRIPTOR path, which the discarded
'' statement never asked for, so nothing was emitted and the statement declined -- while
'' 'dim s as string = hex( i )' beside it lowered.
dim shared as double mydbl
mydata:
data @"fOObAR", @mydbl, 5

restore mydata
dim as any ptr p
read p
print p <> 0

dim as long i = 255
hex( i )
whex( i )
print hex( i )
