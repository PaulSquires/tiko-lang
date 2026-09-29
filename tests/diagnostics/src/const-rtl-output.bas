'' A CONSTANT AS WHAT A RUNTIME STATEMENT WRITES -- fbc's error 119 for each of lines 14 to 20,
'' and 181 for 21 to 23, EACH MEASURED IN A FILE OF ITS OWN (fbc-modern 1.20). In this file fbc
'' itself reports 14, 15, 17, 18 and 21 to 23: its recovery after one error skips the statement
'' that follows some of them. tiko accepted each. From line 25 a const file number, a const GET
'' position and 'put' over a const are fbc's, and accepted. See symbols/constout.bas.
dim as const integer arr( 9 ) = { 0 }
dim as const longint fp = 0
dim as const integer v1 = 0, v2 = 0, v3 = 0, id = 0, b = 0
dim as const string s1 = "", s2 = "", s3 = ""
dim as const integer a = 256
dim as const integer F = 1
dim as long w
dim as integer a1
get ( 0, 0 )-( 0, 0 ), arr
get #1, , fp
input #1, v1
input "p", v2
line input #1, s1
line input s2
lset s3, "x"
read v3
clear a, 0, sizeof( integer )
getjoystick id, b, a1
'' accepted from here
get #F, fp, w
input #F, w
put #1, , fp
data 1
print "end"
