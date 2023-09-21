const std = @import("std");
const allocator = std.heap.page_allocator;
const timer = std.time;

fn read_from_file(file_name: []const u8) ![]u8 {
    var file = try std.fs.cwd().openFile(file_name, .{});

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var size: u32 = 0;
    var byte: ?u8 = in_stream.readByte() catch null;

    while (byte != null) {
        size += 1;
        byte = in_stream.readByte() catch null;
    }
    file.close();

    file = try std.fs.cwd().openFile(file_name, .{});

    buf_reader = std.io.bufferedReader(file.reader());
    in_stream = buf_reader.reader();

    var buffer: []u8 = try allocator.alloc(u8, size);
    _ = try in_stream.readAll(buffer);

    file.close();
    return buffer;
}

fn write_to_file(file_name: []const u8, stream: []const u8) !void {
    var file = try std.fs.cwd().createFile(file_name, .{});
    try file.writeAll(stream);
    file.close();
}

fn interleave(source: []const u8, size: usize, target_start: []u8, cols: u32) void {
    var target_p: [*]u8 = @ptrCast(target_start);
    var target_idx: usize = 0;

    const source_size: u32 = @intCast(size);
    const lines: u32 = source_size / cols + 1;

    var idx: u32 = 0;
    for (0..cols) |col_idx| {
        for (0..lines) |line_idx| {
            idx = @intCast(line_idx * cols + col_idx);
            if (idx >= source_size) break;
            // target_p[0] = source[idx];
            // target_p += 1;

            target_p[target_idx] = source[idx];
            target_idx += 1;
        }
    }
    // target_p[0] = 0;

    // target_p[target_idx] = 0;
}

fn deinterleave(source: []const u8, size: usize, target_start: []const u8, col_num: u32) void {
    var target_p: [*]u8 = @constCast(@ptrCast(target_start));
    var target_idx: usize = 0;

    const source_size: u32 = @intCast(size);
    const lines: u32 = col_num;
    var cols = source_size / lines;
    if (source_size % lines != 0) cols += 1;

    const remainder: u32 = (source_size % cols);
    const empty_spaces: u32 = cols - remainder;
    const moved_chrs: u32 = (empty_spaces - 1) * (cols - 1);

    var idx: u32 = 0;

    for (0..cols) |col_idx| {
        for (0..lines) |line_idx| {
            idx = @intCast(line_idx * cols + col_idx);
            if (remainder != 0) {
                if (idx + moved_chrs == source_size) break;
                if (idx + moved_chrs > source_size)
                    idx -= @intCast(empty_spaces - (lines - line_idx));
            }

            if (idx >= source_size) break;

            // target_p.* = source[idx];
            // target_p += 1;

            target_p[target_idx] = source[idx];
            target_idx += 1;
        }
    }
    // target_p.* = 0;

    target_p[target_idx] = 0;
}

const ITERATIONS: i32 = 10000;
const FILE_NAME: []const u8 = @ptrCast("..\\TheRaven.txt");

fn time_it(test_it: bool) !i64 {
    var source: []const u8 = try read_from_file(FILE_NAME);
    const size: usize = source.len;

    var str_inter: []u8 = try allocator.alloc(u8, size);
    var str_deinter: []u8 = try allocator.alloc(u8, size);

    const start = timer.nanoTimestamp();

    for (0..ITERATIONS) |_| {
        interleave(source, size, str_inter, 4);
        deinterleave(str_inter, size, str_deinter, 4);
    }

    allocator.free(source);

    const end = timer.nanoTimestamp();

    //* Check if it's working: */
    if (test_it) {
        source = try read_from_file(FILE_NAME);
        interleave(source, size, str_inter, 4);
        deinterleave(str_inter, size, str_deinter, 4);

        try write_to_file("TheRaven_inter.txt", str_inter);
        try write_to_file("TheRaven_deinter.txt", str_deinter);
        allocator.free(source);
    }

    allocator.free(str_inter);
    allocator.free(str_deinter);

    return @intCast(end - start);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var discard: i64 = try time_it(false);
    discard += 1;
    const time_nanos: i64 = try time_it(true);

    try stdout.print("TOTAL: {any} milli seconds\nAVG: {any} micro seconds", .{ @divFloor(time_nanos, 1000 * 1000), @divFloor(time_nanos, 1000 * ITERATIONS) });
}
