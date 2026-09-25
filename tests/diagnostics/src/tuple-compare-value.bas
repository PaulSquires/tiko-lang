'' '=' AND '<>' OVER ONE TUPLE TYPE ARE AN INTEGER VALUE, -1 or 0 -- fbc-modern 1.20:
'' 'typeof( a = b )' is INTEGER, and this file prints -1 -1 0 0 -1 ne 1 0 -1. tiko gave the
'' comparison no type, so every statement below that asks for one was left out of the
'' program in silence; only the 'dim' and the 'if' lowered.
dim as (long, long) a = (1, 2), b = (1, 2), c = (1, 3)
print a = b
print a <> c
print a = c, a <> b
dim as long r = (a = b)
print r
if a = c then print "eq" else print "ne"
print -(a = b)
print (a = b) + 1
dim as string s = str( a = b )
print s
