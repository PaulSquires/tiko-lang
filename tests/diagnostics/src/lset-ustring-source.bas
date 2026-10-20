' fbc's error 24 for every one: LSET and RSET take no ustring source.
dim as ustring u = "ab", m(0 to 1)
dim as ustring buf = space(6)
dim as string s = space(6)
lset buf, m(0)
rset s, u
lset buf, s
print buf
