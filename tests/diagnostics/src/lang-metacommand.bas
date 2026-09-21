'$lang: "qb"
'' THE METACOMMAND SPELLING OF '#lang', which fbc honours in any comment -- and 'rem
'' $lang:' too. tiko dropped it as a comment, compiled the QB program as FB, and
'' failed later on a name only QB has: "'stick' is not declared". It is refused now
'' exactly as '#lang "qb"' is -- TKO0317 and nothing more.
x = stick( 0 )
print y
