// k-nucleotide: count every k-nucleotide of the third sequence, k = 1 2 3 4 6 12 18.
package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"os"
	"sort"
)

func codeOf(c byte) uint64 {
	switch c {
	case 'A':
		return 0
	case 'C':
		return 1
	case 'G':
		return 2
	}
	return 3
}

func countAll(seq []byte, k int) map[uint64]uint32 {
	counts := make(map[uint64]uint32)
	mask := uint64(1)<<(2*k) - 1
	var key uint64
	for _, c := range seq[:k-1] {
		key = key<<2 | codeOf(c)
	}
	for _, c := range seq[k-1:] {
		key = (key<<2 | codeOf(c)) & mask
		counts[key]++
	}
	return counts
}

type entry struct {
	key   uint64
	count uint32
}

func writeFrequencies(out *bufio.Writer, seq []byte, k int) {
	counts := countAll(seq, k)
	entries := make([]entry, 0, len(counts))
	for key, c := range counts {
		entries = append(entries, entry{key, c})
	}
	sort.Slice(entries, func(a, b int) bool {
		if entries[a].count != entries[b].count {
			return entries[a].count > entries[b].count
		}
		return entries[a].key < entries[b].key
	})
	total := float64(len(seq) - k + 1)
	name := make([]byte, k)
	for _, e := range entries {
		for j := 0; j < k; j++ {
			name[j] = "ACGT"[(e.key>>(2*(k-1-j)))&3]
		}
		fmt.Fprintf(out, "%s %.3f\n", name, 100.0*float64(e.count)/total)
	}
	out.WriteString("\n")
}

func writeCount(out *bufio.Writer, seq []byte, frag string) {
	counts := countAll(seq, len(frag))
	var key uint64
	for i := 0; i < len(frag); i++ {
		key = key<<2 | codeOf(frag[i])
	}
	fmt.Fprintf(out, "%d\t%s\n", counts[key], frag)
}

func main() {
	input, _ := io.ReadAll(os.Stdin)
	// the sequence after the ">THREE" header line, upper-cased, newlines dropped
	i := 0
	for !bytes.HasPrefix(input[i:], []byte(">THREE")) {
		i += bytes.IndexByte(input[i:], '\n') + 1
	}
	i += bytes.IndexByte(input[i:], '\n') + 1
	n := 0
	for ; i < len(input); i++ {
		if input[i] != '\n' {
			input[n] = input[i] &^ 0x20
			n++
		}
	}
	seq := input[:n]

	out := bufio.NewWriter(os.Stdout)
	writeFrequencies(out, seq, 1)
	writeFrequencies(out, seq, 2)
	for _, frag := range []string{"GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"} {
		writeCount(out, seq, frag)
	}
	out.Flush()
}
