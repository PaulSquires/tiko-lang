# miniaudio examples

miniaudio's C interface from tiko, through `vendor/miniaudio`, which comes with the toolchain.
Each example is one `.tiko` program, built on its own with `tiko <name>.tiko`.

| Folder | Shows |
| --- | --- |
| `01-play` | the engine: open the default device, stream a file (WAV, FLAC, MP3, Ogg Vorbis) to its end -- `play [FILE] [VOLUME]` |
| `02-tone` | a playback device and a data callback filling it from `ma_waveform` -- `tone [SECONDS] [HERTZ] [AMPLITUDE]` |
| `03-record` | a capture device: the default microphone to a WAV file through `ma_encoder` -- `record [FILE] [SECONDS]` |
| `04-decode` | files to samples with `ma_decoder`, no device; then the engine on the null backend. Checks what it finds and exits 1 if anything is off |

`media/` holds the sound files they use: one second of a 440 Hz tone as WAV, FLAC, MP3 and Ogg
Vorbis, made by `media/make-media.sh` (ffmpeg), so they are free to use like the examples.

## Things to know

- **miniaudio's objects are yours, and must stay put.** `dim as ma_engine engine`, then
  `ma_engine_init( nullptr, @engine )`: miniaudio's threads keep pointers into it until
  `ma_engine_uninit`. Never copy an initialised `ma_engine`, `ma_sound`, `ma_device` or
  `ma_decoder`, and never let one go out of scope while it runs.
- **A data callback runs on miniaudio's audio thread.** It is a `cdecl` sub with the C
  signature -- `( byval device as ma_device ptr, byval output_ as any ptr, byval input_ as const
  any ptr, byval frames as ma_uint32 )` -- and is called many times a second while the main
  program does something else. Touch only its arguments and memory set up before the device
  started (`device->pUserData`); no strings, allocation or printing in it.
- **Use `sleep ms, 1` to wait.** A plain `sleep ms` ends early at a key press -- and at once when
  standard input is not a terminal, so a program run from a script stops its device before it
  has played anything.
- **Frame counts are unsigned.** `for i as ma_uint64 = 0 to n - 1` with `n = 0` runs to the
  type's maximum; count `1 to n`, or test `n` first.
- **A streamed Ogg Vorbis file has no length until it has played**: `ma_sound_get_length_in_seconds`
  reports 0 for it (stb_vorbis decodes it a page at a time). Load it without
  `MA_SOUND_FLAG_STREAM` to know the length first.
- **A volume of 0 still runs everything.** `play FILE 0` and `tone 1 440 0` open the real device
  and play, silently.

## Dynamic or static

Every example imports miniaudio with

```
#import "vendor/miniaudio" link dynamic
```

which links the shared library and copies it beside the program -- `miniaudio.dll` on Windows,
`miniaudio_linux_x86_64.so` on Linux, where the program finds it beside itself. Change `dynamic`
to `static` and miniaudio is built into the program instead, with nothing to copy. Either way it
needs no system audio library: miniaudio loads the backend (WASAPI, PulseAudio, ALSA, ...) when a
device is opened.

These examples are public domain or MIT-0, as miniaudio is.
