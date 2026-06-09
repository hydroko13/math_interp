const std = @import("std");
const core = @import("core.zig");

const LexerMode = enum {
    Normal,
    Number,
};

pub fn tokenize(text: []const u8, tokens: *std.ArrayList(core.Token), allocator: std.mem.Allocator) !void {
    var lexer_mode = LexerMode.Normal;
    var numString = std.ArrayList(u8).empty;
    var dot_count: u32 = 0;
    const last_idx = text.len;
    defer numString.deinit(allocator);


    for (0..text.len+1) |index| {
        
        const reached_eof: bool = if (index == last_idx) true else false;
        const character: u8 = if(index == last_idx) 0 else text[index];
        
        switch (lexer_mode) {
            .Normal => {
                if (reached_eof) {
                    break;
                }
                switch (character) {
                    ' ', '\t' => {},
                    '+' => {
                        try tokens.append(allocator, .plus);
                    },
                    '-' => {
                        try tokens.append(allocator, .minus);
                    },
                    '*' => {
                        try tokens.append(allocator, .multiply);
                    },
                    '/' => {
                        try tokens.append(allocator, .divide);
                    },
                    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => {
                        lexer_mode = .Number;
                        numString.clearRetainingCapacity();
                        try numString.append(allocator, character);
                        dot_count = 0;
                    },
                    else => {

                    }
                }
            },
            .Number => {
                if (reached_eof) {
                    lexer_mode = .Normal;
                    const numStringSlice = numString.items;
                    const num = try std.fmt.parseFloat(f32, numStringSlice);
                    try tokens.append(allocator, .{.number = num});
                    break;
                }
                switch (character) {
                    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.' => {
                        if (character == '.') {
                            if (dot_count == 0) {
                                try numString.append(allocator, character);
                                dot_count += 1;
                            } else {
                                lexer_mode = .Normal;
                                const numStringSlice = numString.items;
                                const num = try std.fmt.parseFloat(f32, numStringSlice);
                                try tokens.append(allocator, .{.number = num});
                            }
                            
                        } else {
                            try numString.append(allocator, character);
                        }
                        
                    },
                        
                    else => {
                        lexer_mode = .Normal;
                        const numStringSlice = numString.items;
                        const num = try std.fmt.parseFloat(f32, numStringSlice);
                        try tokens.append(allocator, .{.number = num});
                    }
                }
            },
        }
    }
}



pub fn lexerOutputMatches(allocator: std.mem.Allocator, text: []const u8, expectedTokens: []const core.Token) !bool {

    var tokens = std.ArrayList(core.Token).empty;

    defer tokens.deinit(allocator);
    

    try tokenize(text, &tokens, allocator);

    if (expectedTokens.len != tokens.items.len) {
        return false;
    }

    for (0..tokens.items.len) |idx| {
        
        if (!std.meta.eql(tokens.items[idx], expectedTokens[idx])) {
            
            return false;
        }
    }


    return true;
}