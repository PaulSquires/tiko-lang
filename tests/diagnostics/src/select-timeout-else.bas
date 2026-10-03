'' T79: 'case timeout' beside 'case else' is fbc's error 365, at 'end select'.
#include once "fb/sync.bi"
#include once "fb/select.bi"
dim a as FB.Channel( of long ) = FB.Channel( of long )( 1 )
dim as long v
select channel
    case receive v from a : print v
    case timeout 10       : print "t"
    case else             : print "e"
end select
