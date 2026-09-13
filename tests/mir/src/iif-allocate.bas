'' ALLOCATE, CALLOCATE AND REALLOCATE ARE 'any ptr'. Check gave them no type, so an 'iif'
'' whose arms are both one of them had no type either, and the declaration or assignment
'' it initialised was DECLINED -- the variable kept whatever the stack held. AfxNova's
'' DWSTRING.ResizeBuffer writes exactly
''
''     DIM pNewBuffer AS WSTRING PTR = IIF(bClear, CAllocate(...), Allocate(...))
''
'' so every DWSTRING started with a null buffer and PsCalendar crashed writing its first
'' terminator. fbc-modern types all four as ANY PTR; see the .test for what it prints.
dim as boolean b = true
dim as wstring ptr p1 = iif( b, callocate( 8 ), allocate( 8 ) )
dim as any ptr p2
p2 = iif( b, callocate( 2, 4 ), allocate( 8 ) )
dim as any ptr p3 = iif( not b, allocate( 4 ), reallocate( p2, 16 ) )
dim as zstring ptr p4 = iif( b, callocate( 4 ), p3 )
dim as long ptr pl = cast( long ptr, p1 )
pl[0] = 12
print p1 <> 0; p2 <> 0; p3 <> 0; p4 <> 0; pl[0]
