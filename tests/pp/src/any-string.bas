'' '= ANY' OVER A VAR-LENGTH STRING IS fbc's ERROR 24, and the boundary is narrower
'' than "anything holding a string". Measured, every line:
''
''     dim as string s = any               error 24
''     dim as string s(0 to 2) = any       error 24
''     as string s = any        (a field)  error 24
''     s(0 to 2) as string = any (a field) error 24
''
''     dim as string * 8 s = any           ACCEPTED -- a fixed-length string is bytes
''     dim as ustring s = any              ACCEPTED, in every shape
''     i as inner = any, inner holding a var-len string   ACCEPTED
''
'' That last one is why the rule is on the DECLARED type and is not widened: fbc leaves
'' inner's descriptor uninitialised and then DESTROYS it. Copying its acceptance is
'' compatibility; copying it into a rule about reachable strings would be a guess.
dim as string s1 = any
dim as string s2(0 to 2) = any

type k
	as string f1 = any
	f2(0 to 2) as string = any
end type

'' ...and the accepted spellings, which must NOT be reported.
dim as string * 8 ok1 = any
dim as ustring ok2 = any
dim as long ok3 = any
