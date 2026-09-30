'' SCRN, CONS and ERR take no file name -- fbc's error 5 on the refused lines.
open scrn "x" for input as #1                  '' 5
open cons "x" for input as #2                  '' 5
open scrn for input as #3                      '' fine
open lpt "x" for output as #4                  '' fine: LPT takes one
