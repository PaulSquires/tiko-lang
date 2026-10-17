// binary-trees: allocate, walk and drop many perfect binary trees (Go's GC frees them).
package main

import (
	"fmt"
	"os"
	"strconv"
)

type Node struct {
	left, right *Node
}

func bottomUp(depth int) *Node {
	if depth > 0 {
		return &Node{bottomUp(depth - 1), bottomUp(depth - 1)}
	}
	return &Node{}
}

func (t *Node) check() int {
	if t.left == nil {
		return 1
	}
	return 1 + t.left.check() + t.right.check()
}

func main() {
	n := 10
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	minDepth := 4
	maxDepth := n
	if minDepth+2 > n {
		maxDepth = minDepth + 2
	}
	stretch := maxDepth + 1

	fmt.Printf("stretch tree of depth %d\t check: %d\n", stretch, bottomUp(stretch).check())

	longLived := bottomUp(maxDepth)
	for depth := minDepth; depth <= maxDepth; depth += 2 {
		iterations := 1 << (maxDepth - depth + minDepth)
		sum := 0
		for i := 0; i < iterations; i++ {
			sum += bottomUp(depth).check()
		}
		fmt.Printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, sum)
	}
	fmt.Printf("long lived tree of depth %d\t check: %d\n", maxDepth, longLived.check())
}
