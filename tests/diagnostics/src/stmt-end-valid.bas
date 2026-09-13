'' Valid statements draw no undeclared-name error: a single-line IF with ELSE, a PRINT
'' list, the prelude's SLEEP and LOCATE, a colon-separated line, and a runtime procedure
'' (WIDTH) that reaches lowering unbound.
dim as long a = 1, b = 2
if a = 1 then print "one" else print "other"
print a; b
locate 1, 1 : print "x"
if b = 2 then a = 3 : b = 4 end if
dim as long w = width( )
sleep 1
