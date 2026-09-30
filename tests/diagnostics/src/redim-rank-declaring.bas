'' A REDIM of another rank after a declaring 'redim ... as T' -- fbc's error 36 on the refused line.
extern e1() as integer
redim e1(0 to 0) as integer
redim e1(0 to 0, 0 to 0)                       '' 36
dim d1() as integer
redim d1(0 to 0) as integer
redim d1(0 to 1)                               '' fine: the same rank
