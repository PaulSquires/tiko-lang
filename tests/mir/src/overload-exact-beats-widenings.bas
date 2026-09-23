'' AN EXACT MATCH OUTWEIGHS ANY TWO CONVERSIONS. fbc scores an argument FULL when it
'' matches and HALF less a closeness rank when it converts, and the gap is wider than
'' two ranks can differ. '-1L' is an INTEGER -- negation promotes -- so 'g( q, -1L )'
'' is { exact, narrowing } against 'long, long' and { widening, widening } against
'' 'longint, longint', and fbc takes LONG. tiko summed 1000 against 100 + 100 and took
'' LONGINT: fb/mathint.bi's 'AddSaturating( MIN_VALUE_LONG, -5L )' ran the 64-bit
'' overload and answered -2147483653.
''
'' fbc prints, one per line: long / longint / long,long / long,long / longint,longint
sub f overload ( byval a as long )
    print "long"
end sub
sub f overload ( byval a as longint )
    print "longint"
end sub
sub g overload ( byval a as long, byval b as long )
    print "long,long"
end sub
sub g overload ( byval a as longint, byval b as longint )
    print "longint,longint"
end sub
dim as long q = 3
f( 1L )
f( -1L )
g( q, -1L )
g( -q, q )
g( -q, -q )
