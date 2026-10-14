[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **raylib**

# raylib Tutorial

> 📘 **Start with:** [Using C Libraries](Using-C-Libraries-Tutorial), the ideas these steps rely on.
>
> 📖 **In the book:** [Chapter 29, raylib](https://tiko-lang.net/book/ch29-c-libraries.html#raylib). Measured with raylib 6.0, on Windows and Linux.

[raylib](https://www.raylib.com) is a library for making games. It has one header and 600 functions with plain names, and nothing to set up before your first window. It covers 2D and 3D drawing, textures, fonts, keyboard, mouse, gamepads and sound. raylib publishes ready-built packages for both of tiko's platforms, so nothing has to be compiled.

---

## 1. Download

Go to [github.com/raysan5/raylib/releases](https://github.com/raysan5/raylib/releases), open release **6.0**, and download:

| File | For | Contains |
|---|---|---|
| `raylib-6.0_win64_msvc16.zip` | Windows | `include/raylib.h` (+ `raymath.h`, `rlgl.h`)<br>`lib/raylib.lib` (**static**, 5.3 MB)<br>`lib/raylibdll.lib` (**import library**)<br>`lib/raylib.dll` |
| `raylib-6.0_linux_amd64.tar.gz` | Linux | the same headers<br>`lib/libraylib.a` (**static**)<br>`lib/libraylib.so.6.0.0`, plus links `libraylib.so.600` and `libraylib.so` |

Ignore the `win32` (32-bit), `mingw-w64` (another toolchain), `arm64`, `macos` and `webassembly` packages.

## 2. Copy the files into your project

The project keeps raylib in `vendor/raylib/`. Rename the **link-time** files so that each carries its target. Both platforms can then share the folder, and one `#foreignlib` line finds the right file on each.

**From the Windows zip:**

| Copy | To |
|---|---|
| `include/raylib.h` | `vendor/raylib/raylib.h` |
| `lib/raylib.lib` | `vendor/raylib/raylib_windows_x86_64.lib` |
| `lib/raylibdll.lib` | `vendor/raylib/raylibdll_windows_x86_64.lib` |
| `lib/raylib.dll` | `raylib.dll`, **beside your program** (do not rename) |

**From the Linux tarball:**

| Copy | To |
|---|---|
| `include/raylib.h` | `vendor/raylib/raylib.h` (the same file) |
| `lib/libraylib.a` | `vendor/raylib/raylib_linux_x86_64.a` |
| `lib/libraylib.so.6.0.0` | `vendor/raylib/raylibdll_linux_x86_64.so` |
| `lib/libraylib.so.6.0.0` | `libraylib.so.600`, **beside your program** (the soname; do not change it) |

On Linux use `cp -L` (or copy the real file `libraylib.so.6.0.0`), so that you copy the library and not a link to it.

## 3. Your first window (static link)

This is raylib's first example, `core_basic_window`:

```freebasic
'' raylib's first example, core_basic_window: open a window and draw a
'' line of text until it is closed. A number on the command line stops
'' it after that many frames instead.
#cinclude once "vendor/raylib/raylib.h"
#ifdef __FB_WIN32__
    #foreignlib RAYLIB static "vendor/raylib/raylib", _
        "system:winmm", "system:gdi32", "system:user32", _
        "system:shell32"
#else
    #foreignlib RAYLIB static "vendor/raylib/raylib", _
        "system:GL", "system:m", "system:pthread", "system:dl", _
        "system:rt", "system:X11"
#endif

const ScreenWidth = 800
const ScreenHeight = 450
dim maxFrames as int32 = valint( command( 1 ) )  '' 0: until closed

SetTraceLogLevel( LOG_WARNING )   '' raylib logs to stdout otherwise
InitWindow( ScreenWidth, ScreenHeight, _
    "raylib [core] example - basic window" )
SetTargetFPS( 60 )

dim frames as int32 = 0
do until WindowShouldClose( )
    BeginDrawing( )
    ClearBackground( RAYWHITE )
    DrawText( "Congrats! You created your first window!", _
        190, 200, 20, LIGHTGRAY )
    EndDrawing( )
    frames += 1
    if frames = maxFrames then exit do
loop
CloseWindow( )
print "drew "; str( frames ); " frames"
```

```bash
tiko raylib-window.tiko
./raylib-window
```

An 800×450 window opens with *"Congrats! You created your first window!"* in grey. Close it, and the program prints how many frames it drew. Give it a number, as in `./raylib-window 60`, and it stops by itself after that many frames.

**What is new compared with the C example:**

- **The `#foreignlib` line differs by platform**, because a static raylib needs the operating system's libraries too, and they differ:
  - Windows: `winmm` (timers), `gdi32`, `user32`, `shell32`
  - Linux: OpenGL (`GL`), `m`, `pthread`, `dl`, `rt` and `X11`, the list raylib's documentation gives

  `#ifdef __FB_WIN32__` chooses between them.
- **`SetTraceLogLevel( LOG_WARNING )`**: raylib reports everything it does on standard output, about forty lines when a window opens. Leave it out to see them.
- **`RAYWHITE` and `LIGHTGRAY`** are C macros that build a `Color` struct. `#cinclude` turns them into tiko definitions that build the same `Color`, and `DrawText` takes the `Color` **by value**, as in C.

## 4. The same window, linked dynamically

Replace the directives at the top with:

```freebasic
#cinclude once "vendor/raylib/raylib.h"
#foreignlib RAYLIB dynamic "vendor/raylib/raylibdll"
```

The DLL brings its own system libraries, so none are listed. The program shrinks from 608 KB to 27 KB, and needs `raylib.dll` (Windows) or `libraylib.so.600` (Linux) at run time:

```bash
tiko raylib-dll.tiko
./raylib-dll                          # Windows: raylib.dll beside it
LD_LIBRARY_PATH=. ./raylib-dll        # Linux
```

If the library cannot be found, Windows exits with `-1073741515` and prints nothing, while Linux says `error while loading shared libraries: libraylib.so.600` and exits with 127.

## 5. A binding header

Repeating the `#cinclude` line and the platform-specific `#foreignlib` lines in every program gets old. Put them in a file of their own, `vendor/raylib.ti`:

```freebasic
'' raylib.ti -- raylib 6.0 for tiko: its header, and the library to
'' link, in one file a program includes. Both paths are relative to
'' this file, so the folder it sits in can live anywhere: inside one
'' project, or in a single place that every program shares.
#pragma once

#cinclude once "raylib/raylib.h"

#ifdef __FB_WIN32__
    #foreignlib RAYLIB static "raylib/raylib", _
        "system:winmm", "system:gdi32", "system:user32", _
        "system:shell32"
#else
    #foreignlib RAYLIB static "raylib/raylib", _
        "system:GL", "system:m", "system:pthread", "system:dl", _
        "system:rt", "system:X11"
#endif
```

Its paths are relative to **itself**: `#foreignlib` always resolves that way, and `#cinclude` looks beside the file that names the header. So the folder works wherever it lives.

## 6. A project that uses it

`game/tiko.toml` says where the bindings are, relative to `tiko.toml`:

```toml
# A program that uses raylib without saying where raylib is: the
# -i below names the folder of bindings, relative to this file.
[package]
name = "game"

[target.game]
main    = "main.tiko"
options = ["-i", "../vendor"]
```

`game/main.tiko` is raylib's example `core_input_keys`. Move the ball with the arrow keys:

```freebasic
'' raylib's example core_input_keys: move a ball with the arrow keys.
'' A number on the command line stops it after that many frames.
#include once "raylib.ti"

const ScreenWidth = 800
const ScreenHeight = 450
dim maxFrames as int32 = valint( command( 1 ) )  '' 0: until closed

SetTraceLogLevel( LOG_WARNING )
InitWindow( ScreenWidth, ScreenHeight, _
    "raylib [core] example - keyboard input" )
dim ball as Vector2 = type( ScreenWidth / 2, ScreenHeight / 2 )
SetTargetFPS( 60 )

dim frames as int32 = 0
do until WindowShouldClose( )
    if IsKeyDown( KEY_RIGHT ) then ball.x += 2
    if IsKeyDown( KEY_LEFT ) then ball.x -= 2
    if IsKeyDown( KEY_UP ) then ball.y -= 2
    if IsKeyDown( KEY_DOWN ) then ball.y += 2

    BeginDrawing( )
    ClearBackground( RAYWHITE )
    DrawText( "move the ball with arrow keys", 10, 10, 20, DARKGRAY )
    DrawCircleV( ball, 50, MAROON )
    EndDrawing( )
    frames += 1
    if frames = maxFrames then exit do
loop
CloseWindow( )
print "ball at "; str( ball.x ); ", "; str( ball.y ); _
    " after "; str( frames ); " frames"
```

```bash
cd game
tiko build game
./out/debug/game
```

`ball` is a `Vector2`, a C struct of two floats. `type( ... )` fills it, and it is passed to `DrawCircleV` by value. `KEY_RIGHT` and the other key names come from a C `enum` in `raylib.h`.

## 7. One copy for every program

**Windows** has no standard place for C libraries, so make one, such as `C:\tiko-libs`:

```
C:\tiko-libs\raylib.ti
C:\tiko-libs\raylib\raylib.h
C:\tiko-libs\raylib\raylib_windows_x86_64.lib
C:\tiko-libs\raylib\raylibdll_windows_x86_64.lib
```

Every project then writes `#include once "raylib.ti"` and adds `options = ["-i", "C:/tiko-libs"]` to its `tiko.toml`, or passes `-i C:\tiko-libs` on the command line. When linking dynamically, also copy `raylib.dll` beside each program, or add the folder holding it to `PATH`.

**Linux**: recent distributions package raylib as `libraylib-dev` (Ubuntu 24.04 does not). Otherwise install the prebuilt tarball under `/usr/local`:

```bash
sudo cp include/*.h /usr/local/include/
sudo cp -P lib/libraylib.* /usr/local/lib/
sudo ldconfig
```

Programs then need no paths:

```freebasic
#cinclude once "raylib.h"
#foreignlib RAYLIB dynamic "system:raylib"
```

## 8. A binding module

Instead of a header, raylib can be a **module** that programs `#import`. The module says `public #cinclude`, which makes raylib's names the names of every program that imports it:

```freebasic
'' raylib as a module. 'public #cinclude' makes raylib.h's names the
'' names of every program that imports the module, and the module's
'' own #foreignlib links the library into each of them. Both paths are
'' relative to this file.
#module "raylib"

public #cinclude once "../../vendor/raylib/raylib.h"

#ifdef __FB_WIN32__
    #foreignlib RAYLIB static "../../vendor/raylib/raylib", _
        "system:winmm", "system:gdi32", "system:user32", _
        "system:shell32"
#else
    #foreignlib RAYLIB static "../../vendor/raylib/raylib", _
        "system:GL", "system:m", "system:pthread", "system:dl", _
        "system:rt", "system:X11"
#endif
```

```toml
# A program that imports raylib as a module: the -i below names the
# folder that holds module folders, relative to this file.
[package]
name = "modgame"

[target.modgame]
main    = "main.tiko"
options = ["-i", "../modules"]
```

```freebasic
'' raylib's core_basic_window once more, through the raylib module:
'' one #import, and every raylib name is the program's own.
'' A number on the command line stops it after that many frames.
#import "raylib"

dim maxFrames as int32 = valint( command( 1 ) )  '' 0: until closed

SetTraceLogLevel( LOG_WARNING )
InitWindow( 800, 450, "raylib [core] example - basic window" )
SetTargetFPS( 60 )

dim frames as int32 = 0
do until WindowShouldClose( )
    BeginDrawing( )
    ClearBackground( RAYWHITE )
    DrawText( "Congrats! You created your first window!", _
        190, 200, 20, LIGHTGRAY )
    EndDrawing( )
    frames += 1
    if frames = maxFrames then exit do
loop
CloseWindow( )
print "drew "; str( frames ); " frames"
```

```bash
cd modgame
tiko build modgame
./out/debug/modgame 60
```

```
drew 60 frames
```

The names are bare (`InitWindow`, not `raylib.InitWindow`), as `#cinclude` makes them, because a C header's `#define`s and struct macros cannot live in a namespace. To install the module for every program, put its folder in a directory named by `TKO_PATH` (`set TKO_PATH=C:\tiko-modules` on Windows, `export TKO_PATH=~/tiko-modules` on Linux) and give the module's paths to its own library files.

## 9. Linux: finding `libraylib.so.600` without `LD_LIBRARY_PATH`

Record the program's own directory as an **rpath**:

```freebasic
#cmdline "-x raylib-rpath -Wl -rpath,$ORIGIN"
#cinclude once "vendor/raylib/raylib.h"
#foreignlib RAYLIB dynamic "vendor/raylib/raylibdll"
```

The program then finds `libraylib.so.600` beside it wherever it is copied. In a shell, quote the option: `tiko raylib-dll.tiko -Wl '-rpath,$ORIGIN'`.

## 10. Troubleshooting

| Problem | Fix |
|---|---|
| `undefined symbol: __declspec(dllimport) DragQueryFileW` linking statically on Windows | a system library is missing (that one is `shell32`); the full list is `winmm`, `gdi32`, `user32`, `shell32` |
| `undefined reference to 'XOpenDisplay'` linking statically on Linux | add `"system:X11"` (and the rest of the list in step 3) |
| a long list of `INFO:` lines | `SetTraceLogLevel( LOG_WARNING )` before `InitWindow` |
| `TKO0329` with `raylib.a` among the names tried | rename the Linux archive to `raylib_linux_x86_64.a`; untagged, Windows would try it before `raylib.lib` |

---

**Next:** [GLFW](GLFW-Tutorial) · [SDL3](SDL3-Tutorial) · **Back:** [SQLite](SQLite-Tutorial)

[Home](Home)
