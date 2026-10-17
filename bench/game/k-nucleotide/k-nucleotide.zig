// k-nucleotide: count every k-nucleotide of the third sequence, k = 1 2 3 4 6 12 18.
const std = @import("std");

const Counts = std.AutoHashMap(u64, u32);

fn codeOf(c: u8) u64 {
    return switch (c) {
        'A' => 0,
        'C' => 1,
        'G' => 2,
        else => 3,
    };
}

fn countAll(gpa: std.mem.Allocator, seq: []const u8, k: usize) !Counts {
    var counts = Counts.init(gpa);
    const mask = (@as(u64, 1) << @intCast(2 * k)) - 1;
    var key: u64 = 0;
    for (seq[0 .. k - 1]) |c| key = (key << 2) | codeOf(c);
    for (seq[k - 1 ..]) |c| {
        key = ((key << 2) | codeOf(c)) & mask;
        const gop = try counts.getOrPut(key);
        if (gop.found_existing) gop.value_ptr.* += 1 else gop.value_ptr.* = 1;
    }
    return counts;
}

const Entry = struct { key: u64, count: u32 };

fn byCountThenKey(_: void, a: Entry, b: Entry) bool {
    if (a.count != b.count) return a.count > b.count;
    return a.key < b.key;
}

fn writeFrequencies(gpa: std.mem.Allocator, out: *std.Io.Writer, seq: []const u8, k: usize) !void {
    var counts = try countAll(gpa, seq, k);
    defer counts.deinit();
    const entries = try gpa.alloc(Entry, counts.count());
    defer gpa.free(entries);
    var it = counts.iterator();
    var n: usize = 0;
    while (it.next()) |kv| : (n += 1) entries[n] = .{ .key = kv.key_ptr.*, .count = kv.value_ptr.* };
    std.mem.sort(Entry, entries, {}, byCountThenKey);
    const total: f64 = @floatFromInt(seq.len - k + 1);
    var name: [32]u8 = undefined;
    for (entries) |e| {
        for (0..k) |j| name[j] = "ACGT"[@intCast((e.key >> @intCast(2 * (k - 1 - j))) & 3)];
        try out.print("{s} {d:.3}\n", .{ name[0..k], 100.0 * @as(f64, @floatFromInt(e.count)) / total });
    }
    try out.writeAll("\n");
}

fn writeCount(gpa: std.mem.Allocator, out: *std.Io.Writer, seq: []const u8, frag: []const u8) !void {
    var counts = try countAll(gpa, seq, frag.len);
    defer counts.deinit();
    var key: u64 = 0;
    for (frag) |c| key = (key << 2) | codeOf(c);
    try out.print("{d}\t{s}\n", .{ counts.get(key) orelse 0, frag });
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    var in_buf: [1 << 16]u8 = undefined;
    var stdin: std.Io.File.Reader = .init(.stdin(), init.io, &in_buf);
    const input = try stdin.interface.allocRemaining(gpa, .unlimited);
    defer gpa.free(input);

    // the sequence after the ">THREE" header line, upper-cased, newlines dropped
    var i: usize = 0;
    while (!std.mem.startsWith(u8, input[i..], ">THREE")) {
        i += std.mem.indexOfScalar(u8, input[i..], '\n').? + 1;
    }
    i += std.mem.indexOfScalar(u8, input[i..], '\n').? + 1;
    var n: usize = 0;
    while (i < input.len) : (i += 1) {
        if (input[i] != '\n') {
            input[n] = input[i] & ~@as(u8, 0x20);
            n += 1;
        }
    }
    const seq = input[0..n];

    var out_buf: [1 << 16]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &out_buf);
    const out = &stdout.interface;
    try writeFrequencies(gpa, out, seq, 1);
    try writeFrequencies(gpa, out, seq, 2);
    for ([_][]const u8{ "GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT" }) |frag| {
        try writeCount(gpa, out, seq, frag);
    }
    try out.flush();
}
