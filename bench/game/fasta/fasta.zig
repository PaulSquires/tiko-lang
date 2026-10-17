// fasta: generate DNA sequences by copying and by weighted random selection.
const std = @import("std");

const LINE = 60;
const IM = 139968;
const IA = 3877;
const IC = 29573;

const alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" ++
    "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" ++
    "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" ++
    "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" ++
    "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" ++
    "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" ++
    "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

const Freq = struct { c: u8, p: f64 };

const iub = [_]Freq{
    .{ .c = 'a', .p = 0.27 }, .{ .c = 'c', .p = 0.12 }, .{ .c = 'g', .p = 0.12 }, .{ .c = 't', .p = 0.27 },
    .{ .c = 'B', .p = 0.02 }, .{ .c = 'D', .p = 0.02 }, .{ .c = 'H', .p = 0.02 }, .{ .c = 'K', .p = 0.02 },
    .{ .c = 'M', .p = 0.02 }, .{ .c = 'N', .p = 0.02 }, .{ .c = 'R', .p = 0.02 }, .{ .c = 'S', .p = 0.02 },
    .{ .c = 'V', .p = 0.02 }, .{ .c = 'W', .p = 0.02 }, .{ .c = 'Y', .p = 0.02 },
};

const homosapiens = [_]Freq{
    .{ .c = 'a', .p = 0.3029549426680 }, .{ .c = 'c', .p = 0.1979883004921 },
    .{ .c = 'g', .p = 0.1975473066391 }, .{ .c = 't', .p = 0.3015094502008 },
};

var seed: i32 = 42;

fn rnd() f64 {
    seed = @rem(seed * IA + IC, IM);
    return 1.0 * @as(f64, @floatFromInt(seed)) / IM;
}

fn repeatFasta(out: *std.Io.Writer, s: []const u8, n_in: usize) !void {
    var doubled: [alu.len + LINE]u8 = undefined;
    @memcpy(doubled[0..s.len], s);
    @memcpy(doubled[s.len..][0..LINE], s[0..LINE]);
    var line: [LINE + 1]u8 = undefined;
    var pos: usize = 0;
    var n = n_in;
    while (n > 0) {
        const count = @min(n, LINE);
        @memcpy(line[0..count], doubled[pos..][0..count]);
        line[count] = '\n';
        try out.writeAll(line[0 .. count + 1]);
        pos += count;
        if (pos > s.len) pos -= s.len;
        n -= count;
    }
}

fn randomFasta(out: *std.Io.Writer, table: []const Freq, n_in: usize) !void {
    var cum: [16]f64 = undefined;
    var p: f64 = 0.0;
    for (table, 0..) |f, i| {
        p += f.p;
        cum[i] = p;
    }
    const last = table.len - 1;
    var line: [LINE + 1]u8 = undefined;
    var n = n_in;
    while (n > 0) {
        const count = @min(n, LINE);
        for (line[0..count]) |*c| {
            const r = rnd();
            var j: usize = 0;
            while (j < last and r >= cum[j]) j += 1;
            c.* = table[j].c;
        }
        line[count] = '\n';
        try out.writeAll(line[0 .. count + 1]);
        n -= count;
    }
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const n = if (args.len > 1) try std.fmt.parseInt(usize, args[1], 10) else 1000;

    var buf: [1 << 16]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &buf);
    const out = &stdout.interface;
    try out.writeAll(">ONE Homo sapiens alu\n");
    try repeatFasta(out, alu, n * 2);
    try out.writeAll(">TWO IUB ambiguity codes\n");
    try randomFasta(out, &iub, n * 3);
    try out.writeAll(">THREE Homo sapiens frequency\n");
    try randomFasta(out, &homosapiens, n * 5);
    try out.flush();
}
