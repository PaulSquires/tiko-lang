'' 'for each (a, b) as T' -- rejected.
''
'' A single type cannot describe elements that differ, and per-name types would
'' spell out what the tuple already says. Use 'for each e in c' and e._1.
''
'' Alone in a file: see the note in tuple-foreach-errors.bas.

#print === no AS clause on the list form ===
dim withas_(0 to 1) as (long, string)
for each (a, b) as long in withas_
next
