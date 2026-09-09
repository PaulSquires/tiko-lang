'' 'ON ERROR GOTO label' installs a handler and every -e check jumps to it. Measured
'' from fbc's own C on this shape:
''
''     fb_ErrorSetHandler( &&label$2 );
''     void* vr$5 = fb_ArraySngBoundChkEx( ... );
''     if( vr$5 == 0ll) goto label$3;
''     goto *vr$5;
''
'' The handler is the ADDRESS OF A LABEL -- GCC's '&&label', LLVM's blockaddress -- and
'' the runtime hands it back from a failed check for the caller to jump to.
''
'' RESUME AND RESUME NEXT ARE NOT PART OF THIS by decision, so fb_ErrorThrowAt's third
'' and fourth arguments stay null -- which is what fbc emits for a program using neither.
sub risky( )
    on error goto oops
    dim as integer a(0 to 2)
    dim as integer i = 9
    a(i) = 1
    print "no error"
    goto done
    oops:
    print "caught"
    done:
end sub

risky( )
