'' T94: an arithmetic + under &, and string + chains beside it.
dim as string s = "a" & 1 + 2
print s
print ("a" & 1 + 2)
print "a" & (1 + 2)
dim as long n = 1
print "a" & n + 2
print "a" & 1 * 2
print "a" & 2 - 1
print 1 + 2 & "b"
dim as string t = "x"
print t & n + 2
print t + "y" & "z" + t
dim as ustring u = "u"
print u & n + 1; u + u & 3 + 4
dim as wstring * 10 w = "w"
dim as wstring * 10 w2 = w & n + 1
print len( w2 )
print "p" & 1.5 + 1; "q" & n + n + n
