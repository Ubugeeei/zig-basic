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

test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += i;
    }
    try assert(sum, 1);
}

test "for" {
    //character literals are equivalent to integer literals
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string) |character, index| {
        _ = character;
        _ = index;
    }

    for (string) |character| {
        _ = character;
    }

    for (string) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}

fn addFive(x: u32) u32 {
    return x + 5;
}
test "function" {
    const y = addFive(0);
    try assert(@TypeOf(y), u32);
    try assert(y, 5);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}
test "exception" {
    failingFunction() catch |err| {
        try assert(err, error.Oops);
        return;
    };
}

test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            //special considerations must be made
            //when dividing signed integers
            x = @divExact(x, 10);
        },
        else => {},
    }
    try assert(x, 1);
}

test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    try assert(x, 1);
}

test "out of bounds" {
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    if (index > a.len) {
        return;
    }
    const b = a[index];
    _ = b;
}

test "out of bounds, no safety" {
    @setRuntimeSafety(false);
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index];
    _ = b;
}

fn increment(num: *u8) void {
    num.* += 1;
}
test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try assert(x, 2);
}

test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    try assert(slice[slice.len - 1], 3);
}

test "enum ordinal value" {
    const Value = enum(u2) { zero, one, two };
    try assert(@enumToInt(Value.zero), 0);
    try assert(@enumToInt(Value.one), 1);
    try assert(@enumToInt(Value.two), 2);
}

test "set enum ordinal value" {
    const Value2 = enum(u32) {
        hundred = 100,
        thousand = 1000,
        million = 1000000,
        next,
    };
    try assert(@enumToInt(Value2.hundred), 100);
    try assert(@enumToInt(Value2.thousand), 1000);
    try assert(@enumToInt(Value2.million), 1000000);
    try assert(@enumToInt(Value2.next), 1000001);
}

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};
test "enum method" {
    // const Suit = enum {
    //     clubs,
    //     spades,
    //     diamonds,
    //     hearts,
    //     pub fn isClubs(self: Suit) bool { // error!
    //         return self == Suit.clubs;
    //     }
    // };
    try assert(Suit.spades.isClubs(), Suit.isClubs(.spades));
}

test "struct usage" {
    const Vec3 = struct { x: f32, y: f32, z: f32 };
    const my_vector = Vec3{
        .x = 0,
        .y = 100,
        .z = 50,
    };
    _ = my_vector;
}

const Stuff = struct {
    x: i32,
    y: i32,
    fn swap(self: *Stuff) void {
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
};
test "automatic dereference" {
    var thing = Stuff{ .x = 10, .y = 20 };
    thing.swap();
    try assert(thing.x, 20);
    try assert(thing.y, 10);
}

test "union" {
    const Tag = enum { a, b, c };
    const Tagged = union(Tag) { a: u8, b: f32, c: bool };
    var value = Tagged{ .b = 1.5 };
    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*,
    }
    try assert(value.b, 3);
}

test "optional" {
    var found_index: ?usize = null;
    const data = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 12 };
    for (data) |v, i| {
        if (v == 10) found_index = i;
    }
    try assert(found_index, null);
}