'' A typedef chain whose last link is declared below its use -- fbc's error 71 on the
'' refused lines.
type T as FWD
declare function f( ) byref as T
dim x as T                                 '' 71
sub s( byval a as T )                      '' 71
end sub
print f( )                                 '' 71
dim p as any ptr = @f( )                   '' fine
type FWD as integer
dim y as T                                 '' fine: complete by now
print f( )                                 '' fine
