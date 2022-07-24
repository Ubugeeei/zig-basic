const std = @import("std");
const assert = std.testing.expectEqual;
pub fn main() anyerror!void {}

test "basic test" {
    try assert(10, 3 + 7);
}

test "vars" {
    const a: i32 = 3;
    var b: i32 = 1;
    b = 7;
    try assert(a + b, 10);
}

test "assertion" {
    var x: i32 = 0;

    x = @as(i32, 1);
    try assert(x, 1);
}
