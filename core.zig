const std = @import("std");


pub const Token = union(enum) {
    plus,
    minus,
    divide,
    multiply,
    number: f32    
};