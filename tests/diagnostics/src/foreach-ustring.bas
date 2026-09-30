'' TKO0688: a ustring is not walked by 'for each'.
''
'' Check used to accept this and lowering used to decline it, so the loop emitted nothing
'' and ran zero times with no diagnostic at all (tiko-book T17). fbc refuses the same
'' program with its error 342.
dim as ustring u = "abc"

for each ch in u
    print ch
next

'' A NARROW string is still walked, by both compilers, and yields its bytes.
dim as string s = "abc"
for each b in s
    print b
next
