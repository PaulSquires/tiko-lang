'' A constant redefined with a different string value -- fbc's error 4 on the refused lines.
const a = "1"
const a = "1"                              '' fine: the same text
const a = "2"                              '' 4
const w = wstr( "1" )
const w = wstr( "1" )                      '' fine
const w = wstr( "2" )                      '' 4
const n = "1"
const n = 1                                '' 4
