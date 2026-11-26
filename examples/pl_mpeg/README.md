# pl_mpeg examples

pl_mpeg's C interface from tiko, through `vendor/pl_mpeg`, which comes with the toolchain. Each
example is one `.tiko` program, built on its own with `tiko <name>.tiko`.

| Folder | Shows |
| --- | --- |
| `01-info` | what a file holds; every frame and audio block decoded; a seek. On the bundled clip it checks what it finds and exits 1 if anything is off -- `info [FILE.mpg]` |
| `02-frame` | one frame as a picture: seek, `plm_frame_to_bgr`, a `.bmp` written by hand -- `frame [FILE.mpg] [SECONDS] [OUT.bmp]` |
| `03-player` | a player: frames into an SDL3 YUV texture, sound through `vendor/miniaudio` via a ring buffer -- `player [FILE.mpg] [VOLUME] [SNAPSHOT.bmp]` |

`media/clip.mpg` is two seconds of a test pattern with a 440 Hz tone, made by
`media/make-media.sh` (ffmpeg), so it is free to use like the examples.

## Things to know

- **One format: MPEG-1 video, MP2 audio, in an MPEG program stream.** Convert anything else
  first:

  ```
  ffmpeg -i in.mp4 -c:v mpeg1video -q:v 4 -c:a mp2 -format mpeg out.mpg
  ```

  (`-q:v` is quality: 2 is near-lossless and large, 8 small and soft.)
- **What pl_mpeg returns is valid until the next decode call.** A `plm_frame_t ptr` or
  `plm_samples_t ptr` points into the decoder; copy what you keep.
- **Frames are YCbCr 4:2:0 planes** -- `frame->y`, `frame->cb`, `frame->cr`, each with its own
  width, height and data. SDL3 takes them as they are (`SDL_PIXELFORMAT_IYUV`, Y then Cb then
  Cr); for RGB, `plm_frame_to_rgb` and its kin convert into a buffer of yours, rows `stride`
  bytes apart.
- **Decode one stream at a time with the `plm_decode_video` / `plm_decode_audio` pair**, the
  other disabled (`plm_set_audio_enabled( plm, 0 )`). To play both in step, use `plm_decode`
  with the elapsed time and the two callbacks, as `03-player` does.
- **Callbacks run on your own thread**, inside `plm_decode`: pl_mpeg has no threads. miniaudio's
  callback does not -- `03-player` hands audio between them through `ma_pcm_rb`, safe for one
  writer and one reader.
- **With `link dynamic` on Windows, never give pl_mpeg a `FILE ptr`**: `pl_mpeg.dll` has its
  own C runtime, and `plm_create_with_file` with the program's `FILE` ends the process. Open
  files by name (`plm_create_with_filename`), as these examples do. `link static` has no such
  limit.

## Dynamic or static

Every example imports pl_mpeg with

```
#import "vendor/pl_mpeg" link dynamic
```

which links the shared library and copies it beside the program -- `pl_mpeg.dll` on Windows,
`pl_mpeg_linux_x86_64.so` on Linux, where the program finds it beside itself. Change `dynamic` to
`static` and pl_mpeg is built into the program instead. `03-player` also imports
`vendor/miniaudio` and `vendor/SDL3`, each with its own `link`.

These examples are MIT-licensed, as pl_mpeg is.
