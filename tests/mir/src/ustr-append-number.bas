'' A NUMBER APPENDED TO A USTRING is rendered narrow and DECODED before the append.
dim as long n = 42
dim as double d = 1.5
dim as ustring u = "a"
u = u & n
print u; "|"; len( u )
dim as ustring u2 = "a"
u2 &= n
print u2; "|"; len( u2 )
dim as ustring u3 = "a"
u3 = u3 & d
print u3; "|"; len( u3 )
