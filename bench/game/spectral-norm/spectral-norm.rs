// spectral-norm: the spectral norm of an infinite matrix, by the power method.

fn a(i: i32, j: i32) -> f64 {
    1.0 / ((i + j) * (i + j + 1) / 2 + i + 1) as f64
}

fn mult_av(v: &[f64], av: &mut [f64]) {
    for (i, out) in av.iter_mut().enumerate() {
        let mut sum = 0.0;
        for (j, x) in v.iter().enumerate() {
            sum += a(i as i32, j as i32) * x;
        }
        *out = sum;
    }
}

fn mult_atv(v: &[f64], atv: &mut [f64]) {
    for (i, out) in atv.iter_mut().enumerate() {
        let mut sum = 0.0;
        for (j, x) in v.iter().enumerate() {
            sum += a(j as i32, i as i32) * x;
        }
        *out = sum;
    }
}

fn mult_atav(v: &[f64], atav: &mut [f64], tmp: &mut [f64]) {
    mult_av(v, tmp);
    mult_atv(tmp, atav);
}

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(100);
    let mut u = vec![1.0; n];
    let mut v = vec![0.0; n];
    let mut tmp = vec![0.0; n];
    for _ in 0..10 {
        mult_atav(&u, &mut v, &mut tmp);
        mult_atav(&v, &mut u, &mut tmp);
    }
    let mut vbv = 0.0;
    let mut vv = 0.0;
    for i in 0..n {
        vbv += u[i] * v[i];
        vv += v[i] * v[i];
    }
    println!("{:.9}", (vbv / vv).sqrt());
}
