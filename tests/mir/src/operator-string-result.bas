'' A USER OPERATOR WHOSE RESULT IS A STRING.
''
'' It is a call and hands back a descriptor pointer, exactly as a string-returning
'' function does -- but it is spelled '-a' or 'a + b', so it arrives as a UNARY or a
'' BINARY and nothing that looks for a string CALL finds one. 'print -a' declined with
'' the operator sitting right there, and so did every other reader that wants a string
'' term. structs/ops.bas is nothing but these.
''
'' AND THE CALL RETURNS A POINTER, which is what the function's own declaration says --
'' 'FBSTRING* F( void )'. Reading it as the string's MIR type put an 'agg' result on a
'' call to a function declared to return a pointer.
type mytype
	as integer value
end type

operator - ( byref a as mytype ) as string
	return ("- ") & a.value
end operator

operator + ( byref a as mytype, byref b as mytype ) as string
	return a.value & (" + ") & b.value
end operator

'' The named operators take the same route -- 'abs( a )' is a call in the source and a
'' unary operator in the tree.
operator ABS ( byref a as mytype ) as string
	return ("ABS ") & a.value
end operator

operator LEN ( byref a as mytype ) as integer
	return a.value
end operator

dim as mytype a, b
a.value = 1
b.value = 2

print -a
print a + b
print abs( a )
print len( a )

'' ...and as a term of something else, which is the other reader.
dim as string s = (-a) & "|" & (a + b)
print s

'' ADJACENT LITERALS ARE ONE STRING. '"a" "b"' is an N_STRCAT of its parts -- the lexer
'' keeps the run rather than folding it -- and the corpus writes it as '(#op " ")', a
'' STRINGIZE followed by a literal, which is how structs/ops.bas declares all 36 of its
'' operators. Nothing in the string-term path looked at one, so every
'' 'return (#op " ") & a.value' declined.
#macro makeop( op )
	operator op ( byref a as mytype ) as string
		return (#op " ") & a.value
	end operator
#endmacro

makeop( FIX )
makeop( SGN )

print fix( a ), sgn( a )
print ("lit" " " "run") & a.value
