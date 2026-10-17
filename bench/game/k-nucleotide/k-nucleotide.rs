// k-nucleotide: count every k-nucleotide of the third sequence, k = 1 2 3 4 6 12 18.

use std::collections::HashMap;
use std::hash::{BuildHasherDefault, Hasher};
use std::io::{Read, Write};

// std's default SipHash is built to resist hash flooding, not for speed; the
// other languages' maps use fast hashes, so this one does too (std only).
#[derive(Default)]
struct MulHasher(u64);

impl Hasher for MulHasher {
    fn finish(&self) -> u64 {
        self.0
    }
    fn write(&mut self, _: &[u8]) {
        unreachable!()
    }
    fn write_u64(&mut self, k: u64) {
        let h = k.wrapping_mul(0x9E3779B97F4A7C15);
        self.0 = h ^ (h >> 32);
    }
}

type Counts = HashMap<u64, u32, BuildHasherDefault<MulHasher>>;

fn code_of(c: u8) -> u64 {
    match c {
        b'A' => 0,
        b'C' => 1,
        b'G' => 2,
        _ => 3,
    }
}

fn count_all(seq: &[u8], k: usize) -> Counts {
    let mut counts = Counts::default();
    let mask = (1u64 << (2 * k)) - 1;
    let mut key = 0u64;
    for &c in &seq[..k - 1] {
        key = (key << 2) | code_of(c);
    }
    for &c in &seq[k - 1..] {
        key = ((key << 2) | code_of(c)) & mask;
        *counts.entry(key).or_insert(0) += 1;
    }
    counts
}

fn write_frequencies(out: &mut impl Write, seq: &[u8], k: usize) {
    let counts = count_all(seq, k);
    let mut entries: Vec<(u64, u32)> = counts.into_iter().collect();
    entries.sort_by(|a, b| b.1.cmp(&a.1).then(a.0.cmp(&b.0)));
    let total = (seq.len() - k + 1) as f64;
    for (key, count) in entries {
        let name: String = (0..k)
            .map(|j| b"ACGT"[((key >> (2 * (k - 1 - j))) & 3) as usize] as char)
            .collect();
        writeln!(out, "{} {:.3}", name, 100.0 * count as f64 / total).unwrap();
    }
    writeln!(out).unwrap();
}

fn write_count(out: &mut impl Write, seq: &[u8], frag: &str) {
    let counts = count_all(seq, frag.len());
    let key = frag.bytes().fold(0u64, |k, c| (k << 2) | code_of(c));
    writeln!(out, "{}\t{}", counts.get(&key).copied().unwrap_or(0), frag).unwrap();
}

fn main() {
    let mut input = Vec::new();
    std::io::stdin().lock().read_to_end(&mut input).unwrap();
    // the sequence after the ">THREE" header line, upper-cased, newlines dropped
    let mut i = 0;
    while !input[i..].starts_with(b">THREE") {
        while input[i] != b'\n' {
            i += 1;
        }
        i += 1;
    }
    while input[i] != b'\n' {
        i += 1;
    }
    i += 1;
    let mut n = 0;
    for j in i..input.len() {
        if input[j] != b'\n' {
            input[n] = input[j] & !0x20;
            n += 1;
        }
    }
    let seq = &input[..n];

    let stdout = std::io::stdout();
    let mut out = stdout.lock();
    write_frequencies(&mut out, seq, 1);
    write_frequencies(&mut out, seq, 2);
    for frag in ["GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"] {
        write_count(&mut out, seq, frag);
    }
}
