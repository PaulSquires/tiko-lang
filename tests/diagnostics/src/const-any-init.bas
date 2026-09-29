'' A const initialized with '= any' -- fbc's error 237 on the refused lines.
dim as const integer c1 = any                  '' 237
dim as const integer c2(0 to 1) = any          '' 237
dim as integer v1 = any                        '' fine
sub f( )
    static as const integer c3 = any           '' 237
end sub
