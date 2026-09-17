'' A PARAMETERLESS STRING INTRINSIC CONVERTED INTO A UDT.
''
'' 'curdir', 'time' and 'date' take no arguments and no parentheses, so each is a lone
'' N_IDENT typed STRING -- and each is a CALL whose result is a descriptor from libfb's
'' small ROTATING POOL. StrArgOwnDescriptor_ answered its N_IDENT case 'owns its
'' descriptor', which is true of a VARIABLE and of nothing else, so the pool slot went
'' straight to the user's operator:
''
''     %5 = call ptr fb_CurDir()
''     call void _ZN7AFXNOVA8DWSTRINGaSER8FBSTRING(@d, %5)
''
'' AfxNova's 'operator let( byref ansiStr as string )' is 'this.Clear : this.Add(
'' ansiStr )', and Add does its own string work -- which recycles the very slot its
'' parameter points at. The result was EMPTY, silently. tiko-editor saved the current
'' directory that way before a compile and so could not put the process back afterwards.
''
'' Measured, fbc copies into a temporary it owns first:
''
''     memset( &TMP, 0, 24 );
''     vr = fb_CurDir();
''     fb_StrAssign( (void*)&TMP, -1ll, (void*)vr, -1ll, 0 );
''     _ZN..aSER8FBSTRING( &D, &TMP );
''     fb_StrDelete( (FBSTRING*)&TMP );
type U
    as long n
    as zstring * 64 txt
    declare constructor( )
    declare destructor( )
    declare operator let( byref s as string )
end type
constructor U( ) : n = -1 : txt = "" : end constructor
destructor U( ) : end destructor
'' The operator does string work of its OWN before reading the parameter, which is what
'' recycles a pool slot the caller handed over rather than copied.
operator U.let( byref s as string )
    dim as string scratch = space( 40 )
    scratch = ucase( "recycle the pool" ) & trim( "  x  " )
    n = len( s )
    txt = s
end operator

dim as U a
a = curdir
print "curdir  n="; (a.n > 0)
dim as U b
b = time
print "time    n="; (b.n > 0)
dim as U c
c = date
print "date    n="; (c.n > 0)
'' A STRING VARIABLE really does own its descriptor and must NOT be copied -- the half
'' of the rule a fix that simply always copied would break.
dim as string sv = "a variable"
dim as U d
d = sv
print "var     n="; d.n; " ["; d.txt; "]"
