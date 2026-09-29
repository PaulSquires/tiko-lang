'' A VARIABLE OR A PROCEDURE IN '#if' -- fbc's error 11 on lines 18, 20, 22, 24 and 26, and
'' 17 on 28 and 30 (fbc-modern 1.20). tiko read each as 0. From line 32 a const, a macro, a
'' type name, an undefined name and 'defined( )' over a variable are fbc's, and accepted.
dim as long i
dim shared as long g
dim as sub( ) pf
static as long sv
declare function DF( ) as long
sub S( )
end sub
private sub PS( )
end sub
const K = 1
#define M 1
type T
    a as long
end type
#if i
#endif
#if g
#endif
#if pf
#endif
#if sv
#endif
#if DF
#endif
#if S
#endif
#if PS
#endif
#if K
#endif
#if M
#endif
#if T
#endif
#if NOPE
#endif
#if defined( i )
#endif
#ifdef g
#endif
print "end"
