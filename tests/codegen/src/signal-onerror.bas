' abort( ) with an ON ERROR handler: the handler runs (TK-004: the error context exists, nothing allocated).
extern "C"
    declare sub c_abort alias "abort" ( )
end extern
on error goto caught
print "before"
c_abort( )
print "not reached"
end 0
caught:
print "caught"; err
end 3
