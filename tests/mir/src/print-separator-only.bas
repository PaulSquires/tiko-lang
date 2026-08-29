'' A SEPARATOR IS CONSUMED BY THE ITEM IMMEDIATELY BEFORE IT, and one with no item
'' before it PRINTS ON ITS OWN. Measured, and it is uniform:
''
''     print ,       fb_PrintVoid( 0, 2 )
''     print ;       fb_PrintVoid( 0, 0 )
''     print ,,      fb_PrintVoid( 0, 2 ) twice
''     print ;;      fb_PrintVoid( 0, 0 ) twice
''     print ,;      fb_PrintVoid( 0, 2 ), fb_PrintVoid( 0, 0 )
''     print ;,      fb_PrintVoid( 0, 0 ), fb_PrintVoid( 0, 2 )
''     print 1,,     fb_PrintLongint( 0, 1, 2 ), fb_PrintVoid( 0, 2 )
''     print 1,;     fb_PrintLongint( 0, 1, 2 ), fb_PrintVoid( 0, 0 )
''     print ,1      fb_PrintVoid( 0, 2 ), fb_PrintLongint( 0, 1, 1 )
''     print ,,1     fb_PrintVoid( 0, 2 ) twice, fb_PrintLongint( 0, 1, 1 )
''     print 1,2,    fb_PrintLongint( 0, 1, 2 ), fb_PrintLongint( 0, 2, 2 )
''
'' -- the last one is the check: a TRAILING separator after an item is that item's
'' mask and adds nothing of its own.
''
'' The loop skipped every separator outright, so a print whose list is ONLY separators
'' emitted NOTHING AT ALL -- and counted as lowered, because nothing declined.
'' string/print_using.bas writes 'print #(1), ,' for a blank tabbed field, and the
'' file lowered clean with the statement missing from it.
''
'' Found by comparing the runtime entry points fbc calls with the ones tiko-lang calls,
'' over the corpus files that already lower FULLY -- the same differential that the
'' no-caller audit of the runtime table complements.
print ,
print ;
print ,,
print ;;
print ,;
print ;,
print 1,,
print 1,;
print ,1
print ,,1
print 1,2,
print
print 1
