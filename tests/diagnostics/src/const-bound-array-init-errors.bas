'' A VARIABLE bound is still var-len (fbc's 75), and an array a constant bounds is fixed, so
'' REDIM cannot resize it (fbc's 54).
dim as long cnt = 3
dim as long v(cnt) = {1, 2, 3, 4}

const N = 3
dim as long a(N) = {1, 2, 3, 4}
redim a(5)
