// TikoActivity -- the Activity of every 'tiko -app' APK (docs/tiko-android A4, D-A4-2).
//
// SDL is linked STATICALLY into the program's libmain.so, so there is no libSDL3.so to load: SDL's
// JNI_OnLoad and its natives come with libmain.so itself. SDLActivity's default list is
// {"SDL3", "main"}, and loading a library that is not in the APK fails the start; this is the
// whole difference. SDL_main, the entry tiko's -app emits, is still found in the last library.
package org.tiko.app;

import org.libsdl.app.SDLActivity;

public class TikoActivity extends SDLActivity {
    @Override
    protected String[] getLibraries() {
        return new String[] { "main" };
    }
}
