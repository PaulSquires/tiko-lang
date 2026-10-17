// fasta: generate DNA sequences by copying and by weighted random selection.
package main

import (
	"bufio"
	"os"
	"strconv"
)

const (
	line = 60
	im   = 139968
	ia   = 3877
	ic   = 29573
)

const alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
	"GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
	"CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
	"ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
	"GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
	"AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
	"AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

type freq struct {
	c byte
	p float64
}

var iub = []freq{
	{'a', 0.27}, {'c', 0.12}, {'g', 0.12}, {'t', 0.27},
	{'B', 0.02}, {'D', 0.02}, {'H', 0.02}, {'K', 0.02},
	{'M', 0.02}, {'N', 0.02}, {'R', 0.02}, {'S', 0.02},
	{'V', 0.02}, {'W', 0.02}, {'Y', 0.02},
}

var homosapiens = []freq{
	{'a', 0.3029549426680}, {'c', 0.1979883004921},
	{'g', 0.1975473066391}, {'t', 0.3015094502008},
}

var seed int32 = 42

func rnd() float64 {
	seed = (seed*ia + ic) % im
	return 1.0 * float64(seed) / im
}

func repeatFasta(out *bufio.Writer, s string, n int) {
	doubled := s + s[:line]
	buf := make([]byte, line+1)
	pos := 0
	for n > 0 {
		count := min(n, line)
		copy(buf, doubled[pos:pos+count])
		buf[count] = '\n'
		out.Write(buf[:count+1])
		pos += count
		if pos > len(s) {
			pos -= len(s)
		}
		n -= count
	}
}

func randomFasta(out *bufio.Writer, table []freq, n int) {
	cum := make([]float64, len(table))
	p := 0.0
	for i, f := range table {
		p += f.p
		cum[i] = p
	}
	last := len(table) - 1
	buf := make([]byte, line+1)
	for n > 0 {
		count := min(n, line)
		for i := 0; i < count; i++ {
			r := rnd()
			j := 0
			for j < last && r >= cum[j] {
				j++
			}
			buf[i] = table[j].c
		}
		buf[count] = '\n'
		out.Write(buf[:count+1])
		n -= count
	}
}

func main() {
	n := 1000
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	out := bufio.NewWriterSize(os.Stdout, 1<<16)
	out.WriteString(">ONE Homo sapiens alu\n")
	repeatFasta(out, alu, n*2)
	out.WriteString(">TWO IUB ambiguity codes\n")
	randomFasta(out, iub, n*3)
	out.WriteString(">THREE Homo sapiens frequency\n")
	randomFasta(out, homosapiens, n*5)
	out.Flush()
}
