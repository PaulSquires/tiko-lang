// binary-trees: allocate, walk and free many perfect binary trees.

struct Node {
    children: Option<(Box<Node>, Box<Node>)>,
}

fn bottom_up(depth: i32) -> Box<Node> {
    if depth > 0 {
        Box::new(Node { children: Some((bottom_up(depth - 1), bottom_up(depth - 1))) })
    } else {
        Box::new(Node { children: None })
    }
}

fn check(t: &Node) -> i32 {
    match &t.children {
        None => 1,
        Some((l, r)) => 1 + check(l) + check(r),
    }
}

fn main() {
    let n: i32 = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(10);
    let min_depth = 4;
    let max_depth = if n > min_depth + 2 { n } else { min_depth + 2 };
    let stretch = max_depth + 1;

    let t = bottom_up(stretch);
    println!("stretch tree of depth {}\t check: {}", stretch, check(&t));
    drop(t);

    let long_lived = bottom_up(max_depth);
    let mut depth = min_depth;
    while depth <= max_depth {
        let iterations = 1 << (max_depth - depth + min_depth);
        let mut sum = 0;
        for _ in 0..iterations {
            let t = bottom_up(depth);
            sum += check(&t);
        }
        println!("{}\t trees of depth {}\t check: {}", iterations, depth, sum);
        depth += 2;
    }
    println!("long lived tree of depth {}\t check: {}", max_depth, check(&long_lived));
}
