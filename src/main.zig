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

test "array" {
    const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
    const b = [_]u8{ 'w', 'o', 'r', 'l', 'd' };

    try assert(a.len, 5);
    try assert(a[1], 'e');

    try assert(b.len, 5);
    try assert(b[4], 'd');
}

test "if statement" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    try assert(x, 1);
}

test "if statement expression" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;

    try assert(x, 1);
}

test "while" {
    var i: u8 = 2;
    while (i < 100) {
        i *= 2;
    }
    try assert(i, 128);
}

test "while with continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        sum += i;
    }
    try assert(sum, 55);
}

test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }
    try assert(sum, 4);
}
