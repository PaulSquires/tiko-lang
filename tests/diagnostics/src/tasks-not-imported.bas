'' 'spawn' and 'select channel' with std/tasks not imported: one TKO0423, nothing after it.
sub W( byval n as long )
end sub
spawn W( 1 )
dim as long v
select channel
    case timeout 10 : print "t"
end select
