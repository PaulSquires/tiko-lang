'' TWO DECLARATIONS OF ONE CONSTANT (fbc error 4), and a BYREF PARAMETER WITH A DEFAULT
'' whose type is incomplete (fbc error 71). Measured against fbc, refused and accepted
'' shapes side by side.
''
'' A STRING-VALUED pair is NOT refused here: comparing two string literals needs their
'' text, which lives in the source buffer that the collector cannot reach, and comparing
'' the raw spans instead would call two IDENTICAL strings at different offsets a duplicate
'' -- which fbc accepts. So 'const s1 = "1"' then 'const s1 = "2"' is still let through.
'' Accepted: one declaration each, and a repeat with the SAME value.
const okInt = 1
const okSame = 1
const okSame = 1
'' A KNOWN OVER-ACCEPTANCE, not an accepted shape: fbc refuses the pair below (error 4)
'' and this compiler lets it through, for the reason given above.
const strGap = "1"
const strGap = "2"
'' Refused: the same name with a different value or a different type.
const dupInt = 1
const dupInt = 2
const dupFloat = 1.0
const dupFloat = 1.5
const dupConstness as const integer = 0
const dupConstness as integer = 0
'' Accepted: a byref parameter of an incomplete type, with no default to materialise.
type fwd as forward
declare sub okAny( byref x as any )
declare sub okFwd( byref x as fwd )
declare sub okComplete( byref x as integer = 0 )
'' Refused: a default needs somewhere to live, and neither type says how big that is.
declare sub badAny( byref x as any = 0 )
declare sub badFwd( byref x as fwd = 0 )
