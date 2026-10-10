'' POINTER ARITHMETIC OVER A FIXED-LENGTH STRING steps by its CHARACTER, not by the whole
'' string. Measured with fbc, line for line:  3, 6, 1, -2, 2, 1, "5  5", "cdef".
'' tiko scaled by the string's size (192, 48, 64, ...), and tiko-rt's message buffers --
'' 'snprintf( @msg + pos_, ... )' over a 'zstring * N' -- were written past their end:
'' every array bounds error in a tiko-built runtime was a segmentation violation.
dim as zstring * 64 z
dim as wstring * 8 w
dim as integer n = 3
var pz = @z
var pw = @w
print cint( cast( ubyte ptr, @z + n ) - cast( ubyte ptr, @z ) )
print cint( cast( ubyte ptr, @w + n ) - cast( ubyte ptr, @w ) )
print cint( cast( ubyte ptr, pz + 1 ) - cast( ubyte ptr, pz ) )
print cint( cast( ubyte ptr, pw - 1 ) - cast( ubyte ptr, pw ) )
var q = pz
q += 2
print cint( cast( ubyte ptr, q ) - cast( ubyte ptr, pz ) )
q -= 1
print cint( cast( ubyte ptr, q ) - cast( ubyte ptr, pz ) )
print cint( ( pz + 5 ) - pz ), cint( ( pw + 5 ) - pw )
z = "abcdef"
print pz[2]
