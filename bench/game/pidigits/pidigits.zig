// pidigits: the digits of pi, by the unbounded spigot algorithm on GMP integers.
const std = @import("std");
const c = @import("c.zig"); // gmp.h, by zig translate-c (run.py writes it)

var tmp1: c.mpz_t = undefined;
var tmp2: c.mpz_t = undefined;
var acc: c.mpz_t = undefined;
var den: c.mpz_t = undefined;
var num: c.mpz_t = undefined;

fn extractDigit(nth: c_ulong) c_ulong {
    c.mpz_mul_ui(&tmp1, &num, nth);
    c.mpz_add(&tmp2, &tmp1, &acc);
    c.mpz_tdiv_q(&tmp1, &tmp2, &den);
    return c.mpz_get_ui(&tmp1);
}

fn eliminateDigit(d: c_ulong) void {
    c.mpz_submul_ui(&acc, &den, d);
    c.mpz_mul_ui(&acc, &acc, 10);
    c.mpz_mul_ui(&num, &num, 10);
}

fn nextTerm(k: c_ulong) void {
    const k2 = k * 2 + 1;
    c.mpz_addmul_ui(&acc, &num, 2);
    c.mpz_mul_ui(&acc, &acc, k2);
    c.mpz_mul_ui(&den, &den, k2);
    c.mpz_mul_ui(&num, &num, k);
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const n = if (args.len > 1) try std.fmt.parseInt(usize, args[1], 10) else 30;

    var buf: [4096]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &buf);
    const out = &stdout.interface;

    c.mpz_init(&tmp1);
    c.mpz_init(&tmp2);
    c.mpz_init_set_ui(&acc, 0);
    c.mpz_init_set_ui(&den, 1);
    c.mpz_init_set_ui(&num, 1);
    var digits: [10]u8 = undefined;
    var nd: usize = 0;
    var k: c_ulong = 0;
    var i: usize = 0;
    while (i < n) {
        k += 1;
        nextTerm(k);
        if (c.mpz_cmp(&num, &acc) > 0) continue;
        const d = extractDigit(3);
        if (d != extractDigit(4)) continue;
        digits[nd] = '0' + @as(u8, @intCast(d));
        nd += 1;
        i += 1;
        if (nd == 10 or i == n) {
            @memset(digits[nd..], ' ');
            try out.print("{s}\t:{d}\n", .{ digits[0..], i });
            nd = 0;
        }
        eliminateDigit(d);
    }
    try out.flush();
}
