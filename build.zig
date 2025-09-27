const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_test_exe = b.option(bool, "build-test", "Build the Test executable") orelse false;

    if (build_test_exe) {
        buildTestExe(b, target, optimize);
    }

    const copy_headers = b.addInstallDirectory(.{
        .source_dir = b.path("include"),
        .install_dir = .header,
        .install_subdir = ".",
    });
    b.getInstallStep().dependOn(&copy_headers.step);
}

fn buildTestExe(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) void {
    const test_exe = b.addExecutable(.{
        .name = "testing",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        }),
    });
    b.installArtifact(test_exe);

    test_exe.addIncludePath(b.path("include"));
    test_exe.root_module.addCSourceFile(.{
        .file = b.path("test/test.cpp"),
        .flags = &[_][]const u8{
            "-std=c++17",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-Wno-unused-parameter",
            "-Wno-unused-variable",
            "-Wno-deprecated-declarations",
            "-fno-omit-frame-pointer",
            "-funwind-tables",
            "-D_GNU_SOURCE",
            "-D__STDC_CONSTANT_MACROS",
            "-D__STDC_FORMAT_MACROS",
            "-D__STDC_LIMIT_MACROS",
        },
    });

    const run_step = b.step("run", "Run the Test app");
    const run_cmd = b.addRunArtifact(test_exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
