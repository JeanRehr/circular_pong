package main

import "core:fmt"
import rl "vendor:raylib"

w_width: i32 = 1600
w_height: i32 = 900

Field :: struct {
    xy: rl.Vector2,
    line_start: rl.Vector2,
    line_end: rl.Vector2,
    radius: f32,
    color: rl.Color,
}

field_init_alloc :: proc(xy: rl.Vector2, radius: f32, color: rl.Color, horizontal_line: bool, allocator := context.allocator) -> ^Field {
    field: ^Field = new(Field, allocator)

    //field^ = Field{xy, line_start, line_end, radius, color}
    field.xy = xy
    field.radius = radius
    field.color = color

    if (horizontal_line) {
        field.line_start = {field.xy.x - field.radius, field.xy.y}
        field.line_end = {field.xy.x + field.radius, field.xy.y}
    } else {
        field.line_start = {field.xy.x, field.xy.y - field.radius}
        field.line_end = {field.xy.x, field.xy.y + field.radius}
    }

    return field
}

field_init :: proc(field: ^Field, xy: rl.Vector2, radius: f32, color: rl.Color, horizontal_line: bool) {
    //field^ = Field{xy, line_start, line_end, radius, color}
    field.xy = xy
    field.radius = radius
    field.color = color

    if (horizontal_line) {
        field.line_start = {field.xy.x - field.radius, field.xy.y}
        field.line_end = {field.xy.x + field.radius, field.xy.y}
    } else {
        field.line_start = {field.xy.x, field.xy.y - field.radius}
        field.line_end = {field.xy.x, field.xy.y + field.radius}
    }
}

field_draw :: proc(field: ^Field) {
    rl.DrawCircleLinesV(field.xy, field.radius, field.color)
    rl.DrawLineV(field.line_start, field.line_end, field.color)
}

main :: proc() {
    /*track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)

    defer {
        if len(track.allocation_map) > 0 {
            fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
            for _, entry in track.allocation_map {
                fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
            }
        }
        if len(track.bad_free_array) > 0 {
            fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
            for entry in track.bad_free_array {
                fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
            }
        }
        mem.tracking_allocator_destroy(&track)
    }*/

    // Initialization
    //----------------------------------------------------------------------------------

    rl.SetConfigFlags({.WINDOW_RESIZABLE})

    rl.InitWindow(w_width, w_height, "Circular Pong")
    defer {
        rl.CloseWindow()
    }

    rl.SetTargetFPS(60)

    field: Field

    field_init(&field, rl.Vector2{f32(w_width) / 2, f32(w_height) / 2}, 100, rl.BLACK, true)

    //----------------------------------------------------------------------------------
    for !rl.WindowShouldClose() {
        // Update
        //----------------------------------------------------------------------------------
        if rl.IsWindowResized() {
            w_width = rl.GetScreenWidth()
            w_height = rl.GetScreenHeight()
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.BeginDrawing();
        rl.ClearBackground(rl.RAYWHITE)
        field_draw(&field)

        rl.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    fmt.println("test")
}