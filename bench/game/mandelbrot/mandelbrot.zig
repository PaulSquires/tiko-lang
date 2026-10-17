// mandelbrot: the Mandelbrot set as a 1-bit portable bitmap.
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const n = if (args.len > 1) try std.fmt.parseInt(usize, args[1], 10) else 200;
    const w = n;
    const h = n;
    const gpa = init.gpa;

    const bitmap = try gpa.alloc(u8, (w + 7) / 8 * h);
    defer gpa.free(bitmap);
    var p: usize = 0;
    const wf: f64 = @floatFromInt(w);
    const hf: f64 = @floatFromInt(h);
    for (0..h) |y| {
        const ci = 2.0 * @as(f64, @floatFromInt(y)) / hf - 1.0;
        var byte: u32 = 0;
        var bits: u5 = 0;
        for (0..w) |x| {
            const cr = 2.0 * @as(f64, @floatFromInt(x)) / wf - 1.5;
            var zr: f64 = 0.0;
            var zi: f64 = 0.0;
            var tr: f64 = 0.0;
            var ti: f64 = 0.0;
            var i: u32 = 0;
            while (i < 50 and tr + ti <= 4.0) : (i += 1) {
                zi = (zr + zr) * zi + ci;
                zr = tr - ti + cr;
                tr = zr * zr;
                ti = zi * zi;
            }
            byte = (byte << 1) | @intFromBool(tr + ti <= 4.0);
            bits += 1;
            if (bits == 8) {
                bitmap[p] = @intCast(byte);
                p += 1;
                byte = 0;
                bits = 0;
            }
        }
        if (bits > 0) {
            bitmap[p] = @truncate(byte << (8 - bits));
            p += 1;
        }
    }

    var buf: [4096]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &buf);
    const out = &stdout.interface;
    try out.print("P4\n{d} {d}\n", .{ w, h });
    try out.writeAll(bitmap[0..p]);
    try out.flush();
}
