'' Assignment legality, which does NOT follow from binary promotion.
dim as long a
dim as ubyte u
dim as double d
dim as boolean b
dim as string s
dim as integer i
dim as any ptr p
dim as long ptr lp
dim as zstring ptr zp

u = a        '' ok     -- narrowing is silent; there is no truncation warning
a = d        '' ok
b = a        '' ok
a = b        '' ok
s = s        '' ok
p = lp       '' ok     -- either side ANY PTR
lp = p       '' ok
p = i        '' warn   -- pointer <-> pointer-sized integer
i = p        '' warn
lp = zp      '' warn   -- two different concrete pointees
s = a        '' reject -- string and number never mix
a = s        '' reject
a = p        '' reject -- LONG is not pointer-sized
