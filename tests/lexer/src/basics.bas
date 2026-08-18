'' a line comment
dim shared as long total = &hFF
sub Demo( byref s as string = "hi" )
    /' block /' nested '/ still in the block '/
    dim x$ = !"tab\there"
    total += 1 : print "x" & 10, &o17, &b1010, 1.5e-2, 100ull, .5
    if total >= 3 andalso x$ <> "" then total -= 1
end sub
? "done" _
    , total
