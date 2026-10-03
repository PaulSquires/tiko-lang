'' T75: '#cmdline "-mt"' after the '#import' reaches the imported module too. The
'' modules were built before the unit's own pass met the '#cmdline', so std/tasks was
'' compiled single-threaded.
#import "std/tasks"
#cmdline "-mt"
sub Square( byval n as long, byval results as tasks.SendChan( of long ) )
    results.Send( n * n )
end sub
dim results as tasks.Channel( of long ) = tasks.Channel( of long )( 4 )
for i as long = 1 to 3
    spawn Square( i, results )
next
dim as long total = 0, v
for i as long = 1 to 3
    results.Receive( v )
    total += v
next
print total
