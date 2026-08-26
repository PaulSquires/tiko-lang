'' 'byref' WRITTEN AGAIN AFTER A COMMA, which was read as a NAME.
''
'' 'dim byref r1 as integer = i, byref r2 as integer = i' is two aliases, and fbc reads
'' the second 'byref' as a modifier exactly like the first. Only the LEADING one was
'' being consumed -- by the modifier loop that runs before any name -- so what followed
'' the comma began at the word 'byref', which the declaration parser happily takes as
'' an identifier, keywords being legal names in declaration position.
''
'' The result was a variable literally called 'byref', aliasing nothing, and NO r2 at
'' all -- with no diagnostic anywhere, because nothing about it is malformed. Every
'' later use of r2 was an unbound name. 'var shared byref gr4 = gi, byref gr5 = gi'
'' loses gr5 the same way.
''
'' The flag is recorded on the ITEM now, because 'byref' varies between the items of one
'' declaration; a leading one still belongs to the whole declaration and stays on it.
dim i as integer = 456
dim byref r1 as integer = i, byref r2 as integer = i
var byref r3 = i, byref r4 = i

print r1, r2, r3, r4
print @r1 = @i, @r2 = @i, @r3 = @i, @r4 = @i

'' ...and every one of them is a real alias, not a copy
r2 = 7
print i
r4 = 9
print i
