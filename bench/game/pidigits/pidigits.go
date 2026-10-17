// pidigits: the digits of pi, by the unbounded spigot algorithm on math/big integers.
package main

import (
	"bufio"
	"fmt"
	"math/big"
	"os"
	"strconv"
)

var (
	tmp1 = new(big.Int)
	tmp2 = new(big.Int)
	acc  = big.NewInt(0)
	den  = big.NewInt(1)
	num  = big.NewInt(1)
	ten  = big.NewInt(10)
)

func extractDigit(nth int64) int64 {
	tmp1.Mul(num, big.NewInt(nth))
	tmp2.Add(tmp1, acc)
	tmp1.Quo(tmp2, den)
	return tmp1.Int64()
}

func eliminateDigit(d int64) {
	tmp1.Mul(den, big.NewInt(d))
	acc.Sub(acc, tmp1)
	acc.Mul(acc, ten)
	num.Mul(num, ten)
}

func nextTerm(k int64) {
	k2 := big.NewInt(k*2 + 1)
	tmp1.Lsh(num, 1)
	acc.Add(acc, tmp1)
	acc.Mul(acc, k2)
	den.Mul(den, k2)
	num.Mul(num, big.NewInt(k))
}

func main() {
	n := 30
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	out := bufio.NewWriter(os.Stdout)
	digits := make([]byte, 0, 10)
	var k int64
	for i := 0; i < n; {
		k++
		nextTerm(k)
		if num.Cmp(acc) > 0 {
			continue
		}
		d := extractDigit(3)
		if d != extractDigit(4) {
			continue
		}
		digits = append(digits, byte('0'+d))
		i++
		if len(digits) == 10 || i == n {
			fmt.Fprintf(out, "%-10s\t:%d\n", digits, i)
			digits = digits[:0]
		}
		eliminateDigit(d)
	}
	out.Flush()
}
