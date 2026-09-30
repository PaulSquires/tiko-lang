'' 'redim shared' in a scope over an array COMMON declared -- fbc's error 96 on the refused line.
common array() as integer
scope
    redim shared array(0 to 1) as integer      '' 96
end scope
redim array(0 to 3) as integer                 '' fine
