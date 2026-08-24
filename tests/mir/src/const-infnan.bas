'' DIVIDING BY ZERO IS AN ANSWER IN FLOATING POINT, not an error.
''
'' IEEE gives +/-INF and 0/0 gives a NaN, and fbc FOLDS all of them -- measured:
''
''     dim shared as double b = 1.0 / 0.0    static double B$ = __builtin_inf();
''     dim shared as double c = 0.0 / 0.0    static double C$ = (-__builtin_nan( "" ));
''
'' The const folder refused a zero divisor outright, so every INF and NaN constant went
'' unfolded and a STATIC or SHARED initialised from one had no image at all -- 32
'' declines in numbers/infnan.bas, which is the file that exists to test these values,
'' and which compares the exact BIT PATTERN of each.
''
'' Note the SIGN on the NaN: 0.0 / 0.0 is 0xFFF8000000000000 on x86, which is the
'' 'NEGNAND' that file names, and fbc's own '-__builtin_nan' agrees. A non-finite value
'' prints its bits here for exactly that reason: 'str( )' renders every NaN as 'nan'
'' whatever its sign, and the sign is the thing under test.
dim shared as double posinf =  1.0 /  0.0
dim shared as double neginf = -1.0 /  0.0
dim shared as double posinf2 = -1.0 / -0.0
dim shared as double nan0 =  0.0 /  0.0
dim shared as double nan1 = -( 0.0 / 0.0 )
dim shared as double half = 1.0 / 2.0

dim shared as single sposinf = 1.0 / 0.0
dim shared as single snan = 0.0 / 0.0

sub t( )
	static as double s = 1.0 / 0.0
	static as double sn = 0.0 / 0.0
	print s, sn
end sub

t( )
print posinf, neginf, posinf2, nan0, nan1, half, sposinf, snan
