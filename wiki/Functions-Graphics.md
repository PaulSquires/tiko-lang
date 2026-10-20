[Home](Home) › [Function Finder](Function-Finder) › **Graphics and windows**

# Graphics and windows

The functions to draw on a graphics screen, read the mouse, build Windows GUI controls, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- **built-in**: nothing; it is always available.
- `vendor/PsControls/<Name>`: `#import "vendor/PsControls/<Name>"`, then `using <Name>` to call it by its bare name.
- `fbgfx.bi`: `#include "fbgfx.bi"`.

Jump to: [Open a graphics window](#open-a-graphics-window) · [Draw lines, shapes and pixels](#draw-lines-shapes-and-pixels) · [Draw text](#draw-text) · [Make colours](#make-colours) · [Create and inspect images](#create-and-inspect-images) · [Copy images to and from the screen](#copy-images-to-and-from-the-screen) · [Choose how Put combines pixels](#choose-how-put-combines-pixels) · [Load and save images](#load-and-save-images) · [Draw without flicker](#draw-without-flicker) · [Set the drawing area and coordinates](#set-the-drawing-area-and-coordinates) · [Read the mouse, keyboard and joystick](#read-the-mouse-keyboard-and-joystick) · [Run a program of controls](#run-a-program-of-controls) · [Take text, numbers and dates from the user](#take-text-numbers-and-dates-from-the-user) · [Add buttons and switches](#add-buttons-and-switches) · [Show lists and choices](#show-lists-and-choices) · [Add menus, toolbars and status bars](#add-menus-toolbars-and-status-bars) · [Split, scroll and lay out a window](#split-scroll-and-lay-out-a-window) · [Show messages, colour pickers and tooltips](#show-messages-colour-pickers-and-tooltips) · [Show progress and charts](#show-progress-and-charts) · [Paint and support your own controls](#paint-and-support-your-own-controls)

## Open a graphics window

| Function | What it does | From |
|---|---|---|
| [ScreenRes](Screenres) | Opens a graphics window of a given width, height and colour depth. | built-in |
| [Screen](Screen-Graphics) | Opens a graphics mode by mode number, or picks the work and visible pages. | built-in |
| [WindowTitle](Windowtitle) | Sets the title of the graphics window. | built-in |
| [ScreenList](Screenlist) | Returns the fullscreen resolutions for a colour depth, one per call, then 0. | built-in |
| [ScreenInfo](Screeninfo) | Fills in the screen's width, height, depth and driver, or the desktop's if none is open. | built-in |
| [ScreenControl](Screencontrol) | Sets or reads graphics library settings, such as the driver or the window position. | built-in |
| [ScreenGLProc](Screenglproc) | Returns the address of an OpenGL procedure by name, or 0 if it is not found. | built-in |

## Draw lines, shapes and pixels

| Function | What it does | From |
|---|---|---|
| [PSet](Pset-Statement) | Plots one pixel, in the given colour or the current foreground colour. | built-in |
| [PReset](Preset) | Plots one pixel, in the given colour or the current background colour. | built-in |
| [Line](Line-Graphics) | Draws a line between two points, or a box or filled box with B or BF. | built-in |
| [Circle](Circle) | Draws a circle, ellipse or arc, optionally filled. | built-in |
| [Paint](Paint) | Fills the area enclosed by a border colour with a colour or a pattern. | built-in |
| [Draw](Draw) | Draws a figure from a string of pen commands such as "U10 R10". | built-in |
| [Point](Point) | Returns the colour of a pixel, or -1 if it is off the screen or image. | built-in |
| [PointCoord](Pointcoord) | Returns the x or y position of the Draw pen. | built-in |

## Draw text

| Function | What it does | From |
|---|---|---|
| [Draw String](Draw-String) | Draws text at a pixel position, on a transparent background, with an optional font. | built-in |

## Make colours

| Function | What it does | From |
|---|---|---|
| [RGB](Rgb) | Returns an opaque colour value from red, green and blue parts of 0 to 255. | built-in |
| [RGBA](Rgba) | Returns a colour value from red, green, blue and alpha parts of 0 to 255. | built-in |
| [Palette](Palette) | Sets or reads the colours of a palette mode, or restores the default palette. | built-in |

## Create and inspect images

| Function | What it does | From |
|---|---|---|
| [ImageCreate](Imagecreate) | Creates an image of a given size filled with one colour; returns 0 on failure. | built-in |
| [ImageDestroy](Imagedestroy) | Frees an image made by ImageCreate. | built-in |
| [ImageInfo](Imageinfo) | Fills in an image's width, height, bytes per pixel, pitch and pixel pointer. | built-in |
| [ImageConvertRow](Imageconvertrow) | Copies a row of pixels to another buffer, converting its colour depth. | built-in |

## Copy images to and from the screen

| Function | What it does | From |
|---|---|---|
| [Get](Get-Graphics) | Copies a rectangle of the screen or an image into an image buffer. | built-in |
| [Put](Put-Graphics) | Draws an image onto the screen or another image, with a choice of blending method. | built-in |

## Choose how Put combines pixels

| Function | What it does | From |
|---|---|---|
| [PSet](Pset-Graphics-Put) (Put method) | Copies source pixels over the destination unchanged, as a Put method. | built-in |
| [Trans](Trans) | Copies pixels with Put but skips the mask colour, magenta or index 0. | built-in |
| [Alpha](Alpha) | Blends pixels with Put by each pixel's alpha, or by one alpha value you give. | built-in |
| [Add](Add) | Adds source and destination colour values with Put, capped at 255. | built-in |
| [And](And-Graphics-Put) | Combines source and destination pixels with a bitwise And, as a Put method. | built-in |
| [Or](Or-Graphics-Put) | Combines source and destination pixels with a bitwise Or, as a Put method. | built-in |
| [Xor](Xor-Graphics-Put) | Combines source and destination pixels with a bitwise Xor, as a Put method. | built-in |
| [Custom](Custom) | Calls your own function for each pixel to combine source and destination in Put. | built-in |

## Load and save images

| Function | What it does | From |
|---|---|---|
| [BLoad](Bload) | Loads a BMP file or BSave data onto the screen or into memory. | built-in |
| [BSave](Bsave) | Saves memory or the screen to a file, as a BMP image if the name ends in .bmp. | built-in |

## Draw without flicker

| Function | What it does | From |
|---|---|---|
| [ScreenLock](Screenlock) | Stops screen updates while you draw, so the user never sees half a frame. | built-in |
| [ScreenUnlock](Screenunlock) | Resumes screen updates after ScreenLock and shows what was drawn. | built-in |
| [ScreenSet](Screenset) | Sets which page is drawn on and which page is shown. | built-in |
| [ScreenCopy](Screencopy) | Copies one graphics page onto another, by default the work page onto the shown one. | built-in |
| [PCopy](Pcopy) | Copies one graphics or text page onto another. | built-in |
| [Flip](Flip) | Shows the OpenGL back buffer, or copies a page as ScreenCopy does in other modes. | built-in |
| [ScreenSync](Screensync) | Waits for the display to finish drawing a frame, to reduce flicker. | built-in |
| [ScreenPtr](Screenptr) | Returns a pointer to the work page's pixels, or 0 if no graphics mode is set. | built-in |

## Set the drawing area and coordinates

| Function | What it does | From |
|---|---|---|
| [View](View-Graphics) | Sets the rectangle that drawing is clipped to, or resets it to the whole screen. | built-in |
| [Window](Window) | Sets the coordinate system mapped onto the current view. | built-in |
| [PMap](Pmap) | Converts a coordinate between the Window system and physical pixels. | built-in |

## Read the mouse, keyboard and joystick

| Function | What it does | From |
|---|---|---|
| [GetMouse](Getmouse) | Fills in the mouse position, wheel and buttons, or -1 in each if there is no mouse. | built-in |
| [SetMouse](Setmouse) | Moves the mouse pointer, shows or hides it, or keeps it inside the window. | built-in |
| [MultiKey](Multikey) | Returns -1 while the key with a given scancode is held down, or 0 if it is not. | built-in |
| [GetJoystick](Getjoystick) | Fills in a joystick's buttons and axis positions; returns 0 on success or 1. | built-in |
| [ScreenEvent](Screenevent) | Returns -1 if a mouse, keyboard or window event is waiting, and fetches it. | built-in |
| [Event](Event-Message-Data-From-Screenevent) | Holds one event fetched by ScreenEvent: its type and its key or mouse data. | `fbgfx.bi` |

## Run a program of controls

| Function | What it does | From |
|---|---|---|
| [PsApp](PsApp) | Runs a program of controls: start-up, the message loop, forms with callbacks, DPI. | `vendor/PsControls/PsApp` |
| [PsTheme](PsTheme) | Colours every control from one light or dark theme that can follow Windows. | `vendor/PsControls/PsTheme` |

## Take text, numbers and dates from the user

| Function | What it does | From |
|---|---|---|
| [PsTextBox](PsTextBox) | Lets the user type text in a themed frame, on one line or several. | `vendor/PsControls/PsTextBox` |
| [PsNumericUpDown](PsNumericUpDown) | Lets the user pick a number with minus and plus buttons, or type it. | `vendor/PsControls/PsNumericUpDown` |
| [PsDatePicker](PsDatePicker) | Lets the user type a date or pick it from a dropdown calendar. | `vendor/PsControls/PsDatePicker` |
| [PsCalendar](PsCalendar) | Shows one or more month grids inside your window for choosing a day. | `vendor/PsControls/PsCalendar` |

## Add buttons and switches

| Function | What it does | From |
|---|---|---|
| [PsButton](PsButton) | Draws a push button with an optional caption and icons on either side. | `vendor/PsControls/PsButton` |
| [PsCheckBox](PsCheckBox) | Draws a checkbox, checked or unchecked, with an optional caption. | `vendor/PsControls/PsCheckBox` |
| [PsOptionButton](PsOptionButton) | Draws a radio button; checking one in a group unchecks the others. | `vendor/PsControls/PsOptionButton` |
| [PsToggle](PsToggle) | Draws an on and off switch: a pill with a knob at one end. | `vendor/PsControls/PsToggle` |

## Show lists and choices

| Function | What it does | From |
|---|---|---|
| [PsListTree](PsListTree) | Shows a list, tree or multi-column report of rows you paint, with in-place renaming. | `vendor/PsControls/PsListTree` |
| [PsComboBox](PsComboBox) | Shows the current choice on a button that drops down a list of the others. | `vendor/PsControls/PsComboBox` |
| [PsSelectBar](PsSelectBar) | Shows a row of labels with a line under the current one, for switching views. | `vendor/PsControls/PsSelectBar` |
| [PsTabBar](PsTabBar) | Shows a strip of tabs that can be selected, closed and dragged to a new place. | `vendor/PsControls/PsTabBar` |

## Add menus, toolbars and status bars

| Function | What it does | From |
|---|---|---|
| [PsMenuBar](PsMenuBar) | Shows a menu bar of items such as File and Edit, each with its own dropdown. | `vendor/PsControls/PsMenuBar` |
| [PsToolbar](PsToolbar) | Shows a strip of command buttons; items that do not fit move into an overflow menu. | `vendor/PsControls/PsToolbar` |
| [PsIconPanel](PsIconPanel) | Shows a strip of icon buttons and toggles, spaced exactly as you declare. | `vendor/PsControls/PsIconPanel` |
| [PsStatusBar](PsStatusBar) | Shows panels of text in a strip along the bottom of a window. | `vendor/PsControls/PsStatusBar` |

## Split, scroll and lay out a window

| Function | What it does | From |
|---|---|---|
| [PsSplitter](PsSplitter) | Draws a divider between two panes that the user drags, and reports where it went. | `vendor/PsControls/PsSplitter` |
| [PsScrollPanel](PsScrollPanel) | Scrolls a page of ordinary child controls that is taller than the space for it. | `vendor/PsControls/PsScrollPanel` |
| [PsVScrollBar](PsVScrollBar) | Draws a vertical scrollbar for content whose scrolling you manage yourself. | `vendor/PsControls/PsVScrollBar` |
| [PsHScrollBar](PsHScrollBar) | Draws a horizontal scrollbar for content whose scrolling you manage yourself. | `vendor/PsControls/PsHScrollBar` |

## Show messages, colour pickers and tooltips

| Function | What it does | From |
|---|---|---|
| [PsMessageBox](PsMessageBox) | Shows a themed modal message box with an optional icon and one to three buttons. | `vendor/PsControls/PsMessageBox` |
| [PsColorPicker](PsColorPicker) | Shows a modal colour picker and returns true with the colour, or false if abandoned. | `vendor/PsControls/PsColorPicker` |
| [PsTooltip](PsTooltip) | Shows a themed tooltip near the cursor, with an optional title, wrapping and fade. | `vendor/PsControls/PsTooltip` |

## Show progress and charts

| Function | What it does | From |
|---|---|---|
| [PsProgressBar](PsProgressBar) | Draws a progress bar, flat or gradient, solid or in blocks, or with no known end. | `vendor/PsControls/PsProgressBar` |
| [PsChart](PsChart) | Draws a line, column, price or pie chart from the series you supply. | `vendor/PsControls/PsChart` |

## Paint and support your own controls

| Function | What it does | From |
|---|---|---|
| [PsBufferPaint](PsBufferPaint) | Paints a window offscreen and copies it in one go, so drawing never flickers. | `vendor/PsControls/PsBufferPaint` |
| [PsImage](PsImage) | Loads an icon, PNG, BMP or JPEG file so a control can show it in an icon slot. | `vendor/PsControls/PsImage` |
| [PsPopupMenu](PsPopupMenu) | Shows a themed popup menu with checks, accelerator labels and nested submenus. | `vendor/PsControls/PsPopupMenu` |
| [PsColumnHeader](PsColumnHeader) | Draws a band of resizable column headers above a list or grid. | `vendor/PsControls/PsColumnHeader` |
| [PsTipHost](PsTipHost) | Switches the controls' tooltips between the system tooltip and PsTooltip. | `vendor/PsControls/PsTipHost` |
| [PsRegistry](PsRegistry) | Keeps what each control needs from the message loop, the theme and DPI changes. | `vendor/PsControls/PsRegistry` |

## See Also

- [Screen functions](Category-Screen-Functions)
- [2D drawing functions](Category-2D-Drawing-Functions)
- [Graphics input functions](Category-User-Input-Functions-Graphics-Library)
- [PsControls guide](Category-PsControls)
- [Vendor packages](Vendor-Packages)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
