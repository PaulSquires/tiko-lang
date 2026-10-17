// fannkuch-redux: the most pancake flips over all permutations of 0..n-1.

fn fannkuch(n: usize) -> (i32, i32) {
    let mut perm = [0usize; 16];
    let mut perm1 = [0usize; 16];
    let mut count = [0usize; 16];
    let mut max_flips = 0;
    let mut checksum = 0;
    let mut perm_count = 0;
    let mut r = n;
    for (i, p) in perm1.iter_mut().enumerate().take(n) {
        *p = i;
    }
    loop {
        while r != 1 {
            count[r - 1] = r;
            r -= 1;
        }
        perm[..n].copy_from_slice(&perm1[..n]);
        let mut flips = 0;
        loop {
            let k = perm[0];
            if k == 0 {
                break;
            }
            let k2 = (k + 1) >> 1;
            for i in 0..k2 {
                perm.swap(i, k - i);
            }
            flips += 1;
        }
        if flips > max_flips {
            max_flips = flips;
        }
        checksum += if perm_count % 2 == 0 { flips } else { -flips };
        loop {
            if r == n {
                return (checksum, max_flips);
            }
            let perm0 = perm1[0];
            for i in 0..r {
                perm1[i] = perm1[i + 1];
            }
            perm1[r] = perm0;
            count[r] -= 1;
            if count[r] > 0 {
                break;
            }
            r += 1;
        }
        perm_count += 1;
    }
}

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(7);
    let (checksum, max_flips) = fannkuch(n);
    println!("{}\nPfannkuchen({}) = {}", checksum, n, max_flips);
}
