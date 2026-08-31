'' TWO RULES, both measured.
''
'' 'swap' EXCHANGES TWO STORAGE LOCATIONS, so neither operand may be a literal or a
'' constant. fbc has a separate error for each: 'swap a, 0' is error 24, "Invalid data
'' types", and 'swap K, s' over a constant is error 119, "Cannot modify a constant".
''
'' AND A SHARED VARIABLE'S INITIALISER RUNS BEFORE ANY FRAME EXISTS, so it may not name
'' one that is not shared -- fbc error 272, "Local symbols can't be referenced":
''
''     static as integer i
''     dim shared as integer ptr pi = @i     error 272
''
'' 'static' STORAGE IS NOT ENOUGH: that variable outlives the frame, and fbc still calls
'' it local. What the initialiser may name is a SHARED one.
const K = 5
static as integer stat_
dim shared as integer g
dim shared as integer a
dim shared as integer b
dim shared as string s

'' -- refused ------------------------------------------------------------------
dim shared as integer ptr pi = @stat_

sub refused( )
    swap a, 0
    swap K, b
end sub

'' -- accepted -----------------------------------------------------------------
dim shared as integer ptr pg = @g

sub accepted( )
    swap a, b
    swap s, s
end sub
