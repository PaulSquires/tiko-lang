// mandelbrot: the Mandelbrot set as a 1-bit portable bitmap.
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	n := 200
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	w, h := n, n
	bitmap := make([]byte, 0, (w+7)/8*h)
	for y := 0; y < h; y++ {
		ci := 2.0*float64(y)/float64(h) - 1.0
		b, bits := 0, 0
		for x := 0; x < w; x++ {
			cr := 2.0*float64(x)/float64(w) - 1.5
			var zr, zi, tr, ti float64
			i := 0
			for i < 50 && tr+ti <= 4.0 {
				zi = (zr+zr)*zi + ci
				zr = tr - ti + cr
				tr = zr * zr
				ti = zi * zi
				i++
			}
			b <<= 1
			if tr+ti <= 4.0 {
				b |= 1
			}
			bits++
			if bits == 8 {
				bitmap = append(bitmap, byte(b))
				b, bits = 0, 0
			}
		}
		if bits > 0 {
			bitmap = append(bitmap, byte(b<<(8-bits)))
		}
	}
	out := bufio.NewWriter(os.Stdout)
	fmt.Fprintf(out, "P4\n%d %d\n", w, h)
	out.Write(bitmap)
	out.Flush()
}
