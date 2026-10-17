// pidigits: the digits of pi, by the unbounded spigot algorithm on GMP integers.
//
// GMP through a hand-written FFI (no crate). mpz_* in gmp.h are macros naming
// the __gmpz_* functions, so those are the names declared here.

use std::io::Write;
use std::mem::MaybeUninit;
use std::os::raw::{c_int, c_ulong, c_void};

#[repr(C)]
struct Mpz {
    alloc: c_int,
    size: c_int,
    d: *mut c_void,
}

extern "C" {
    fn __gmpz_init(r: *mut Mpz);
    fn __gmpz_init_set_ui(r: *mut Mpz, v: c_ulong);
    fn __gmpz_mul_ui(r: *mut Mpz, a: *const Mpz, b: c_ulong);
    fn __gmpz_add(r: *mut Mpz, a: *const Mpz, b: *const Mpz);
    fn __gmpz_tdiv_q(q: *mut Mpz, n: *const Mpz, d: *const Mpz);
    fn __gmpz_get_ui(a: *const Mpz) -> c_ulong;
    fn __gmpz_submul_ui(r: *mut Mpz, a: *const Mpz, b: c_ulong);
    fn __gmpz_addmul_ui(r: *mut Mpz, a: *const Mpz, b: c_ulong);
    fn __gmpz_cmp(a: *const Mpz, b: *const Mpz) -> c_int;
}

struct Spigot {
    tmp1: Mpz,
    tmp2: Mpz,
    acc: Mpz,
    den: Mpz,
    num: Mpz,
}

impl Spigot {
    fn new() -> Spigot {
        unsafe {
            let mut s = MaybeUninit::<Spigot>::uninit();
            let p = s.as_mut_ptr();
            __gmpz_init(&mut (*p).tmp1);
            __gmpz_init(&mut (*p).tmp2);
            __gmpz_init_set_ui(&mut (*p).acc, 0);
            __gmpz_init_set_ui(&mut (*p).den, 1);
            __gmpz_init_set_ui(&mut (*p).num, 1);
            s.assume_init()
        }
    }

    fn extract_digit(&mut self, nth: c_ulong) -> c_ulong {
        unsafe {
            __gmpz_mul_ui(&mut self.tmp1, &self.num, nth);
            __gmpz_add(&mut self.tmp2, &self.tmp1, &self.acc);
            __gmpz_tdiv_q(&mut self.tmp1, &self.tmp2, &self.den);
            __gmpz_get_ui(&self.tmp1)
        }
    }

    fn eliminate_digit(&mut self, d: c_ulong) {
        unsafe {
            __gmpz_submul_ui(&mut self.acc, &self.den, d);
            let acc: *mut Mpz = &mut self.acc;
            __gmpz_mul_ui(acc, acc, 10);
            let num: *mut Mpz = &mut self.num;
            __gmpz_mul_ui(num, num, 10);
        }
    }

    fn next_term(&mut self, k: c_ulong) {
        let k2 = k * 2 + 1;
        unsafe {
            __gmpz_addmul_ui(&mut self.acc, &self.num, 2);
            let acc: *mut Mpz = &mut self.acc;
            __gmpz_mul_ui(acc, acc, k2);
            let den: *mut Mpz = &mut self.den;
            __gmpz_mul_ui(den, den, k2);
            let num: *mut Mpz = &mut self.num;
            __gmpz_mul_ui(num, num, k);
        }
    }

    fn num_gt_acc(&self) -> bool {
        unsafe { __gmpz_cmp(&self.num, &self.acc) > 0 }
    }
}

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(30);
    let stdout = std::io::stdout();
    let mut out = stdout.lock();
    let mut s = Spigot::new();
    let mut digits = String::with_capacity(10);
    let mut k = 0;
    let mut i = 0;
    while i < n {
        k += 1;
        s.next_term(k);
        if s.num_gt_acc() {
            continue;
        }
        let d = s.extract_digit(3);
        if d != s.extract_digit(4) {
            continue;
        }
        digits.push((b'0' + d as u8) as char);
        i += 1;
        if digits.len() == 10 || i == n {
            writeln!(out, "{:<10}\t:{}", digits, i).unwrap();
            digits.clear();
        }
        s.eliminate_digit(d);
    }
}
