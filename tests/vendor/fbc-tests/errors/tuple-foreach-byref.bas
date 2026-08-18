'' 'for each byref (a, b)' -- rejected.
''
'' Binding one name byref and another byval has no obvious spelling, and
'' binding the whole element by reference is what 'for each byref e' already
'' does.
''
'' Alone in a file: see the note in tuple-foreach-errors.bas.

#print === no BYREF on the list form ===
dim withref_(0 to 1) as (long, string)
for each byref (a, b) in withref_
next
