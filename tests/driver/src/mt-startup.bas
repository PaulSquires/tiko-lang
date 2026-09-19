'' A '-mt' program on the MinGW target. Until fbrt0.o was named on the link line,
'' built with 'tiko -target win64 -mt' this crashed with 0xC0000005 before printing
'' anything: fb_hRtInit never ran, and the first string lock entered a CRITICAL_SECTION
'' nobody had initialised. fbc prints the one line.
print "a"
