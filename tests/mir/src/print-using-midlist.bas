'' 'using' CAN APPEAR AFTER THE ITEM LIST HAS STARTED, and SPC and TAB can appear
'' INSIDE a using run. Neither was handled, and both print_using corpus files write
'' both.
''
'' 'print "ghi"; ", "; using "&"; "jkl"' prints the first two items PLAINLY and the rest
'' through the format -- measured:
''
''   fb_PrintString( 0, vr$0, 0 );      <- before the using
''   fb_PrintString( 0, vr$1, 0 );
''   fb_PrintUsingInit( vr$2 );
''   fb_PrintUsingStr( 0, vr$3, -2147483647 );
''   fb_PrintUsingEnd( 0 );
''
'' -- so the POSITION of the 'using' is its whole meaning, and it is recorded in the
'' item list rather than on the statement. Only the LEADING form was read, so a later
'' 'using' parsed as an expression naming something called 'using' and the statement
'' declined.
''
'' SPC AND TAB PRINT THE ORDINARY WAY INSIDE A USING RUN. Measured: 'print using "&&";
'' "a"; tab(10); "b"' emits fb_PrintTab BETWEEN the two formatted items, not a formatted
'' one -- they have no using entry point at all, so the scratch pass refused them and
'' took the whole statement with it. They do not count as the last item either: the "a"
'' before the tab still carries 0 and the "b" after it carries the end-of-line mask.
print "ghi"; ", "; using "&"; "jkl"
print using "&"; "abc"
print "x"; using "#.##"; 1.5

print using "&&"; "a"; tab(10); "b"
print "x"; spc(5); "y"
print "p"; using "&"; "q"; tab(20); "r"
