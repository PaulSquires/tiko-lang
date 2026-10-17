// fannkuch-redux: the most pancake flips over all permutations of 0..n-1.
package main

import (
	"fmt"
	"os"
	"strconv"
)

func fannkuch(n int) (int, int) {
	var perm, perm1, count [16]int
	maxFlips, checksum, permCount, r := 0, 0, 0, n
	for i := 0; i < n; i++ {
		perm1[i] = i
	}
	for {
		for r != 1 {
			count[r-1] = r
			r--
		}
		copy(perm[:n], perm1[:n])
		flips := 0
		for k := perm[0]; k != 0; k = perm[0] {
			k2 := (k + 1) >> 1
			for i := 0; i < k2; i++ {
				perm[i], perm[k-i] = perm[k-i], perm[i]
			}
			flips++
		}
		if flips > maxFlips {
			maxFlips = flips
		}
		if permCount%2 == 0 {
			checksum += flips
		} else {
			checksum -= flips
		}
		for {
			if r == n {
				return checksum, maxFlips
			}
			perm0 := perm1[0]
			for i := 0; i < r; i++ {
				perm1[i] = perm1[i+1]
			}
			perm1[r] = perm0
			count[r]--
			if count[r] > 0 {
				break
			}
			r++
		}
		permCount++
	}
}

func main() {
	n := 7
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	checksum, maxFlips := fannkuch(n)
	fmt.Printf("%d\nPfannkuchen(%d) = %d\n", checksum, n, maxFlips)
}
