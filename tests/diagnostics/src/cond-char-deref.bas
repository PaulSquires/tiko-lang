'' 'while *p' over a zstring ptr is a character condition (fbc's compound/select_const.bas).
dim s as string = "ab"
dim p as zstring ptr = strptr( s )
while *p : p += 1 : wend
if *p then print 1
