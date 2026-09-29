'' A reserved word as a typedef's target -- fbc's error 14 on the refused lines. An
'' INTRINSIC word (print, len) is a name to fbc and forward-references a type.
type T1 as dim                                 '' 14
type T2 as if                                  '' 14
type as operator T3                            '' 14
type T4 as print                               '' fine
type T5 as integer                             '' fine
