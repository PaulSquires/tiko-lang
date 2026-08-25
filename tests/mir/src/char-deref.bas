dim as zstring * 8 z0 = "123"
dim as wstring * 8 w0 = wstr( "123" )
dim as zstring ptr pz = @z0
dim as wstring ptr pw = @w0
dim as long i = 55
dim as longint ll = 56
dim as double d = 57.0
*pz = i
*pw = i
*pz = ll
*pw = ll
*pz = d
*pw = d
pz[1] = i
pw[1] = i
dim as boolean b1 = (pw[0] = asc( "1" ))
dim as boolean b2 = (pz[0] = asc( "1" ))
dim as boolean b3 = (*pz = "123")
print b1, b2, b3
