dim as ustring maxcp = wchr( &h10FFFF )
print len( maxcp ), hex(maxcp[0]), hex(maxcp[1])
dim as ustring a = wchr( &h1F600 )
print len(a), hex(a[0]), hex(a[1])
dim as integer cp = &h10FFFF
dim as ustring b = wchr( cp )
print len(b), hex(b[0])
