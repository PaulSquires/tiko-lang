[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **pl_mpeg**

# pl_mpeg Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link static` and `link dynamic` work.
>
> 📖 **In the book:** [Chapter 28, Sound and video](https://tiko-lang.net/book/ch28-logging-tui-sqlite.html#sound-and-video). Measured with pl_mpeg (c871f2b) and tiko on Windows, Linux and macOS.

[pl_mpeg](https://github.com/phoboslab/pl_mpeg) is a video decoder in one C file: MPEG-1 video, MP2 audio, and the MPEG program stream (`.mpg`) that carries them. It decodes fast, needs nothing else, and hands over plain YCbCr planes and float samples -- the right size of tool for a game's cutscene, an intro, or a video in a kiosk, where the file is yours to prepare.

tiko ships it as a [vendor package](Vendor-Packages). One line gives a program pl_mpeg's whole C API and links the library:

```freebasic
#import "vendor/pl_mpeg"
```

There is nothing to download, no header to translate, no `#foreignlib` and nothing on the command line. The names are the ones pl_mpeg's header documents -- `plm_create_with_filename`, `plm_decode_video`, `plm_seek_frame`. More programs are in the toolchain's `examples/pl_mpeg`, with the clip these use in `examples/pl_mpeg/media`.

> ⚠️ **One format.** pl_mpeg plays MPEG-1 video with MP2 audio, nothing else: not MP4, not H.264, not WebM. Section 2 converts anything else.

---

## 1. What is in a file

The program opens a clip, says what it holds, and decodes every frame and every sample of it:

```freebasic
'' What an MPEG-1 file holds, and every frame and sample of it decoded -- pl_mpeg, one of the
'' vendor packages.
#import "vendor/pl_mpeg"

dim path as string = command( 1 )
if len( path ) = 0 then path = "clip.mpg"

'' Open by name: pl_mpeg opens and reads the file itself.
dim plm as plm_t ptr = plm_create_with_filename( path )
if plm = nullptr then print "cannot open "; path : end 1
if plm_probe( plm, 1024 * 1024 ) = 0 then print path; " is not MPEG-1 video / MP2 audio" : end 1

print path & ": " & plm_get_width( plm ) & "x" & plm_get_height( plm ) & ", " & _
      plm_get_framerate( plm ) & " fps, audio " & plm_get_samplerate( plm ) & " Hz, " & _
      plm_get_duration( plm ) & " s"

'' Video: one frame per call, until there are none. Audio is switched off meanwhile, so the
'' demuxer does not keep its packets for a decoder nobody is calling.
plm_set_audio_enabled( plm, 0 )
dim frames as integer
dim frame as plm_frame_t ptr = plm_decode_video( plm )
while frame
    '' frame->y, ->cb, ->cr: YCbCr planes -- pl_mpeg's until the next call.
    if frames = 0 then print "first frame: " & frame->width & "x" & frame->height & " at " & frame->time & " s"
    frames += 1
    frame = plm_decode_video( plm )
wend
print frames & " frames"

'' Audio, from the start: blocks of 1152 stereo float32 sample frames.
plm_rewind( plm )
plm_set_audio_enabled( plm, 1 )
plm_set_video_enabled( plm, 0 )
dim sampleFrames as ulongint
dim samples as plm_samples_t ptr = plm_decode_audio( plm )
while samples
    sampleFrames += samples->count
    samples = plm_decode_audio( plm )
wend
print sampleFrames & " audio sample frames"
plm_destroy( plm )
```

```
clip.mpg: 320x240, 25 fps, audio 44100 Hz, 1.96 s
first frame: 320x240 at 0 s
50 frames
88704 audio sample frames
```

`plm_probe` reads far enough to find the streams; on a file that is not MPEG-1 it returns 0 and the program says so. A frame is pl_mpeg's until the next decode call -- copy what you keep. Decoding one stream at a time with `plm_decode_video` or `plm_decode_audio`, switch the other off, as here.

## 2. Converting a video

pl_mpeg's format is old, and everything converts to it. With [ffmpeg](https://ffmpeg.org):

```
ffmpeg -i in.mp4 -c:v mpeg1video -q:v 4 -c:a mp2 -b:a 192k -format mpeg out.mpg
```

`-q:v` is the quality, 2 (near-lossless, large) to 8 (small, soft). MPEG-1 needs a frame rate it knows -- 23.976, 24, 25, 29.97, 30, 50, 59.94 or 60 -- so add `-r 30` for a source at any other. A file made this way has constant timing, which matters: while it plays, pl_mpeg times each frame by counting frames at the frame rate, and uses the stream's own timestamps only to seek, so a file with gaps drifts.

## 3. A frame as a picture

`plm_seek_frame` finds the frame at a time -- with its last argument 1, exactly that frame, decoding forward from the key frame before it -- and `plm_frame_to_bgr` (or `_rgb`, `_rgba`, `_bgra`...) converts its planes into a buffer of yours. From `examples/pl_mpeg/02-frame`, which writes the result as a `.bmp`:

```freebasic
'' seek_exact = 1: decode forward from the key frame before 'at' to the frame AT it.
dim as plm_frame_t ptr frame = plm_seek_frame( plm, at, 1 )
if frame = nullptr then print "no frame at "; at; " s" : plm_destroy( plm ) : end 1
dim as integer w = frame->width, h = frame->height

'' A BMP row is padded to 4 bytes and stored bottom-up; plm_frame_to_bgr writes top-down rows of
'' 'stride' bytes. So: convert into a buffer with the BMP's stride, then write its rows last first.
dim as integer stride = (w * 3 + 3) and not 3
dim as uint8 ptr pixels = allocate( stride * h )
plm_frame_to_bgr( frame, pixels, stride )
```

`stride` is the distance between rows in the buffer, in bytes: here a BMP's, padded to 4.

## 4. Playing it, with sound

A player hands pl_mpeg the time that passed and lets it call back with whatever fell due. The frames go into a texture, and the samples go to an audio device. `examples/pl_mpeg/03-player` does it with [SDL3](SDL3-Tutorial) for the window and [miniaudio](Miniaudio-Tutorial) for the sound, three vendor packages in one program. Its video callback puts the planes straight into a texture, since SDL takes YCbCr as it is:

```freebasic
'' pl_mpeg's video callback: the frame's three planes into the texture. IYUV is Y, then U (Cb),
'' then V (Cr), each with its own pitch -- the plane's width in bytes.
sub OnVideo cdecl( byval plm as plm_t ptr, byval frame as plm_frame_t ptr, byval user as any ptr )
    SDL_UpdateYUVTexture( g_texture, nullptr, frame->y.data, frame->y.width, _
                          frame->cb.data, frame->cb.width, frame->cr.data, frame->cr.width )
    g_frames += 1
end sub
```

and its loop, with the audio callback filling a ring buffer that miniaudio's own thread drains:

```freebasic
plm_set_video_decode_callback( plm, @OnVideo, nullptr )
plm_set_audio_decode_callback( plm, @OnAudio, nullptr )

dim as boolean quit, paused, snapped
dim as SDL_Event e
dim as Uint64 last = SDL_GetTicksNS( )
while quit = false andalso plm_has_ended( plm ) = 0
    while SDL_PollEvent( @e )
        if e.type = SDL_EVENT_QUIT then quit = true
        if e.type = SDL_EVENT_KEY_DOWN then
            if e.key.key = SDLK_ESCAPE then quit = true
            if e.key.key = SDLK_SPACE then paused = not paused
        end if
    wend
    dim as Uint64 now = SDL_GetTicksNS( )
    if paused = false then plm_decode( plm, (now - last) / 1e9 )
    last = now
    SDL_RenderClear( renderer )
    SDL_RenderTexture( renderer, g_texture, nullptr, nullptr )
    if len( snapshot ) andalso snapped = false andalso plm_get_time( plm ) >= 1 then
        dim as SDL_Surface ptr shot = SDL_RenderReadPixels( renderer, nullptr )
        if shot then SDL_SaveBMP( shot, snapshot ) : SDL_DestroySurface( shot ) : snapped = true
    end if
    SDL_RenderPresent( renderer )
    SDL_Delay( 1 )
wend
```

pl_mpeg has no threads: both callbacks run inside `plm_decode`, on the program's thread. miniaudio's data callback does not -- that is why the samples cross through `ma_pcm_rb`, a ring buffer safe for one writer and one reader.

## 5. More programs

The toolchain's `examples/pl_mpeg`, each built with `tiko <name>.tiko`:

| Folder | Shows |
| --- | --- |
| `01-info` | what a file holds, every frame and sample decoded, a seek; on the bundled clip it checks what it finds |
| `02-frame` | the frame at a time, as a `.bmp` |
| `03-player` | a window and sound, pause and quit keys, and a snapshot of what the window showed |

## 6. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for pl_mpeg: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program; ship the `.mpg` files beside it as any other data.

## 7. Shipping the program

- **Linked dynamically** (the default): ship the library the build put beside the program -- `pl_mpeg.dll`, `pl_mpeg_linux_x86_64.so`, `pl_mpeg_linux_arm64.so` or `pl_mpeg_macos_arm64.dylib`.
- **Linked statically** (`#import "vendor/pl_mpeg" link static`): the program alone.

pl_mpeg is under the MIT licence: a program you distribute with it in it, linked either way, includes its copyright notice and licence. The text is `pkg/vendor/pl_mpeg/LICENSE` in the toolchain.

## 8. Troubleshooting

| Problem | Fix |
|---|---|
| `plm_probe` returns 0, or nothing decodes | the file is not MPEG-1 / MP2 in an MPEG program stream: convert it (section 2) |
| the program ends with `-1073740791` (`0xC0000409`) on Windows, in `plm_create_with_file` | linked dynamically, `pl_mpeg.dll` has its own C runtime and cannot use the program's `FILE`. Open by name (`plm_create_with_filename`), or link static |
| a frame's pixels change under you | a frame is valid only until the next decode call: copy it |
| sound and picture drift apart | the file's timing is irregular; convert it, which makes it constant |
| colours wrong in a texture: yellow and cyan swapped | the Cb and Cr planes are the wrong way round. SDL's `IYUV` is Y, then Cb (U), then Cr (V) |
| the program exits at once with `-1073741515` (Windows) | `pl_mpeg.dll` is not beside the program |

---

**Next:** [miniaudio](Miniaudio-Tutorial) · [SDL3](SDL3-Tutorial) · [Vendor Packages](Vendor-Packages)

[Home](Home)
