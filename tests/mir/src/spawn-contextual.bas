'' 'spawn' IS CONTEXTUAL in FBC-Modern -- not reserved -- so a program that predates
'' the feature and uses the name as a variable must keep compiling and behaving
'' identically. Measured: 'dim shared as long spawn : spawn = 4 : print spawn'
'' compiles under fbc-modern.
''
'' The keyword is claimed only when a NAME follows it, which is the shape every real
'' use has. That leaves the assignment spellings alone, and 'spawn( i ) = 5' over an
'' ARRAY of that name begins with '(' rather than a name.
dim shared as long spawn
spawn = 4
spawn += 1
print spawn

dim shared as long spawnArr(0 to 3)
spawnArr(1) = 9
print spawnArr(1)
