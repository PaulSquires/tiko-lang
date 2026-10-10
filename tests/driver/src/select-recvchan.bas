'' 'select channel' over a RecvChan or a SendChan view -- fbc's error 340: the desugaring
'' calls SelectAddRecv( of T ) and its kin, whose parameter is a 'Channel( of T )'.
'' Measured on fbc-modern 1.20: 340 on lines 11 and 12, and line 13 over the Channel
'' itself runs. tiko reported nothing and the link failed on 'selectaddrecv<6>'.
#import "std/tasks"
'' (was fb/select.bi)
using tasks
dim as Channel( of long ) ch = Channel( of long )( 1 )
dim as RecvChan( of long ) rc = ch
dim as long v
select channel : case receive v from rc : print v : end select
select channel : case receive from rc : print "d" : end select
select channel : case receive v from ch : print v : case else : end select
