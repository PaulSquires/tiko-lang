'' AN INTRINSIC FUNCTION CALLED AS A STATEMENT WITHOUT PARENTHESES -- 'hex 5',
'' 'left "ab", 1'. fbc calls the function and frees the result it discards, exactly as
'' it does for 'hex( 5 )' written as a statement. Measured from fbc-modern's C:
''
''   hex i         vr$0 = fb_HEX_i( I$0 );  fb_hStrDelTemp( vr$0 );   (i a LONG)
''   dir "*"       fb_Dir( ..., 33, NULL ), then fb_hStrDelTemp
''   wspace 3      fb_WstrSpace( 3 ), then fb_WstrDelete
''
'' tiko parsed each as a call to a name nothing binds, and dropped the statement.
dim as long i = 5
hex i
oct 8
bin 3
left "abc", 1
right "abc", 2
space 4
dir "*.nomatch"
wbin 5
whex 5
woct 5
wspace 3
