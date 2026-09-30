'' DIM after COMMON: with bounds it sizes the array, without it re-declares it -- fbc's
'' error 4 on the refused lines.
common a1() as integer
dim a1() as integer                            '' 4
common a2() as integer
dim a2(any) as integer                         '' 4
common a3() as integer
dim a3(0 to 1) as integer                      '' fine
