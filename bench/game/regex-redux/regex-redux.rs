// regex-redux: match and replace DNA patterns with the regex crate.
// Built by cargo from rust/Cargo.toml, which pins the crate in Cargo.lock.

use std::io::{Read, Write};

use regex::bytes::Regex;

const VARIANTS: [&str; 9] = [
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct",
    "agggtaa[cgt]|[acg]ttaccct",
];

const SUBST: [(&str, &str); 5] = [
    ("tHa[Nt]", "<4>"),
    ("aND|caN|Ha[DS]|WaS", "<3>"),
    ("a[NSt]|BY", "<2>"),
    ("<[^>]*>", "|"),
    ("\\|[^|][^|]*\\|", "-"),
];

fn main() {
    let mut input = Vec::new();
    std::io::stdin().lock().read_to_end(&mut input).unwrap();
    let ilen = input.len();
    let seq = Regex::new(">.*\n|\n").unwrap().replace_all(&input, &b""[..]).into_owned();
    let clen = seq.len();

    let stdout = std::io::stdout();
    let mut out = stdout.lock();
    for v in VARIANTS {
        writeln!(out, "{} {}", v, Regex::new(v).unwrap().find_iter(&seq).count()).unwrap();
    }
    let mut text = seq;
    for (pat, rep) in SUBST {
        // NoExpand: the replacements are literal text, not $-templates
        text = Regex::new(pat)
            .unwrap()
            .replace_all(&text, regex::bytes::NoExpand(rep.as_bytes()))
            .into_owned();
    }
    writeln!(out, "\n{}\n{}\n{}", ilen, clen, text.len()).unwrap();
}
