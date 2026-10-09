'' A procedure DECLARED inside 'extern "c"' and DEFINED after the block. They are one
'' procedure, and fbc names the body by the declaration -- measured with -gen gcc:
''
''     static void fwdCase( int32 )     -- 'private sub FWDCASE' after the block
''     void fwdPub( int32 )             -- 'sub fwdpub', not private
''
'' tiko named the body by its own line, FWDCASE, while every call named 'fwdCase', so
'' the link failed on an undefined symbol -- and under -O2 the private body, now
'' referenced by nothing, was deleted outright. tiko-rt's thread/sched.bas forward-
'' declares tkort_hAddWorker this way because it and the worker procedure call each
'' other. Output identical to fbc-modern's.

extern "c"
    declare sub fwdCase( byval n as long )
    declare sub fwdPub( byval n as long )
end extern

sub caller( byval n as long )
    if n > 0 then
        fwdCase( n - 1 )
        fwdPub( n )
    end if
end sub

private sub FWDCASE( byval n as long )
    print "case "; str( n )
    caller( n )
end sub

sub fwdpub( byval n as long )
    print "pub "; str( n )
end sub

caller( 2 )
