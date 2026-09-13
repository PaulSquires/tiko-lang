'' A PARENTHESISED CONCATENATION AS A PRINT ITEM. Check gives a '&' chain no type of its
'' own, and the parentheses hid the chain from the shape test that recovers one -- so the
'' item declined and took the rest of the statement with it: '<' printed and nothing else.
dim as string s1 = "R"
dim as string s2 = "  "
print "1<"; (trim((s2 & s2)) & s1); ">"
print "2<"; (s2 & s1); ">"
print "3<"; ((s2) & (s1)); ">"
print "4<"; (left(s2, 1) & s1), (ucase(s1) & "x")
