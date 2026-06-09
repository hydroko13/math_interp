const std = @import("std");
const core = @import("core.zig");
const lexer = @import("lexer.zig");

pub fn main() !void {
    const text = "3 + 2 / 8";

    var gpa = std.heap.DebugAllocator(.{}){};

    const allocator = gpa.allocator();

    var tokens = std.ArrayList(core.Token).empty;

    defer tokens.deinit(allocator);

    try lexer.tokenize(text, &tokens, allocator);

    std.debug.print("{}\n", .{tokens});
}

test "Lexer Test 1" {

    const expected = [_]core.Token{
        core.Token{ .number = 3 },
        core.Token{ .plus = {} },
        core.Token{ .number = 2 },
        core.Token{ .divide = {} },
        core.Token{ .number = 8 },
    };

    try std.testing.expect(try lexer.lexerOutputMatches(std.testing.allocator, "3 + 2 / 8", expected[0..]));
}


test "Lexer Test 2" {

    const expected = [_]core.Token{
        core.Token{ .number = 1 },
        core.Token{ .plus = {} },
        core.Token{ .number = 1 },
        core.Token{ .plus = {} },
        core.Token{ .number = 2 },
        core.Token{ .plus = {} },
        core.Token{ .number = 3 },
    };

    try std.testing.expect(try lexer.lexerOutputMatches(std.testing.allocator, "1 + 1 + 2 + 3", expected[0..]));
}

test "Lexer Test 3" {

    const expected = [_]core.Token{
        core.Token{ .number = 0 }
    };

    try std.testing.expect(try lexer.lexerOutputMatches(std.testing.allocator, "0000.000", expected[0..]));
}

test "Lexer Test 4" {

    const expected = [_]core.Token{
        core.Token{ .number = 0 }
    };

    try std.testing.expect(try lexer.lexerOutputMatches(std.testing.allocator, "0", expected[0..]));
}

test "Lexer Test 5" {

    const expected = [_]core.Token{
        
    };

    try std.testing.expect(try lexer.lexerOutputMatches(std.testing.allocator, "", expected[0..]));
}


test "Lexer Test 6" {

    const expected = [_]core.Token{
        core.Token{.number = 0.01}
    };

    try std.testing.expect(try lexer.lexerOutputMatches(std.testing.allocator, "0.0100", expected[0..]));
}

test "Lexer Test 7" {

    const expected = [_]core.Token{
        core.Token{.number = 0.2}
    };

    try std.testing.expect(try lexer.lexerOutputMatches(std.testing.allocator, "0.2", expected[0..]));
}