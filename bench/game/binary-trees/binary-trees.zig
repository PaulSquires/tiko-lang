// binary-trees: allocate, walk and free many perfect binary trees.
const std = @import("std");

const Node = struct { left: ?*Node, right: ?*Node };

fn bottomUp(gpa: std.mem.Allocator, depth: i32) !*Node {
    const t = try gpa.create(Node);
    if (depth > 0) {
        t.* = .{ .left = try bottomUp(gpa, depth - 1), .right = try bottomUp(gpa, depth - 1) };
    } else {
        t.* = .{ .left = null, .right = null };
    }
    return t;
}

fn check(t: *const Node) i32 {
    const l = t.left orelse return 1;
    return 1 + check(l) + check(t.right.?);
}

fn deleteTree(gpa: std.mem.Allocator, t: *Node) void {
    if (t.left) |l| {
        deleteTree(gpa, l);
        deleteTree(gpa, t.right.?);
    }
    gpa.destroy(t);
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const n = if (args.len > 1) try std.fmt.parseInt(i32, args[1], 10) else 10;
    const gpa = init.gpa;
    const min_depth: i32 = 4;
    const max_depth = if (n > min_depth + 2) n else min_depth + 2;
    const stretch = max_depth + 1;

    var buf: [1024]u8 = undefined;
    var stdout: std.Io.File.Writer = .init(.stdout(), init.io, &buf);
    const out = &stdout.interface;

    const t = try bottomUp(gpa, stretch);
    try out.print("stretch tree of depth {d}\t check: {d}\n", .{ stretch, check(t) });
    deleteTree(gpa, t);

    const long_lived = try bottomUp(gpa, max_depth);
    var depth = min_depth;
    while (depth <= max_depth) : (depth += 2) {
        const iterations = @as(i32, 1) << @intCast(max_depth - depth + min_depth);
        var sum: i32 = 0;
        for (0..@intCast(iterations)) |_| {
            const tree = try bottomUp(gpa, depth);
            sum += check(tree);
            deleteTree(gpa, tree);
        }
        try out.print("{d}\t trees of depth {d}\t check: {d}\n", .{ iterations, depth, sum });
    }
    try out.print("long lived tree of depth {d}\t check: {d}\n", .{ max_depth, check(long_lived) });
    deleteTree(gpa, long_lived);
    try out.flush();
}
