'' 'SELECT CHANNEL' LINKS. Every form below failed at the link on
''
''     undefined symbol: FB::SELECTADDRECV(FB::SELECTCTX&, int, FB::CHANNEL&, void&)
''
'' -- the TEMPLATE, called with T never inferred. Three causes, each needed:
''
''   - The desugaring (parser/selchan.bas) built its calls in the PAREN-LESS shape,
''     'FB.SelectAddRecv sc, 0, c, v', and a generic called that way infers nothing --
''     fbc refuses the same spelling with error 340.
''   - Its channel copy is 'var c = ch', and a VAR has no type until Check, which runs
''     after type arguments are inferred.
''   - 'case receive from ctx.Done( )' makes that 'var c = ctx.Done( )': a METHOD's
''     result, and over a CancelContext an INHERITED one.
''
'' fbc's own concurrency/sched.bas and sync.bas are the shapes; they link and pass now.

#include once "fb/channel.bi"
#include once "fb/sync.bi"
#include once "fb/select.bi"
using FB

sub Selector( byval ctx as Context )
	dim never as Channel( of long )
	dim as long v
	select channel
		case receive v from never     : print "never"
		case receive from ctx.Done( ) : print "done"
		case timeout 10               : print "timeout"
	end select
end sub

dim ch as Channel( of long ) = Channel( of long )( 1 )
dim as long v = 0
ch.TrySend( 7 )
select channel
	case receive v from ch : print "recv"; v
	case else              : print "else"
end select
select channel
	case send 2 to ch : print "sent"
	case else         : print "full"
end select

dim c3 as CancelContext = WithCancel( Context( ) )
c3.Cancel( )
select channel
	case receive from c3.Done( ) : print "cancelled"
	case else                    : print "live"
end select

Selector( Context( ) )
