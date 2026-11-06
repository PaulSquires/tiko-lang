/* probe-x11layout.c -- the sizes and offsets driver/x11 relies on, from the C headers.
 *
 * ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
 * exception). Paired with probe-x11layout.bas, which prints the same lines from
 * tiko's X11 bindings; tools/gate-x11layout.sh diffs them. */
#include <stdio.h>
#include <stddef.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XShm.h>
#include <X11/extensions/Xrandr.h>
#define P(name, v) printf("%s %ld\n", name, (long)(v))
int main(void) {
    P("XEvent.size", sizeof(XEvent));
    P("XKeyEvent.time", offsetof(XKeyEvent, time)); P("XKeyEvent.keycode", offsetof(XKeyEvent, keycode)); P("XKeyEvent.state", offsetof(XKeyEvent, state));
    P("XButtonEvent.time", offsetof(XButtonEvent, time)); P("XButtonEvent.button", offsetof(XButtonEvent, button));
    P("XMotionEvent.x", offsetof(XMotionEvent, x)); P("XMotionEvent.y", offsetof(XMotionEvent, y));
    P("XMotionEvent.x_root", offsetof(XMotionEvent, x_root)); P("XMotionEvent.y_root", offsetof(XMotionEvent, y_root));
    P("XClientMessageEvent.data", offsetof(XClientMessageEvent, data)); P("XMapEvent.event", offsetof(XMapEvent, event));
    P("XConfigureEvent.width", offsetof(XConfigureEvent, width));
    P("XImage.data", offsetof(XImage, data)); P("XImage.bytes_per_line", offsetof(XImage, bytes_per_line));
    P("XImage.bits_per_pixel", offsetof(XImage, bits_per_pixel)); P("XImage.f.destroy_image", offsetof(XImage, f.destroy_image));
    P("XSetWindowAttributes.size", sizeof(XSetWindowAttributes)); P("XSetWindowAttributes.event_mask", offsetof(XSetWindowAttributes, event_mask));
    P("XSetWindowAttributes.colormap", offsetof(XSetWindowAttributes, colormap)); P("XSetWindowAttributes.backing_store", offsetof(XSetWindowAttributes, backing_store));
    P("XSizeHints.size", sizeof(XSizeHints)); P("XSizeHints.min_width", offsetof(XSizeHints, min_width)); P("XSizeHints.max_width", offsetof(XSizeHints, max_width)); P("XSizeHints.base_width", offsetof(XSizeHints, base_width));
    P("XPixmapFormatValues.size", sizeof(XPixmapFormatValues)); P("XPixmapFormatValues.bits_per_pixel", offsetof(XPixmapFormatValues, bits_per_pixel));
    P("XShmSegmentInfo.size", sizeof(XShmSegmentInfo)); P("XShmSegmentInfo.shmid", offsetof(XShmSegmentInfo, shmid)); P("XShmSegmentInfo.shmaddr", offsetof(XShmSegmentInfo, shmaddr)); P("XShmSegmentInfo.readOnly", offsetof(XShmSegmentInfo, readOnly));
    P("Visual.red_mask", offsetof(Visual, red_mask));
    P("XColor.size", sizeof(XColor)); P("XColor.flags", offsetof(XColor, flags));
    P("XWindowAttributes.size", sizeof(XWindowAttributes)); P("XWindowAttributes.x", offsetof(XWindowAttributes, x)); P("XWindowAttributes.y", offsetof(XWindowAttributes, y));
    P("XRRScreenSize.size", sizeof(XRRScreenSize)); P("XRRScreenSize.height", offsetof(XRRScreenSize, height));
    return 0;
}
