'' std/tasks (RFC-0009): a generic Channel, a WaitGroup and a procedure through the facade,
'' beside fb/channel.bi included directly -- a tasks.Channel IS an FB.Channel. Built -mt:
'' the goroutine headers refuse the single-threaded runtime.
#import "std/tasks"
#include once "fb/channel.bi"
private sub Producer( byval ch as FB.Channel( of long ) )
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
