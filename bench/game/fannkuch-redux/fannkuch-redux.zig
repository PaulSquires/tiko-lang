// fannkuch-redux: the most pancake flips over all permutations of 0..n-1.
const std = @import("std");

const Result = struct { checksum: i32, max_flips: i32 };

fn fannkuch(n: usize) Result {
    var perm: [16]usize = undefined;
    var perm1: [16]usize = undefined;
    var count: [16]usize = undefined;
    var max_flips: i32 = 0;
    var checksum: i32 = 0;
    var perm_count: u64 = 0;
    var r = n;
    for (0..n) |i| perm1[i] = i;
    while (true) {
        while (r != 1) : (r -= 1) count[r - 1] = r;
        @memcpy(perm[0..n], perm1[0..n]);
        var flips: i32 = 0;
        var k = perm[0];
        while (k != 0) : (k = perm[0]) {
            const k2 = (k + 1) >> 1;
            for (0..k2) |i| std.mem.swap(usize, &perm[i], &perm[k - i]);
            flips += 1;
        }
        if (flips > max_flips) max_flips = flips;
        checksum += if (perm_count % 2 == 0) flips else -flips;
        while (true) {
            if (r == n) return .{ .checksum = checksum, .max_flips = max_flips };
            const perm0 = perm1[0];
            for (0..r) |i| perm1[i] = perm1[i + 1];
            perm1[r] = perm0;
            count[r] -= 1;
            if (count[r] > 0) break;
            r += 1;
        }
        perm_count += 1;
    }
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const n = if (args.len > 1) try std.fmt.parseInt(usize, args[1], 10) else 7;
    const res = fannkuch(n);

    var buf: [256]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &buf);
    try stdout.interface.print("{d}\nPfannkuchen({d}) = {d}\n", .{ res.checksum, n, res.max_flips });
    try stdout.interface.flush();
}
