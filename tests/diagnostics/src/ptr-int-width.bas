'' A pointer into an integer of another size -- fbc's error 24 (181 for an assignment) on the
'' refused lines, 64-bit.
dim shared i as integer
dim shared a1 as long = @i                     '' 24
dim a2 as byte = @i                            '' 24
dim a3 as long
a3 = @i                                        '' 181
dim a4 as integer = @i                         '' fine
dim a5 as ulongint = @i                        '' fine
