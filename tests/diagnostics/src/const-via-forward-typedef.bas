'' A VARIABLE WHOSE TYPE IS CONST THROUGH A FORWARD TYPEDEF is still const -- fbc error
'' 119. 'type as const u t' with 'u' declared LATER leaves 't' a placeholder when the
'' variable and its assignment are first walked; the typedef is back-patched afterwards,
'' so the post-Check pass asks again. The non-forward spellings were already refused.
type as const u t
type u as integer
type as const integer plain

dim as t i = 0
dim as plain j = 0
dim as t ptr p
p = 0

i = 0
j = 0
