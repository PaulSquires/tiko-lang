'' A fixed array's lower bound above its upper -- fbc's error 182 on the refused lines.
const L = 1
const H = 0
dim shared a1(1 to 0) as integer                   '' 182
dim a2(-1) as integer                              '' 182
dim a3(L to H, 0 to 1) as integer                  '' 182
dim a4(-9223372036854775807-1 to -9223372036854775807-1) as integer   '' 182
type T
    f(1 to 0) as integer                           '' 182
end type
dim b1(5 to 5) as integer                          '' fine
dim b2(-9223372036854775807 to -9223372036854775807) as integer       '' fine
redim b3(1 to 0) as integer                        '' fine: a redim's bounds are the runtime's
