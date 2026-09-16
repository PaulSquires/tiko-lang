'' A CHARACTER THROUGH A POINTER IS A NUMBER. 'dim as ulong c = pz[2]' takes the
'' character CODE -- not val( ), which would be 0 -- and the deref form does the same.
'' Measured under fbc-modern: 99 65 98 65 / 65 98 99.
''
'' The ASSIGNMENT beside each initialiser always lowered correctly; it is here so that
'' a fix which only ever exempts the declaration cannot pass while the two forms
'' disagree about the number they produce.
dim as zstring * 8 z = "Abc"
dim as zstring ptr pz = @z
dim as wstring * 8 w = "Abc"
dim as wstring ptr pw = @w
dim as const zstring ptr cpz = @z
dim as const wstring ptr cpw = @w

dim as ulong a = pz[2]
dim as ulong b = *pz
dim as ulong c = pw[1]
dim as ulong d = *pw
print a; " "; b; " "; c; " "; d

'' The const-qualified pointers, and the parenthesised spelling.
dim as ulong e = cpz[0]
dim as ulong f = cpw[1]
dim as ulong g = (pz[2])
print e; " "; f; " "; g

dim as ulong h, i, j
h = pz[2] : i = *pw : j = cpz[1]
print h; " "; i; " "; j
