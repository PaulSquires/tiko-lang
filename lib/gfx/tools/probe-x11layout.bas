'' probe-x11layout.bas -- the sizes and offsets driver/x11 relies on, from inc/X11.
''
'' ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
'' exception). Paired with probe-x11layout.c; tools/gate-x11layout.sh diffs them.
'' The bindings are included inside a namespace, exactly as driver/x11/xlib.ti does.
namespace X
#include once "X11/Xlib.bi"
#include once "X11/Xutil.bi"
#include once "X11/extensions/XShm.bi"
#include once "X11/extensions/Xrandr.bi"
end namespace
#define P( nm, v ) print nm & " " & str( clng( v ) )
P( "XEvent.size", sizeof( X.XEvent ) )
P( "XKeyEvent.time", offsetof( X.XKeyEvent, time ) ) : P( "XKeyEvent.keycode", offsetof( X.XKeyEvent, keycode ) ) : P( "XKeyEvent.state", offsetof( X.XKeyEvent, state ) )
P( "XButtonEvent.time", offsetof( X.XButtonEvent, time ) ) : P( "XButtonEvent.button", offsetof( X.XButtonEvent, button ) )
P( "XMotionEvent.x", offsetof( X.XMotionEvent, x ) ) : P( "XMotionEvent.y", offsetof( X.XMotionEvent, y ) )
P( "XMotionEvent.x_root", offsetof( X.XMotionEvent, x_root ) ) : P( "XMotionEvent.y_root", offsetof( X.XMotionEvent, y_root ) )
P( "XClientMessageEvent.data", offsetof( X.XClientMessageEvent, data ) ) : P( "XMapEvent.event", offsetof( X.XMapEvent, event ) )
P( "XConfigureEvent.width", offsetof( X.XConfigureEvent, width ) )
P( "XImage.data", offsetof( X.XImage, data ) ) : P( "XImage.bytes_per_line", offsetof( X.XImage, bytes_per_line ) )
P( "XImage.bits_per_pixel", offsetof( X.XImage, bits_per_pixel ) ) : P( "XImage.f.destroy_image", offsetof( X.XImage, f ) + offsetof( X.funcs, destroy_image ) )
P( "XSetWindowAttributes.size", sizeof( X.XSetWindowAttributes ) ) : P( "XSetWindowAttributes.event_mask", offsetof( X.XSetWindowAttributes, event_mask ) )
P( "XSetWindowAttributes.colormap", offsetof( X.XSetWindowAttributes, colormap ) ) : P( "XSetWindowAttributes.backing_store", offsetof( X.XSetWindowAttributes, backing_store ) )
P( "XSizeHints.size", sizeof( X.XSizeHints ) ) : P( "XSizeHints.min_width", offsetof( X.XSizeHints, min_width ) ) : P( "XSizeHints.max_width", offsetof( X.XSizeHints, max_width ) ) : P( "XSizeHints.base_width", offsetof( X.XSizeHints, base_width ) )
P( "XPixmapFormatValues.size", sizeof( X.XPixmapFormatValues ) ) : P( "XPixmapFormatValues.bits_per_pixel", offsetof( X.XPixmapFormatValues, bits_per_pixel ) )
P( "XShmSegmentInfo.size", sizeof( X.XShmSegmentInfo ) ) : P( "XShmSegmentInfo.shmid", offsetof( X.XShmSegmentInfo, shmid ) ) : P( "XShmSegmentInfo.shmaddr", offsetof( X.XShmSegmentInfo, shmaddr ) ) : P( "XShmSegmentInfo.readOnly", offsetof( X.XShmSegmentInfo, readOnly ) )
P( "Visual.red_mask", offsetof( X.Visual, red_mask ) )
P( "XColor.size", sizeof( X.XColor ) ) : P( "XColor.flags", offsetof( X.XColor, flags ) )
P( "XWindowAttributes.size", sizeof( X.XWindowAttributes ) ) : P( "XWindowAttributes.x", offsetof( X.XWindowAttributes, x ) ) : P( "XWindowAttributes.y", offsetof( X.XWindowAttributes, y ) )
P( "XRRScreenSize.size", sizeof( X.XRRScreenSize ) ) : P( "XRRScreenSize.height", offsetof( X.XRRScreenSize, height ) )
