// regex-redux: match and replace DNA patterns with the regexp package.
package main

import (
	"fmt"
	"io"
	"os"
	"regexp"
)

var variants = []string{
	"agggtaaa|tttaccct",
	"[cgt]gggtaaa|tttaccc[acg]",
	"a[act]ggtaaa|tttacc[agt]t",
	"ag[act]gtaaa|tttac[agt]ct",
	"agg[act]taaa|ttta[agt]cct",
	"aggg[acg]aaa|ttt[cgt]ccct",
	"agggt[cgt]aa|tt[acg]accct",
	"agggta[cgt]a|t[acg]taccct",
	"agggtaa[cgt]|[acg]ttaccct",
}

var subst = [][2]string{
	{"tHa[Nt]", "<4>"},
	{"aND|caN|Ha[DS]|WaS", "<3>"},
	{"a[NSt]|BY", "<2>"},
	{"<[^>]*>", "|"},
	{"\\|[^|][^|]*\\|", "-"},
}

func main() {
	input, _ := io.ReadAll(os.Stdin)
	ilen := len(input)
	seq := regexp.MustCompile(">.*\n|\n").ReplaceAllLiteral(input, nil)
	clen := len(seq)

	for _, v := range variants {
		fmt.Printf("%s %d\n", v, len(regexp.MustCompile(v).FindAllIndex(seq, -1)))
	}
	text := seq
	for _, s := range subst {
		text = regexp.MustCompile(s[0]).ReplaceAllLiteral(text, []byte(s[1]))
	}
	fmt.Printf("\n%d\n%d\n%d\n", ilen, clen, len(text))
}
