// reverse-complement: write the reverse complement of each DNA sequence.
package main

import (
	"io"
	"os"
)

const line = 60

func main() {
	var comp [256]byte
	for i := range comp {
		comp[i] = byte(i)
	}
	from := "ACBDGHKMNSRUTWVYacbdghkmnsrutwvy"
	to := "TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR"
	for i := 0; i < len(from); i++ {
		comp[from[i]] = to[i]
	}

	input, _ := io.ReadAll(os.Stdin)
	n := len(input)
	seq := make([]byte, 0, n)
	out := make([]byte, 0, n+n/line+2)
	i := 0
	for i < n {
		// header line, copied as is
		start := i
		for i < n && input[i] != '\n' {
			i++
		}
		out = append(out, input[start:i]...)
		out = append(out, '\n')
		i++
		// sequence lines up to the next header, newlines dropped
		seq = seq[:0]
		for i < n && input[i] != '>' {
			if input[i] != '\n' {
				seq = append(seq, input[i])
			}
			i++
		}
		// reversed and complemented, line to a line
		col := 0
		for s := len(seq) - 1; s >= 0; s-- {
			out = append(out, comp[seq[s]])
			col++
			if col == line {
				out = append(out, '\n')
				col = 0
			}
		}
		if col > 0 {
			out = append(out, '\n')
		}
	}
	os.Stdout.Write(out)
}
