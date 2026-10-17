// mandelbrot: the Mandelbrot set as a 1-bit portable bitmap.

use std::io::Write;

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(200);
    let (w, h) = (n, n);
    let mut bitmap = Vec::with_capacity((w + 7) / 8 * h);
    for y in 0..h {
        let ci = 2.0 * y as f64 / h as f64 - 1.0;
        let mut byte: u32 = 0;
        let mut bits = 0;
        for x in 0..w {
            let cr = 2.0 * x as f64 / w as f64 - 1.5;
            let (mut zr, mut zi, mut tr, mut ti) = (0.0f64, 0.0f64, 0.0f64, 0.0f64);
            let mut i = 0;
            while i < 50 && tr + ti <= 4.0 {
                zi = (zr + zr) * zi + ci;
                zr = tr - ti + cr;
                tr = zr * zr;
                ti = zi * zi;
                i += 1;
            }
            byte = (byte << 1) | (tr + ti <= 4.0) as u32;
            bits += 1;
            if bits == 8 {
                bitmap.push(byte as u8);
                byte = 0;
                bits = 0;
            }
        }
        if bits > 0 {
            bitmap.push((byte << (8 - bits)) as u8);
        }
    }
    let stdout = std::io::stdout();
    let mut out = stdout.lock();
    write!(out, "P4\n{} {}\n", w, h).unwrap();
    out.write_all(&bitmap).unwrap();
}
