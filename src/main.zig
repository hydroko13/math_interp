const std = @import("std");
const core = @import("core.zig");
const lexer = @import("lexer.zig");


pub fn main() !void {
    const text = "3 + 2 / 8";

    var gpa = std.heap.DebugAllocator(.{}).init;

    defer {
        const memResult = gpa.deinit();
        switch (memResult) {
            .leak => {
                std.debug.print("Memory leak detected!\n", .{});
            },
            .ok => {}
        }
    }

    const allocator = gpa.allocator();

    var tokens = std.ArrayList(core.Token).empty;

    defer tokens.deinit(allocator);

    try lexer.tokenize(text, &tokens, allocator);

    std.debug.print("{}\n", .{tokens});
}
