'' A SINGLE-LINE IF TAKES EVERY STATEMENT ON THE LINE, not just the first.
''
'' 'if c then a : b' puts BOTH in the then-branch. One statement was taken and 'b'
'' fell out into the enclosing block, where it ran UNCONDITIONALLY -- silently, with
'' the statement counted as fully lowered.
''
'' It is the corpus's own idiom. com/comptr-noimport.bas writes
''
''     if( n = 0 ) then g_destroyed += 1 : deallocate( s )
''
'' so the deallocate ran on EVERY Release: the first freed the object and the second
'' wrote through it. 0xC0000374, heap corruption, with the right answer printed on the
'' way past.
''
'' ':' AND A NEWLINE BOTH LEX AS AN EOL, so the token kind cannot tell them apart. The
'' separator the last statement ATE is what says which, through TF_COLON -- the flag
'' that already exists because 'name:' is a label and 'name' alone is a call.
''
'' NOT THE PHYSICAL LINE, which was the first attempt: every token of a macro
'' expansion carries the INVOCATION's location, so three consecutive assert_( ) lines
'' looked like one and the second and third were swallowed into the first's branch.
dim as long a, b, c

a = 0 : b = 0
if 0 then a = 1 : b = 2
print "false:"; a; b

a = 0 : b = 0
if -1 then a = 1 : b = 2
print "true: "; a; b

'' Three deep, and an ELSE still binds to this IF.
a = 0 : b = 0 : c = 0
if 0 then a = 1 : b = 2 : c = 3 else a = 7
print "else: "; a; b; c

'' 'end if' on the same line closes it; what follows is outside.
a = 0 : b = 0
if 0 then a = 1 : end if
b = 9
print "endif:"; a; b
