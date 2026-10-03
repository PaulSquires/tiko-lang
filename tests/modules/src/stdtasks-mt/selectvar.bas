'' T77: a channel declared with 'var' can be used in 'select channel'. The select
'' generics infer their type argument from the channel, and a 'var' had no type yet.
#import "std/tasks"
#cmdline "-mt"
#include once "fb/select.bi"
var a = tasks.Channel( of long )( 1 )
a.Send( 3 )
dim as long v
select channel
    case receive v from a : print "got"; v
    case timeout 1000     : print "timeout"
end select
