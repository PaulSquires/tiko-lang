// spectral-norm: the spectral norm of an infinite matrix, by the power method.
package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
)

func a(i, j int32) float64 {
	return 1.0 / float64((i+j)*(i+j+1)/2+i+1)
}

func multAv(v, av []float64) {
	for i := range av {
		sum := 0.0
		for j, x := range v {
			sum += a(int32(i), int32(j)) * x
		}
		av[i] = sum
	}
}

func multAtv(v, atv []float64) {
	for i := range atv {
		sum := 0.0
		for j, x := range v {
			sum += a(int32(j), int32(i)) * x
		}
		atv[i] = sum
	}
}

func multAtAv(v, atav, tmp []float64) {
	multAv(v, tmp)
	multAtv(tmp, atav)
}

func main() {
	n := 100
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	u := make([]float64, n)
	v := make([]float64, n)
	tmp := make([]float64, n)
	for i := range u {
		u[i] = 1.0
	}
	for i := 0; i < 10; i++ {
		multAtAv(u, v, tmp)
		multAtAv(v, u, tmp)
	}
	var vbv, vv float64
	for i := 0; i < n; i++ {
		vbv += u[i] * v[i]
		vv += v[i] * v[i]
	}
	fmt.Printf("%.9f\n", math.Sqrt(vbv/vv))
}
