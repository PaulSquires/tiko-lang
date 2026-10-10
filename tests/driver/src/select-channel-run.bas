'' WHAT 'SELECT CHANNEL' DOES, not only that it links -- select-channel-link.bas is that.
'' Every case form, and every outcome that does not depend on a scheduler: a ready
'' receive, a ready send, the discard form, ELSE when nothing is ready, TIMEOUT when
'' nothing becomes ready, a receive from a CLOSED channel, a case over a NIL channel,
'' which is never ready, and a send value that is an expression rather than a variable.
'' Each select has exactly one case that can fire, so the choice among several ready
'' ones -- a random one, by design -- is never asked. build/goldenrun.sh runs it beside
'' fbc; the output below is fbc-modern's, measured.
''
''   recv 7
''   sent; count 1
''   discarded; count 0
''   else
''   timeout
''   closed: v unchanged 42
''   nil: else
''   sent 11; got 11
''   order 1 2 3

#import "std/tasks"
'' (was fb/select.bi)
using tasks
dim ch as Channel( of long ) = Channel( of long )( 1 )
dim as long v = 0

'' a ready receive
ch.TrySend( 7 )
select channel
	case receive v from ch : print "recv"; v
	case else              : print "else"
end select

'' a ready send
select channel
	case send 5 to ch : print "sent; count"; ch.Count( )
	case else         : print "full"
end select

'' the discard form takes the value and throws it away
select channel
	case receive from ch : print "discarded; count"; ch.Count( )
	case else            : print "else"
end select

'' nothing ready: else
select channel
	case receive v from ch : print "recv"; v
	case else              : print "else"
end select

'' nothing ready, no else: the timeout fires
select channel
	case receive v from ch : print "recv"; v
	case timeout 20        : print "timeout"
end select

'' a closed channel is ready, and gives nothing
dim cl as Channel( of long ) = Channel( of long )( 1 )
cl.Close( )
v = 42
select channel
	case receive v from cl : print "closed: v unchanged"; v
	case timeout 1000      : print "timeout"
end select

'' a nil channel -- never constructed with a capacity -- is never ready
dim nilc as Channel( of long )
select channel
	case receive v from nilc : print "nil: recv"
	case else                : print "nil: else"
end select

'' a send value that is an expression, received back
dim as long base_ = 5
select channel
	case send base_ * 2 + 1 to ch : print "sent"; base_ * 2 + 1;
	case else                     : print "full"
end select
dim as long got
ch.TryReceive( got )
print "; got"; got

'' channel expressions are evaluated in source order, once each
dim shared as long seq
function Pick( byref c as Channel( of long ), byval n as long ) byref as Channel( of long )
	seq += 1
	print iif( seq = 1, "order", "" ); n;
	return c
end function
select channel
	case receive v from Pick( ch, 1 ) : print " recv"
	case receive v from Pick( ch, 2 ) : print " recv"
	case send 1 to Pick( nilc, 3 )    : print " sent"
	case else                         : print
end select
