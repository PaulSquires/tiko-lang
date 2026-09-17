'' A BOOLEAN COMPARED AGAINST SOMETHING THAT IS NOT ONE.
''
'' A boolean is STORED as 0 or 1 and MEANS 0 or -1, so widening one negates it. The
'' comparison path passed CoerceTy no destination type, and CoerceTy suppresses that
'' negation for an unknown MT_I8 destination -- deliberately, because MT_I8 is also
'' what a boolean destination wants. So a boolean beside a byte-wide operand kept its
'' stored 1 and was compared against the other side's -1:
''
''     %7  = call i8 T()          '' 1, the storage value
''     %10 = neg (s = "dark")     '' -1, integer truth
''     %11 = icmp.eq %7, %10      '' 1 = -1, false
''
'' tiko-editor's 'Theme_IsDark( ) = (sApp = "dark")' answered FALSE for a dark theme.
'' Both sides false is 0 = 0 either way, which is exactly what hid it: every other
'' spelling in that suite passed.
''
'' Measured, fbc negates the boolean and compares at INTEGER:
''
''     -((int64)-vr$1 == (int64)-((int64)vr$4 == 0ll))     '' bool = string compare
''     -((int64)-vr$0 == (int64)UY$0)                      '' bool = ubyte 255, FALSE
''
'' The width is load-bearing in the second: at the byte width -1 and 255 are the same
'' bits, and fbc says false. A lone boolean has no arithmetic result to promote
'' through -- 'boolean + ubyte' is an fbc error -- so INTEGER is named outright.
dim shared as boolean bt = true
dim shared as boolean bf = false
function T( ) as boolean : return true : end function

dim as string s = "dark"
dim as ubyte uy = 255
dim as byte  yb = -1

'' THE MISCOMPILE, and the spelling beside it that always worked -- false = false is
'' 0 = 0 whether the boolean is negated or not.
print "1 "; ( T( ) = (s = "dark") )
print "2 "; ( T( ) = (s = "nope") )
'' THE WIDTH, which negating alone does not settle.
print "3 "; ( T( ) = uy )
print "4 "; ( T( ) = yb )
'' TWO BOOLEANS compare by their STORAGE value and must NOT be negated.
print "5 "; ( T( ) = bt )
print "6 "; ( T( ) = bf )
print "7 "; ( bt = bf )
