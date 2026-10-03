'' T72: 'for each byref' over a var-length string is refused, as fbc refuses it
'' (error 345). By value it is accepted; so is byref over an array.
dim s as string = "ab"
for each c in s
    print c;
next
print
for each byref c in s
    c += 1
next
var t = s
for each byref c in t
    c += 1
next
dim a( 0 to 1 ) as long
for each byref x in a
    x += 1
next
