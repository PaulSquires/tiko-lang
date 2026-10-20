' A shared / static UDT initialised from a tuple with a 'string * N' field: space-padded,
' truncated, and not overwritten by the implicit constructor at start-up. A tiko extension:
' fbc-modern refuses the shape (error 7), older fbc built it.
type myorder
    var1 as double
    var2 as string * 8
end type
dim shared as myorder orders(1 to 3) = {(1e12, "trillion"), (1e9, "billion"), (1e3, "thousands")}
dim shared as myorder one = (5, "ab")
sub s()
    static as myorder st = (7, "static")
    print "["; st.var2; "]"; st.var1
end sub
print "["; orders(1).var2; "]["; orders(2).var2; "]["; orders(3).var2; "]"; orders(2).var1
print "["; one.var2; "]"; one.var1
s()
