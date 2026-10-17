// fasta: generate DNA sequences by copying and by weighted random selection.

use std::io::{BufWriter, Write};

const LINE: usize = 60;
const IM: i32 = 139968;
const IA: i32 = 3877;
const IC: i32 = 29573;

const ALU: &[u8] = b"GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG\
GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA\
CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT\
ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA\
GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG\
AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC\
AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

const IUB: [(u8, f64); 15] = [
    (b'a', 0.27), (b'c', 0.12), (b'g', 0.12), (b't', 0.27),
    (b'B', 0.02), (b'D', 0.02), (b'H', 0.02), (b'K', 0.02),
    (b'M', 0.02), (b'N', 0.02), (b'R', 0.02), (b'S', 0.02),
    (b'V', 0.02), (b'W', 0.02), (b'Y', 0.02),
];

const HOMOSAPIENS: [(u8, f64); 4] = [
    (b'a', 0.3029549426680), (b'c', 0.1979883004921),
    (b'g', 0.1975473066391), (b't', 0.3015094502008),
];

struct Rng {
    seed: i32,
}

impl Rng {
    fn next(&mut self) -> f64 {
        self.seed = (self.seed * IA + IC) % IM;
        1.0 * self.seed as f64 / IM as f64
    }
}

fn repeat_fasta(out: &mut impl Write, s: &[u8], mut n: usize) {
    let mut doubled = s.to_vec();
    doubled.extend_from_slice(&s[..LINE]);
    let mut line = [0u8; LINE + 1];
    let mut pos = 0;
    while n > 0 {
        let count = n.min(LINE);
        line[..count].copy_from_slice(&doubled[pos..pos + count]);
        line[count] = b'\n';
        out.write_all(&line[..count + 1]).unwrap();
        pos += count;
        if pos > s.len() {
            pos -= s.len();
        }
        n -= count;
    }
}

fn random_fasta(out: &mut impl Write, rng: &mut Rng, table: &[(u8, f64)], mut n: usize) {
    let mut cum = Vec::with_capacity(table.len());
    let mut p = 0.0;
    for &(_, prob) in table {
        p += prob;
        cum.push(p);
    }
    let last = table.len() - 1;
    let mut line = [0u8; LINE + 1];
    while n > 0 {
        let count = n.min(LINE);
        for c in line[..count].iter_mut() {
            let r = rng.next();
            let mut j = 0;
            while j < last && r >= cum[j] {
                j += 1;
            }
            *c = table[j].0;
        }
        line[count] = b'\n';
        out.write_all(&line[..count + 1]).unwrap();
        n -= count;
    }
}

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(1000);
    let stdout = std::io::stdout();
    let mut out = BufWriter::with_capacity(1 << 16, stdout.lock());
    let mut rng = Rng { seed: 42 };
    out.write_all(b">ONE Homo sapiens alu\n").unwrap();
    repeat_fasta(&mut out, ALU, n * 2);
    out.write_all(b">TWO IUB ambiguity codes\n").unwrap();
    random_fasta(&mut out, &mut rng, &IUB, n * 3);
    out.write_all(b">THREE Homo sapiens frequency\n").unwrap();
    random_fasta(&mut out, &mut rng, &HOMOSAPIENS, n * 5);
    out.flush().unwrap();
}
