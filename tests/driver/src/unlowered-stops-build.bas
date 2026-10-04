'' A statement lowering declines. Check accepts 'cast( integer, t )' over a UDT today (fbc's
'' error 20), so this is the shape to use until it does not -- then pick another decline.
type T : a as integer : end type
dim as T t : print "before"
print cast( integer, t )
print "after"
