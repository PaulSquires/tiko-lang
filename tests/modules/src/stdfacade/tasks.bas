'' std/tasks, a real module: a generic Channel, a WaitGroup, a procedure -- and 'spawn' and
'' 'select channel', which lower to std/tasks' own Spawn and Select* procedures: no header.
'' Built -mt: the goroutine runtime refuses the single-threaded one.
#import "std/tasks"
private sub Producer( byval ch as tasks.Channel( of long ) )
    ch.Send( 42 )
    ch.Close( )
end sub
dim as tasks.Channel( of long ) ch = tasks.Channel( of long )( 1 )
spawn Producer( ch )
dim as long v, got
while ch.Receive( v )
    got += v
wend
dim as tasks.WaitGroup wg
wg.Add( 1 ) : wg.Done( ) : wg.Wait( )
print got; wg.Count( ); " "; tasks.GoroutineCount( ) >= 0
dim as tasks.Channel( of long ) c2 = tasks.Channel( of long )( 1 )
c2.Send( 7 )
select channel
    case receive v from c2 : print "got"; v
    case timeout 1000      : print "timeout"
end select
