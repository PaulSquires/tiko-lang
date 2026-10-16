# raylib examples

raylib's own examples, in tiko: each is one `.tiko` program that imports `vendor/raylib`, which
comes with the toolchain, and is built on its own with `tiko <name>.tiko`. They follow raylib's
`examples/` folder by category.

| Folder | Examples |
| --- | --- |
| `core` | basic window, keyboard and mouse input, random values, 2D camera, 2D camera with mouse zoom, 3D camera, 3D picking |
| `shapes` | basic shapes, bouncing ball, colours palette, following eyes, animated raylib logo |
| `models` | geometric shapes, waving cubes, a solar system drawn with rlgl |
| `textures` | procedural image generation |
| `text` | a text-writing animation |

A number on an example's command line closes it after that many frames -- `core_basic_window
120` -- which is how they are tested; without one it runs until the window is closed or ESC is
pressed.

## Dynamic or static

Every example imports raylib with

```
#import "vendor/raylib" link dynamic
```

which links raylib's shared library and copies it beside the program: `raylib.dll` on Windows,
`libraylib.so.620` on Linux. Change `dynamic` to `static` and raylib is built into the program,
with nothing to copy; on Linux a static program links the system's OpenGL and X11 libraries.
The mode is chosen on `vendor/raylib` even where an example also imports `vendor/raylib/raymath`
or `vendor/raylib/rlgl`, which link nothing of their own.

Each example runs both ways, on Windows and on Linux.

The examples are raylib's, under its zlib/libpng licence; each keeps its original notice.
