'' T79: 'case timeout' beside 'case else' is fbc's error 365, at 'end select'.
#import "std/tasks"
'' (was fb/select.bi)
dim a as tasks.Channel( of long ) = tasks.Channel( of long )( 1 )
dim as long v
select channel
    case receive v from a : print v
    case timeout 10       : print "t"
    case else             : print "e"
end select
