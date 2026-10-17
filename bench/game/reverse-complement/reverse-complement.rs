// reverse-complement: write the reverse complement of each DNA sequence.

use std::io::{Read, Write};

const LINE: usize = 60;

fn main() {
    let mut comp = [0u8; 256];
    for (i, c) in comp.iter_mut().enumerate() {
        *c = i as u8;
    }
    let from = b"ACBDGHKMNSRUTWVYacbdghkmnsrutwvy";
    let to = b"TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR";
    for (f, t) in from.iter().zip(to.iter()) {
        comp[*f as usize] = *t;
    }

    let mut input = Vec::new();
    std::io::stdin().lock().read_to_end(&mut input).unwrap();
    let len = input.len();
    let mut seq = Vec::with_capacity(len);
    let mut out = Vec::with_capacity(len + len / LINE + 2);
    let mut i = 0;
    while i < len {
        // header line, copied as is
        let start = i;
        while i < len && input[i] != b'\n' {
            i += 1;
        }
        out.extend_from_slice(&input[start..i]);
        out.push(b'\n');
        i += 1;
        // sequence lines up to the next header, newlines dropped
        seq.clear();
        while i < len && input[i] != b'>' {
            if input[i] != b'\n' {
                seq.push(input[i]);
            }
            i += 1;
        }
        // reversed and complemented, LINE to a line
        let mut col = 0;
        for &c in seq.iter().rev() {
            out.push(comp[c as usize]);
            col += 1;
            if col == LINE {
                out.push(b'\n');
                col = 0;
            }
        }
        if col > 0 {
            out.push(b'\n');
        }
    }
    std::io::stdout().lock().write_all(&out).unwrap();
}
