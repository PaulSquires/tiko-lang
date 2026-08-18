'' 'for each (k, v)' -- the destructuring form's own diagnostics.
''
'' Every case is at MODULE LEVEL and uses its own array. Recovery for a
'' malformed FOR EACH skips the whole compound, and inside a SUB that can
'' swallow the 'end sub' as well -- after which every later case reports
'' 'Expected END SUB' instead of the diagnostic this file exists to pin.
''
'' Two further cases -- AS and BYREF on the list form -- are in files of their
'' own. They are rejected while the binding is still being read, before the FOR
'' compound is pushed, so the skip leaves the following 'next' orphaned and
'' every later diagnostic in the same file is suppressed. Only the first such
'' case in a file is observable, so each gets a file.
''
'' See fb-rfcs/rfcs/0003-for-each.md section 6a.

#print === the element is not a tuple ===
dim scalars(0 to 1) as long
for each (a1, b1) in scalars
next

#print === arity does not match the element ===
dim pairs(0 to 1) as (long, string)
for each (a2, b2, c2) in pairs
next

#print === the list form needs at least two names ===
dim ones(0 to 1) as (long, string)
for each (a3) in ones
next
