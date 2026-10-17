// regex-redux: match and replace DNA patterns with PCRE2 (JIT).
const std = @import("std");
const c = @import("c.zig"); // pcre2.h, by zig translate-c (run.py writes it)

const variants = [_][]const u8{
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct",
    "agggtaa[cgt]|[acg]ttaccct",
};

const subst = [_][2][]const u8{
    .{ "tHa[Nt]", "<4>" },
    .{ "aND|caN|Ha[DS]|WaS", "<3>" },
    .{ "a[NSt]|BY", "<2>" },
    .{ "<[^>]*>", "|" },
    .{ "\\|[^|][^|]*\\|", "-" },
};

fn compile(pattern: []const u8) *c.pcre2_code_8 {
    var err: c_int = 0;
    var off: usize = 0;
    const re = c.pcre2_compile_8(pattern.ptr, pattern.len, 0, &err, &off, null).?;
    _ = c.pcre2_jit_compile_8(re, c.PCRE2_JIT_COMPLETE);
    return re;
}

fn countMatches(pattern: []const u8, s: []const u8) usize {
    const re = compile(pattern);
    defer c.pcre2_code_free_8(re);
    const md = c.pcre2_match_data_create_from_pattern_8(re, null);
    defer c.pcre2_match_data_free_8(md);
    const ov = c.pcre2_get_ovector_pointer_8(md);
    var count: usize = 0;
    var off: usize = 0;
    while (c.pcre2_jit_match_8(re, s.ptr, s.len, off, 0, md, null) > 0) {
        count += 1;
        off = ov[1];
    }
    return count;
}

/// Every match of pattern in src replaced by rep, into dst; returns dst's length.
fn replaceAll(pattern: []const u8, src: []const u8, rep: []const u8, dst: []u8) usize {
    const re = compile(pattern);
    defer c.pcre2_code_free_8(re);
    const md = c.pcre2_match_data_create_from_pattern_8(re, null);
    defer c.pcre2_match_data_free_8(md);
    const ov = c.pcre2_get_ovector_pointer_8(md);
    var o: usize = 0;
    var off: usize = 0;
    while (c.pcre2_jit_match_8(re, src.ptr, src.len, off, 0, md, null) > 0) {
        @memcpy(dst[o..][0 .. ov[0] - off], src[off..ov[0]]);
        o += ov[0] - off;
        @memcpy(dst[o..][0..rep.len], rep);
        o += rep.len;
        off = ov[1];
    }
    @memcpy(dst[o..][0 .. src.len - off], src[off..]);
    return o + src.len - off;
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    var in_buf: [1 << 16]u8 = undefined;
    var stdin: std.Io.File.Reader = .init(.stdin(), init.io, &in_buf);
    const input = try stdin.interface.allocRemaining(gpa, .unlimited);
    defer gpa.free(input);
    const ilen = input.len;
    // room for the substitutions, which can lengthen the text
    var a = try gpa.alloc(u8, ilen * 2 + 16);
    defer gpa.free(a);
    var b = try gpa.alloc(u8, ilen * 2 + 16);
    defer gpa.free(b);
    const clen = replaceAll(">.*\n|\n", input, "", a);

    var buf: [4096]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &buf);
    const out = &stdout.interface;
    for (variants) |v| try out.print("{s} {d}\n", .{ v, countMatches(v, a[0..clen]) });

    var len = clen;
    for (subst) |s| {
        len = replaceAll(s[0], a[0..len], s[1], b);
        std.mem.swap([]u8, &a, &b);
    }
    try out.print("\n{d}\n{d}\n{d}\n", .{ ilen, clen, len });
    try out.flush();
}
