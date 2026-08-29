'' A CAPTURING LAMBDA INSIDE A GENERIC, and the same lambda in an ordinary procedure
'' beside it.
''
'' The closure TYPE is synthesised when the N_CLOSURE node inside the body is walked
'' -- the only point where the captured names are in scope -- and the hoisted invoke
'' procedure's prologue reads that type's '__CAP_' fields through its own receiver.
'' The generic instantiation walked the hoisted lambdas BEFORE the body, so the
'' invoke body named a type that did not exist yet and every
'' 'var byref <name> = *__tko_cl.__CAP_<NAME>' had no reference to bind.
''
'' Measured against fbc, which builds one closure struct per instantiation:
''
''     struct $25L...E { int32* __CAP_TOTAL; int32 __CAP_BIAS; };
''     *(int32**)&TMP$3$1 = &TOTAL$1;
''     *(int32*)((uint8*)&TMP$3$1 + 8ll) = BIAS$1;
sub ForEach2( of T, F )( byval x as T, byref f as F )
    f( x )
end sub

function WithCapture( of T )( byval x as T ) as T
    dim as long bias = 10
    dim as long total = 0
    ForEach2( x, sub[ byref total, byval bias ]( byval v as long )
        total = v + bias
    end sub )
    return total
end function

function Plain( byval x as long ) as long
    dim as long bias = 10
    dim as long total = 0
    ForEach2( x, sub[ byref total, byval bias ]( byval v as long )
        total = v + bias
    end sub )
    return total
end function

print WithCapture( of long )( 5 )
print Plain( 5 )
