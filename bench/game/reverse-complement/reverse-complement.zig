// reverse-complement: write the reverse complement of each DNA sequence.
const std = @import("std");

const LINE = 60;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    var comp: [256]u8 = undefined;
    for (&comp, 0..) |*c, i| c.* = @intCast(i);
    const from = "ACBDGHKMNSRUTWVYacbdghkmnsrutwvy";
    const to = "TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR";
    for (from, to) |f, t| comp[f] = t;

    var in_buf: [1 << 16]u8 = undefined;
    var stdin: std.Io.File.Reader = .init(.stdin(), init.io, &in_buf);
    const input = try stdin.interface.allocRemaining(gpa, .unlimited);
    defer gpa.free(input);
    const len = input.len;
    const seq = try gpa.alloc(u8, len);
    defer gpa.free(seq);
    const out = try gpa.alloc(u8, len + len / LINE + 2);
    defer gpa.free(out);
    var o: usize = 0;
    var i: usize = 0;
    while (i < len) {
        // header line, copied as is
        const start = i;
        while (i < len and input[i] != '\n') i += 1;
        @memcpy(out[o..][0 .. i - start], input[start..i]);
        o += i - start;
        out[o] = '\n';
        o += 1;
        i += 1;
        // sequence lines up to the next header, newlines dropped
        var s: usize = 0;
        while (i < len and input[i] != '>') : (i += 1) {
            if (input[i] != '\n') {
                seq[s] = input[i];
                s += 1;
            }
        }
        // reversed and complemented, LINE to a line
        var col: usize = 0;
        while (s > 0) {
            s -= 1;
            out[o] = comp[seq[s]];
            o += 1;
            col += 1;
            if (col == LINE) {
                out[o] = '\n';
                o += 1;
                col = 0;
            }
        }
        if (col > 0) {
            out[o] = '\n';
            o += 1;
        }
    }

    var out_buf: [1 << 16]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &out_buf);
    try stdout.interface.writeAll(out[0..o]);
    try stdout.interface.flush();
}
