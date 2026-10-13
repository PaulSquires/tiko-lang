[Home](Home) › [Tutorials](Category-Tutorials) › [Using C Libraries](Using-C-Libraries-Tutorial) › **SDL3**

# SDL3 Tutorial

> 📘 **Start with:** [Using C Libraries](Using-C-Libraries-Tutorial), the ideas these steps rely on.
>
> 📖 **In the book:** [Chapter 29, SDL3](https://tiko-lang.net/book/ch29-c-libraries.html#sdl3). Measured with SDL 3.4.18 and tiko at `90d2c6e7` (2026-10-13), on Windows and Linux.

[SDL](https://libsdl.org), the *Simple DirectMedia Layer*, is the broadest of the common game libraries. It covers windows, a 2D renderer, a GPU interface, audio, gamepads, cameras, file dialogs, threads and timers, on desktop and mobile alike. SDL3 is its current version.

SDL3 needs three things the other tutorials did not: an include directory for `#cinclude`, a C macro defined before its headers are read, and its "main callbacks". Each is explained where it comes up.

---

## 1. Download

From [github.com/libsdl-org/SDL/releases](https://github.com/libsdl-org/SDL/releases), release **3.4.18**:

| File | Contains | You need it for |
|---|---|---|
| `SDL3-devel-3.4.18-VC.zip` | `include/SDL3/*.h`; `lib/x64/SDL3.lib` (import library) and `lib/x64/SDL3.dll` | building on Windows, linked dynamically |
| `SDL3-3.4.18.tar.gz` | the source | Linux, and a static library on Windows |
| `SDL3-3.4.18-win32-x64.zip` | `SDL3.dll` only | people who **run** your program, not for building it |

There is **no static library** in the Windows package and **no Linux package**. Both come from building the source.

## 2. Lay it out: Windows, dynamic

| Copy | To |
|---|---|
| `include/` (the whole folder, with `SDL3/` inside) | `vendor/sdl3/include/` |
| `lib/x64/SDL3.lib` | `vendor/sdl3/SDL3_windows_x86_64.lib` |
| `lib/x64/SDL3.dll` | `SDL3.dll`, **beside your program** |

## 3. Build it: Linux

SDL's `docs/README-linux.md` lists the packages its build can use. The build enables whatever it finds, so install the list for full audio and video support. Then:

```bash
tar -xzf SDL3-3.4.18.tar.gz
cmake -S SDL3-3.4.18 -B build -DCMAKE_BUILD_TYPE=Release -DSDL_STATIC=ON -DSDL_SHARED=ON
cmake --build build
```

| Copy | To |
|---|---|
| `SDL3-3.4.18/include/` | `vendor/sdl3/include/` |
| `build/libSDL3.a` | `vendor/sdl3/SDL3-static_linux_x86_64.a` |
| `build/libSDL3.so.0` | `vendor/sdl3/SDL3_linux_x86_64.so` |
| `build/libSDL3.so.0` | `libSDL3.so.0`, **beside your program** |

Copy the `.so` with `cp -L`, because `libSDL3.so.0` is a link.

## 4. The program

SDL's example `renderer/01-clear` opens a window whose colour cycles smoothly. It is written with SDL3's **main callbacks**. Instead of writing the main loop yourself, you give SDL four functions:

| Callback | Called |
|---|---|
| `AppInit` | once, at the start |
| `AppEvent` | for every event: a key, the mouse, closing the window |
| `AppIterate` | once per frame |
| `AppQuit` | once, at the end |

SDL recommends this style because it works unchanged on platforms where a program cannot own its main loop, such as phones and the web. Here is the example in tiko:

```freebasic
'' SDL's example renderer/01-clear: a window whose colour cycles, built
'' on SDL3's main callbacks. A number on the command line stops it
'' after that many frames instead of when the window is closed.
#cmdline "-cinclude vendor/sdl3/include -cdefine SDL_MAIN_HANDLED"
#cinclude once "SDL3/SDL.h"
#cinclude once "SDL3/SDL_main.h"
#foreignlib SDL3 dynamic "vendor/sdl3/SDL3"

'' Everything the callbacks share, reached through SDL's appstate.
type AppState
    window as SDL_Window ptr
    renderer as SDL_Renderer ptr
    frames as int32
    maxFrames as int32
end type

function AppInit cdecl( byval appstate as any ptr ptr, _
        byval argc as int32, byval argv as zstring ptr ptr ) _
        as SDL_AppResult
    SDL_SetAppMetadata( "Example Renderer Clear", "1.0", _
        "com.example.renderer-clear" )
    if SDL_Init( SDL_INIT_VIDEO ) = false then
        print "Couldn't initialize SDL: "; *SDL_GetError( )
        return SDL_APP_FAILURE
    end if
    var st = new AppState
    st->maxFrames = valint( command( 1 ) )   '' 0: until closed
    *appstate = st
    if SDL_CreateWindowAndRenderer( "examples/renderer/clear", _
            640, 480, SDL_WINDOW_RESIZABLE, _
            @st->window, @st->renderer ) = false then
        print "Couldn't create window/renderer: "; *SDL_GetError( )
        return SDL_APP_FAILURE
    end if
    SDL_SetRenderLogicalPresentation( st->renderer, 640, 480, _
        SDL_LOGICAL_PRESENTATION_LETTERBOX )
    return SDL_APP_CONTINUE
end function

function AppEvent cdecl( byval appstate as any ptr, _
        byval event as SDL_Event ptr ) as SDL_AppResult
    if event->type = SDL_EVENT_QUIT then return SDL_APP_SUCCESS
    return SDL_APP_CONTINUE
end function

function AppIterate cdecl( byval appstate as any ptr ) as SDL_AppResult
    var st = cast( AppState ptr, appstate )
    var now = SDL_GetTicks( ) / 1000.0
    var red = 0.5 + 0.5 * SDL_sin( now )
    var green = 0.5 + 0.5 * SDL_sin( now + SDL_PI_D * 2 / 3 )
    var blue = 0.5 + 0.5 * SDL_sin( now + SDL_PI_D * 4 / 3 )
    SDL_SetRenderDrawColorFloat( st->renderer, red, green, blue, _
        SDL_ALPHA_OPAQUE_FLOAT )
    SDL_RenderClear( st->renderer )
    SDL_RenderPresent( st->renderer )
    st->frames += 1
    if st->frames = st->maxFrames then return SDL_APP_SUCCESS
    return SDL_APP_CONTINUE
end function

sub AppQuit cdecl( byval appstate as any ptr, _
        byval result as SDL_AppResult )
    var st = cast( AppState ptr, appstate )
    if st <> nullptr then
        print "drew "; str( st->frames ); " frames"
        delete st
    end if
end sub

'' SDL calls AppInit once, then AppEvent and AppIterate until one of
'' them returns something other than SDL_APP_CONTINUE, then AppQuit.
var rc = SDL_EnterAppMainCallbacks( 0, nullptr, @AppInit, _
    @AppIterate, @AppEvent, @AppQuit )
end rc
```

```bash
tiko sdl-clear.tiko
./sdl-clear                         # Windows: SDL3.dll beside it
LD_LIBRARY_PATH=. ./sdl-clear       # Linux
```

Close the window and the program prints how many frames it drew. With a number, `./sdl-clear 60` stops by itself:

```
drew 60 frames
```

### The three lines that connect it to SDL

```freebasic
#cmdline "-cinclude vendor/sdl3/include -cdefine SDL_MAIN_HANDLED"
#cinclude once "SDL3/SDL.h"
#cinclude once "SDL3/SDL_main.h"
#foreignlib SDL3 dynamic "vendor/sdl3/SDL3"
```

1. **`-cinclude vendor/sdl3/include`.** SDL's headers include each other as `#include <SDL3/SDL_stdinc.h>`. For angle-bracket includes clang searches only the include directories, so SDL's `include` folder has to be one. A program then writes `#cinclude once "SDL3/SDL.h"`, as C writes `#include <SDL3/SDL.h>`. Inside `#cmdline` the path is relative to where you run `tiko`. In a project, put it in `tiko.toml`, where it is relative to `tiko.toml`:

   ```toml
   [target.game]
   main    = "main.tiko"
   options = ["-cinclude", "vendor/sdl3/include",
              "-cdefine", "SDL_MAIN_HANDLED"]
   ```

2. **`-cdefine SDL_MAIN_HANDLED`.** In C, `SDL_main.h` supplies the program's `main` function, which runs the callbacks. A tiko program has its own start, so this macro tells `SDL_main.h` to declare things only.
3. **`SDL_main.h`** declares `SDL_EnterAppMainCallbacks`, which the program's last statement calls with the addresses of the four callbacks. That is exactly what C's `main` would have done.

### How the callbacks share data, with no globals

SDL's C example keeps the window and renderer in global variables. SDL also offers something better: `AppInit` receives the address of a pointer, `appstate`, and whatever you store there is handed to every later callback. The tiko version allocates one `AppState` with `new` in `AppInit` and frees it in `AppQuit`.

### Details

- **The callbacks must match SDL's types exactly**: `cdecl`, with the same parameter types as the header's `SDL_AppInit_func`, `SDL_AppEvent_func` and the others. A mismatch is only warning `TKO0833: passing different pointer types`, and the program still builds, so treat that warning as an error.
- **SDL3 functions return C `bool`.** Compare them with `false`: `if SDL_Init( SDL_INIT_VIDEO ) = false then`.
- **`event->type`.** `SDL_Event` is a C union, and `->` reaches its fields as for any pointer to a struct.
- **`SDL_PI_D`, `SDL_ALPHA_OPAQUE_FLOAT`** are `#define`s with number values, so they come across as constants.

> 💡 **Running without a screen.** SDL reads the environment variable `SDL_VIDEO_DRIVER`. With `SDL_VIDEO_DRIVER=dummy`, it draws nowhere, so a program that opens windows still runs on a build server, for example: `SDL_VIDEO_DRIVER=dummy ./sdl-clear 60`.

## 5. Linking SDL statically

**Windows.** Build the static library from the source with the Visual Studio Build Tools, using SDL's own CMake build:

```bash
tar -xzf SDL3-3.4.18.tar.gz
cmake -S SDL3-3.4.18 -B build -DSDL_STATIC=ON -DSDL_SHARED=OFF
cmake --build build --config Release
```

Copy `build/Release/SDL3-static.lib` (13 MB) to `vendor/sdl3/SDL3-static_windows_x86_64.lib`, then change the link lines:

```freebasic
#cmdline "-cinclude vendor/sdl3/include -cdefine SDL_MAIN_HANDLED"
#cinclude once "SDL3/SDL.h"
#cinclude once "SDL3/SDL_main.h"
#ifdef __FB_WIN32__
    #foreignlib SDL3 static "vendor/sdl3/SDL3-static", _
        "system:cfgmgr32", "system:ole32", "system:oleaut32", _
        "system:setupapi", "system:shell32"
#else
    #foreignlib SDL3 static "vendor/sdl3/SDL3-static"
#endif
```

Linked statically, SDL needs five Windows libraries: `cfgmgr32`, `ole32`, `oleaut32`, `setupapi` and `shell32`. They were found by linking without any and reading the `undefined symbol` errors. `SetupDiGetClassDevsA` is in `setupapi`, `CoInitializeEx` in `ole32`, and so on, as Microsoft's documentation for each function says.

**Linux.** `vendor/sdl3/SDL3-static_linux_x86_64.a` from step 3 links with nothing more. SDL loads the window system and the sound system while the program runs. The program is 3.6 MB, with no `.so` to ship.

## 6. Installing SDL for every program

**Linux:** distributions newer than Ubuntu 24.04 package it as `libsdl3-dev`. Otherwise run `sudo cmake --install build` after step 3, then `sudo ldconfig`. Headers go to `/usr/local/include/SDL3` and the library to `/usr/local/lib`, both searched by default, so no `-cinclude` is needed:

```freebasic
#cmdline "-cdefine SDL_MAIN_HANDLED"
#cinclude once "SDL3/SDL.h"
#cinclude once "SDL3/SDL_main.h"
#foreignlib SDL3 dynamic "system:SDL3"
```

**Linux, without `LD_LIBRARY_PATH`:** add `-Wl -rpath,$ORIGIN` to the link (in `#cmdline` inside `#ifdef __FB_LINUX__`, or in `tiko.toml`'s `options`), and the program finds `libSDL3.so.0` beside itself.

**Windows:** keep `vendor/sdl3/` in a shared folder such as `C:\tiko-libs\sdl3`, and give every project `-cinclude C:/tiko-libs/sdl3/include` and `-cdefine SDL_MAIN_HANDLED` in its `tiko.toml`. Point `#foreignlib` at the shared folder with an absolute path, or in a [binding header](Using-C-Libraries-Tutorial#5-a-binding-header). Copy `SDL3.dll` beside each program or put its folder on `PATH`.

## 7. Troubleshooting

| Problem | Fix |
|---|---|
| `TKO0336: unable to import C header` with `'SDL3/SDL_stdinc.h' file not found` | add `-cinclude` for SDL's `include` folder |
| `'sdl_init' is not declared` after a `TKO0336` | the header failed to import; fix the first error |
| `undefined symbol: ... SetupDiGetClassDevsA` (and others) linking statically | add the five system libraries in step 5 |
| `undefined symbol: __declspec(dllimport) strnlen` | your tiko toolchain predates the fix to its C runtime import library; update tiko |
| `Couldn't initialize SDL: No available video device` on Linux | no display SDL can use: check `DISPLAY`/`WAYLAND_DISPLAY`, install the X11 or Wayland development packages before building SDL, or use `SDL_VIDEO_DRIVER=dummy` |
| `warning TKO0833` at `SDL_EnterAppMainCallbacks` | a callback's parameters differ from SDL's type; make them match |

---

**Back:** [GLFW](GLFW-Tutorial) · [raylib](Raylib-Tutorial) · [SQLite](SQLite-Tutorial) · [Using C Libraries](Using-C-Libraries-Tutorial)

[Home](Home) · [Tutorials](Category-Tutorials)
