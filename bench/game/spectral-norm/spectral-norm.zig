// spectral-norm: the spectral norm of an infinite matrix, by the power method.
const std = @import("std");

fn a(i: i32, j: i32) f64 {
    return 1.0 / @as(f64, @floatFromInt(@divTrunc((i + j) * (i + j + 1), 2) + i + 1));
}

fn multAv(v: []const f64, av: []f64) void {
    for (av, 0..) |*out, i| {
        var sum: f64 = 0.0;
        for (v, 0..) |x, j| sum += a(@intCast(i), @intCast(j)) * x;
        out.* = sum;
    }
}

fn multAtv(v: []const f64, atv: []f64) void {
    for (atv, 0..) |*out, i| {
        var sum: f64 = 0.0;
        for (v, 0..) |x, j| sum += a(@intCast(j), @intCast(i)) * x;
        out.* = sum;
    }
}

fn multAtAv(v: []const f64, atav: []f64, tmp: []f64) void {
    multAv(v, tmp);
    multAtv(tmp, atav);
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const n = if (args.len > 1) try std.fmt.parseInt(usize, args[1], 10) else 100;
    const gpa = init.gpa;

    const u = try gpa.alloc(f64, n);
    defer gpa.free(u);
    const v = try gpa.alloc(f64, n);
    defer gpa.free(v);
    const tmp = try gpa.alloc(f64, n);
    defer gpa.free(tmp);
    @memset(u, 1.0);
    for (0..10) |_| {
        multAtAv(u, v, tmp);
        multAtAv(v, u, tmp);
    }
    var vbv: f64 = 0.0;
    var vv: f64 = 0.0;
    for (0..n) |i| {
        vbv += u[i] * v[i];
        vv += v[i] * v[i];
    }

    var buf: [256]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &buf);
    try stdout.interface.print("{d:.9}\n", .{@sqrt(vbv / vv)});
    try stdout.interface.flush();
}
