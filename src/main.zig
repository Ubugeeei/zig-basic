const std = @import("std");
const assert = std.testing.expectEqual;
pub fn main() anyerror!void {}

test "basic test" {
    {
        try assert(10, 3 + 7);
    }
}
