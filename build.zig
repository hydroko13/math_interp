const std = @import("std");

pub fn build(b: *std.Build) void {

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug
    });

    const exe = b.addExecutable(.{
        .name = "math_interp",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .optimize = optimize,
            .target = target
        })
    });

    const tests = b.addTest(.{
        .root_module = b.createModule(
            .{
                .root_source_file = b.path("src/tests.zig"),
                .target = target
            }
        )
    });

    b.installArtifact(exe);
    b.installArtifact(tests);

    const run_exe = b.addRunArtifact(exe);
    const run_tests = b.addRunArtifact(tests);


    const run_step = b.step("run", "Run the application");
    const test_step = b.step("test", "Run the tests.");

    run_step.dependOn(&run_exe.step);
    test_step.dependOn(&run_tests.step);


}
