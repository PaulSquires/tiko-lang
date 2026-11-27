[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **miniaudio**

# miniaudio Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link static` and `link dynamic` work.
>
> 📖 **In the book:** [Chapter 28, Sound and video](https://tiko-lang.net/book/ch28-logging-tui-sqlite.html#sound-and-video). Measured with miniaudio 0.11.26 and tiko on Windows, Linux and macOS.

[miniaudio](https://miniaud.io) is an audio library in one C file: it plays and records through the system's own audio (WASAPI, DirectSound, WinMM; PulseAudio, ALSA, JACK; Core Audio), decodes WAV, FLAC, MP3 and Ogg Vorbis, and mixes sounds with a high-level engine -- volume, panning, fades, groups, 3D positions, streaming.

tiko ships miniaudio 0.11.26 as a [vendor package](Vendor-Packages), with stb_vorbis 1.25 as its Ogg Vorbis decoder. One line gives a program miniaudio's whole C API and links the library:

```freebasic
#import "vendor/miniaudio"
```

There is nothing to download, no header to translate, no `#foreignlib` and nothing on the command line. miniaudio needs no system audio library either: it loads the platform's backend when a device is opened. The names are the ones [miniaudio's documentation](https://miniaud.io/docs/manual/) uses -- `ma_engine_init`, `ma_sound_start`, `ma_decoder_read_pcm_frames`. More programs are in the toolchain's `examples/miniaudio`, with the sound files these use in `examples/miniaudio/media`.

> ⚠️ **Not on Android yet.** `#import "vendor/miniaudio"` stops with an error on the Android targets: five of miniaudio's records are laid out differently there, and the header translator has no Android pass yet.

---

## 1. Playing a sound

The engine is the short way: it opens the default device, decodes the file on its own thread and plays it. The program starts the sound and waits for its end:

```freebasic
'' Play a sound file to its end through the default device -- miniaudio's engine.
#import "vendor/miniaudio"

dim path as string = command( 1 )
if len( path ) = 0 then print "play FILE [VOLUME]" : end 1

'' The engine opens the default playback device and mixes everything played through it.
'' It is your memory, and miniaudio's threads point into it: it stays put until uninit.
dim engine as ma_engine
if ma_engine_init( nullptr, @engine ) <> MA_SUCCESS then print "no audio device" : end 1
if len( command( 2 ) ) then ma_engine_set_volume( @engine, val( command( 2 ) ) )

dim snd as ma_sound
if ma_sound_init_from_file( @engine, path, MA_SOUND_FLAG_STREAM, nullptr, nullptr, _
        @snd ) <> MA_SUCCESS then
    print "cannot play "; path
    ma_engine_uninit( @engine )
    end 1
end if

dim device as ma_device ptr = ma_engine_get_device( @engine )
print "playing " & path & " on " & *ma_get_backend_name( device->pContext->backend )
ma_sound_start( @snd )
while ma_sound_at_end( @snd ) = 0
    sleep 50, 1          '' ', 1': a plain sleep ends early at a key press
wend
print "done"
ma_sound_uninit( @snd )
ma_engine_uninit( @engine )
```

```
> play tone.ogg
playing tone.ogg on WASAPI
done
```

The backend is the platform's: `WASAPI` on Windows, `PulseAudio` or `ALSA` on Linux, `Core Audio` on macOS. `ma_engine_play_sound( @engine, "chime.ogg", nullptr )` plays a sound with no `ma_sound` to keep, fire and forget -- right for a click or a beep. A sound you start, stop, loop (`ma_sound_set_looping`), fade (`ma_sound_set_fade_in_milliseconds`) or move (`ma_sound_set_pan`, `ma_sound_set_pitch`) is an `ma_sound`.

Two things in it matter everywhere:

- **The engine and the sound are your memory, and must stay where they are.** `dim engine as ma_engine`, then `ma_engine_init( nullptr, @engine )`: miniaudio's threads keep pointers into it until `ma_engine_uninit`. Never copy an initialised `ma_engine`, `ma_sound`, `ma_device` or `ma_decoder`.
- **Wait with `sleep ms, 1`.** A plain `sleep ms` ends early at a key press -- and at once when the program's input is not a terminal (run from a script or another program), so the device is stopped before anything is heard.

## 2. Reading a sound file

`ma_decoder` turns a file into samples, in the format you ask for, with no device at all -- for analysing audio, converting it, or feeding it to something else:

```freebasic
'' Sound files to samples with miniaudio, one of the vendor packages: no device needed.
#import "vendor/miniaudio"

'' Decode one file to 32-bit float, and say what is in it.
sub Describe( byref path as const string )
    '' ma_format_f32, 0 channels, rate 0: float samples, at the file's own channels and rate.
    dim config as ma_decoder_config = ma_decoder_config_init( ma_format_f32, 0, 0 )
    dim decoder as ma_decoder
    if ma_decoder_init_file( path, @config, @decoder ) <> MA_SUCCESS then
        print path; ": not a sound file miniaudio reads"
        exit sub
    end if
    dim sampleFormat as ma_format
    dim channels as ma_uint32, rate as ma_uint32
    ma_decoder_get_data_format( @decoder, @sampleFormat, @channels, @rate, nullptr, 0 )

    dim buffer( 0 to 4096 * 2 - 1 ) as float32      '' 4096 stereo frames at a time
    dim frames as ma_uint64, got as ma_uint64
    dim peak as float32
    do
        ma_decoder_read_pcm_frames( @decoder, @buffer( 0 ), 4096, @got )
        for i as ma_uint64 = 1 to got * channels    '' 1 to n: got is unsigned
            if abs( buffer( i - 1 ) ) > peak then peak = abs( buffer( i - 1 ) )
        next
        frames += got
    loop while got > 0
    ma_decoder_uninit( @decoder )
    print path & ": " & frames & " frames, " & channels & " channels, " & rate & " Hz, " & _
          frames / rate & " s, peak " & cint( peak * 100 ) & "% of full scale"
end sub

Describe( "tone.wav" )
Describe( "tone.flac" )
Describe( "tone.mp3" )
Describe( "tone.ogg" )
Describe( "decode.tiko" )
```

```
tone.wav: 44100 frames, 2 channels, 44100 Hz, 1 s, peak 9% of full scale
tone.flac: 44100 frames, 2 channels, 44100 Hz, 1 s, peak 9% of full scale
tone.mp3: 44100 frames, 2 channels, 44100 Hz, 1 s, peak 8% of full scale
tone.ogg: 44100 frames, 2 channels, 44100 Hz, 1 s, peak 9% of full scale
decode.tiko: not a sound file miniaudio reads
```

The same tone in four formats: the two lossless ones decode to exactly the same samples, the two lossy ones close to them. Frame counts are `ma_uint64`, unsigned: `for i = 0 to n - 1` with `n = 0` would run to the type's maximum, so the loop counts `1 to n`.

## 3. Making the sound yourself

A device with a **data callback** is the other way round: miniaudio asks for frames, many times a second, and the program writes them -- a synthesiser, a game's own mixer, or, here, `ma_waveform`'s sine:

```freebasic
'' A tone made by the program, one buffer at a time, in a data callback.
#import "vendor/miniaudio"

'' THE CALLBACK RUNS ON MINIAUDIO'S AUDIO THREAD, while the main program sleeps. It touches only
'' what it is handed: the device -- whose pUserData is the sine generator -- and the buffer.
sub OnData cdecl( byval device as ma_device ptr, byval output_ as any ptr, _
        byval input_ as const any ptr, byval frames as ma_uint32 )
    ma_waveform_read_pcm_frames( device->pUserData, output_, frames, nullptr )
end sub

dim amplitude as float64 = 0.2
if len( command( 1 ) ) then amplitude = val( command( 1 ) )

'' A 440 Hz sine, stereo float at 48 kHz -- the same format the device is asked for.
dim waveConfig as ma_waveform_config = ma_waveform_config_init( ma_format_f32, 2, 48000, _
    ma_waveform_type_sine, amplitude, 440 )
dim wave as ma_waveform
ma_waveform_init( @waveConfig, @wave )

dim config as ma_device_config = ma_device_config_init( ma_device_type_playback )
config.playback.format = ma_format_f32
config.playback.channels = 2
config.sampleRate = 48000
config.dataCallback = @OnData
config.pUserData = @wave

dim device as ma_device
if ma_device_init( nullptr, @config, @device ) <> MA_SUCCESS then print "no audio device" : end 1
ma_device_start( @device )
print "two seconds of 440 Hz"
sleep 2000, 1
ma_device_stop( @device )       '' returns after the callback's last call
ma_device_uninit( @device )
ma_waveform_uninit( @wave )
```

The callback is a `cdecl` sub with the C signature, and it **runs on miniaudio's audio thread**, not the program's. Touch only its arguments and memory set up before the device started -- `pUserData` is there for that. No strings, no allocation, no printing: a callback that is late is heard as a click. `ma_device_stop` returns after the callback's last call, so whatever it used may be freed after that.

## 4. Recording

A capture device is the same with the arrows reversed: the callback receives frames in `input_`. Here they go straight into `ma_encoder`, which writes a WAV file:

```freebasic
'' Three seconds from the default microphone into a WAV file.
#import "vendor/miniaudio"

'' On the audio thread: the frames the device captured arrive in input_, straight into the
'' encoder the main program opened.
sub OnData cdecl( byval device as ma_device ptr, byval output_ as any ptr, _
        byval input_ as const any ptr, byval frames as ma_uint32 )
    ma_encoder_write_pcm_frames( device->pUserData, input_, frames, nullptr )
end sub

dim encoderConfig as ma_encoder_config = ma_encoder_config_init( ma_encoding_format_wav, _
    ma_format_s16, 2, 44100 )
dim encoder as ma_encoder
if ma_encoder_init_file( "recording.wav", @encoderConfig, @encoder ) <> MA_SUCCESS then
    print "cannot write recording.wav" : end 1
end if

dim config as ma_device_config = ma_device_config_init( ma_device_type_capture )
config.capture.format = ma_format_s16           '' what the encoder writes
config.capture.channels = 2
config.sampleRate = 44100
config.dataCallback = @OnData
config.pUserData = @encoder

dim device as ma_device
if ma_device_init( nullptr, @config, @device ) <> MA_SUCCESS then
    print "no microphone"
    ma_encoder_uninit( @encoder )
    end 1
end if
ma_device_start( @device )
print "recording for three seconds..."
sleep 3000, 1
ma_device_stop( @device )
ma_device_uninit( @device )
ma_encoder_uninit( @encoder )                   '' finishes the WAV header
print "saved recording.wav"
```

The device delivers 16-bit stereo at 44.1 kHz because the config asks for it, whatever the microphone does: miniaudio converts. On a machine with no microphone, or one the program may not use (macOS may ask the user first), `ma_device_init` fails.

## 5. More programs

The toolchain's `examples/miniaudio`, each built with `tiko <name>.tiko`:

| Folder | Shows |
| --- | --- |
| `01-play` | the engine, streaming a file to its end, a volume argument |
| `02-tone` | a device and a callback, the frames it was asked for counted |
| `03-record` | the microphone to a WAV file |
| `04-decode` | four formats decoded and checked against each other, then the engine on miniaudio's **null backend** -- a device that plays nowhere, for testing on a machine with no sound card |

`examples/pl_mpeg/03-player` plays a video's sound through miniaudio, handing the samples from the video decoder's thread to the audio thread with `ma_pcm_rb`, miniaudio's ring buffer -- see the [pl_mpeg tutorial](PL-MPEG-Tutorial).

## 6. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for miniaudio: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program.

## 7. Shipping the program

- **Linked dynamically** (the default): ship the library the build put beside the program -- `miniaudio.dll`, `miniaudio_linux_x86_64.so`, `miniaudio_linux_arm64.so` or `miniaudio_macos_arm64.dylib`.
- **Linked statically** (`#import "vendor/miniaudio" link static`): the program alone.

miniaudio and stb_vorbis are each public domain, or MIT-0 / MIT where public domain is not recognised; MIT-0 asks for no notice, MIT for its notice to be kept. The texts are `pkg/vendor/miniaudio/LICENSE` in the toolchain.

## 8. Troubleshooting

| Problem | Fix |
|---|---|
| the program ends at once, nothing heard, no error | a plain `sleep ms` ended early (a key, or input not from a terminal): `sleep ms, 1` |
| a sound plays, then the program crashes or goes silent | an `ma_engine` / `ma_sound` / `ma_device` was copied, or left its scope while running: keep it in one place until uninit |
| a loop over frames runs forever, or past its buffer | `for i = 0 to n - 1` with an unsigned `n` of 0. Count `1 to n` |
| `ma_sound_get_length_in_seconds` says 0 for an `.ogg` | a streamed Ogg Vorbis file's length is not known before it plays; load it without `MA_SOUND_FLAG_STREAM` to know it first |
| clicks and gaps from a data callback | the callback waits for something, allocates or prints. Prepare everything before `ma_device_start` |
| `ma_device_init` / `ma_engine_init` fails | no device (a server, a container), or the program may not use the microphone. A context limited to `ma_backend_null` runs without one (`examples/miniaudio/04-decode`) |
| `TKO0309: #error: "vendor/miniaudio is not translated for Android..."` | as it says: not on Android yet |
| the program exits at once with `-1073741515` (Windows) | `miniaudio.dll` is not beside the program |

---

**Next:** [pl_mpeg](PL-MPEG-Tutorial) · [SDL3](SDL3-Tutorial) · [raylib](Raylib-Tutorial) · [Vendor Packages](Vendor-Packages)

[Home](Home)
