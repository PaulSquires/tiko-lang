'' 'new zstring' and 'new wstring' have nothing to allocate -- fbc error 28 -- and so do
'' their vector forms; a FIXED one ('new zstring * 10', 'new string * 10') is error 201.
'' 'new string' and 'new integer' are the ordinary uses. 'not p' over a pointer is error
'' 20 (compare it with 0 instead), and so is 'p += 1' over a PROCEDURE pointer, while
'' 'ip += 1' over a data pointer is fine.
sub f( )
end sub
dim ip as integer ptr
dim pp_ as sub( ) = @f
dim n as long
print new integer
print new string
if ip = 0 then end
if not n then end
ip += 1

print new zstring
print new wstring
print new zstring[10]
print new zstring * 10
print new string * 10
if not ip then end
pp_ += 1
