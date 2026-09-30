'' A variable of type ANY, and one whose typedef is itself -- fbc's error 24 on the refused
'' lines (71 for the two-typedef cycle).
type self1 as self1
type cyc1 as cyc2
type cyc2 as cyc1
dim x1 as any                                  '' 24
static x2 as any                               '' 24
dim as self1 x3                                '' 24
dim as cyc1 x4                                 '' 71
dim p1 as any ptr                              '' fine
dim as self1 ptr p2                            '' fine
