' A plain abort( ) under -exx: the signal handler turns it into runtime error 14 (TK-004 kept this).
extern "C"
    declare sub c_abort alias "abort" ( )
end extern
print "before"
c_abort( )
print "not reached"
