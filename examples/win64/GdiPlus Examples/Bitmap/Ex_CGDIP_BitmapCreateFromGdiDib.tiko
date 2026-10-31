' ########################################################################################
' Microsoft Windows
' Contents: GDI+ - BitmapCreateFromGdiDib example
' Compiler: tiko-lang
' Copyright (c) 2026 José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
using win, gui, gdiplus

CONST IDC_GRCTX = 1001

' // Forward declaration
DECLARE FUNCTION WndProc (BYVAL hwnd AS HWND, BYVAL uMsg AS UINT, BYVAL wParam AS WPARAM, BYVAL lParam AS LPARAM) AS LRESULT

' ========================================================================================
' This example creates a GpBitmap from a manually constructed BITMAPINFO and pixel buffer.
' ========================================================================================
SUB Example_CreateFromGdiDib (BYVAL hdc AS HDC)

   ' // Create a graphics object from the window device context
   DIM graphics AS CGpGraphics = hdc
   ' // Set the scaling factors using the DPI ratios
   graphics.ScaleTransformForDpi

   ' // Define bitmap dimensions
   DIM nWidth AS LONG = 100
   DIM nHeight AS LONG = 100
   DIM bytesPerPixel AS LONG = 4
   DIM stride AS LONG = nWidth * bytesPerPixel

   ' // Allocate pixel buffer
   DIM buffer(stride * nHeight - 1) AS UBYTE

   ' // Fill buffer with gradient
   FOR y AS LONG = 0 TO nHeight - 1
      FOR x AS LONG = 0 TO nWidth - 1
         DIM offset AS LONG = y * stride + x * bytesPerPixel
         buffer(offset + 0) = x * 255 \ nWidth   ' Blue
         buffer(offset + 1) = y * 255 \ nHeight  ' Green
         buffer(offset + 2) = 128                ' Red
         buffer(offset + 3) = 255                ' Alpha
      NEXT
   NEXT

   ' // Define BITMAPINFO header
   DIM bmi AS BITMAPINFO
   WITH bmi.bmiHeader
      .biSize = SIZEOF(BITMAPINFOHEADER)
      .biWidth = nWidth
      .biHeight = -nHeight ' Top-down DIB
      .biPlanes = 1
      .biBitCount = 32
      .biCompression = BI_RGB
      .biSizeImage = stride * nHeight
      .biXPelsPerMeter = 39.3701 * graphics.GetDpiX
      .biYPelsPerMeter = 39.3701 * graphics.GetDpiY
   END WITH

   ' // Create bitmap from DIB
   DIM bmp AS CGpBitmap = CGpBitmap(@bmi, @buffer(0))

   ' // Draw the modified bitmap.
   graphics.DrawImage(@bmp, 10, 10)

END SUB
' ========================================================================================

' ========================================================================================
' Main
' ========================================================================================
FUNCTION main (BYVAL nCmdShow AS LONG = SW_SHOW) AS LONG

   ' // Set process DPI aware
   SetProcessDpiAwareness(PROCESS_SYSTEM_DPI_AWARE)
   ' // Enable visual styles without including a manifest file
   EnableVisualStyles

   ' // Create the main window
   DIM pWindow AS CWindow = "MyClassName"
   pWindow.Create(NULL, "GDI+ BitmapCreateFromGdiDib", @WndProc)
   ' // Size it by setting the wanted width and height of its client area
   pWindow.SetClientSize(390, 250)
   ' // Center the window
   pWindow.Center

   ' // Add a graphic control
   DIM pGraphCtx AS CGraphCtx = CGraphCtx(@pWindow, IDC_GRCTX, "", 0, 0, pWindow.ClientWidth, pWindow.ClientHeight)
   pGraphCtx.Clear RGB_WHITE
   ' // Anchor the control
   pWindow.AnchorControl(pGraphCtx.hWindow, ANCHOR_HEIGHT_WIDTH)

   ' // Get the memory device context of the graphic control
   DIM hdc AS HDC = pGraphCtx.GetMemDc
   ' // Draw the graphics
   Example_CreateFromGdiDib(hdc)

   ' // Displays the window and dispatches the Windows messages
   FUNCTION = pWindow.DoEvents(nCmdShow)

END FUNCTION
' ========================================================================================

' ========================================================================================
' Main window procedure
' ========================================================================================
FUNCTION WndProc (BYVAL hwnd AS HWND, BYVAL uMsg AS UINT, BYVAL wParam AS WPARAM, BYVAL lParam AS LPARAM) AS LRESULT

   SELECT CASE uMsg

      ' // If an application processes this message, it should return zero to continue
      ' // creation of the window. If the application returns –1, the window is destroyed
      ' // and the CreateWindowExW function returns a NULL handle.
      CASE WM_CREATE
         EnableDarkModeForWindow(hwnd)
         RETURN 0

      ' // Theme has changed
      CASE WM_THEMECHANGED
         EnableDarkModeForWindow(hwnd)
         RETURN 0

      CASE WM_COMMAND
         SELECT CASE CBCTL(wParam, lParam)
            CASE IDCANCEL
               ' // If ESC key pressed, close the application by sending an WM_CLOSE message
               IF CBCTLMSG(wParam, lParam) = BN_CLICKED THEN
                  SendMessageW hwnd, WM_CLOSE, 0, 0
                  RETURN 0
               END IF
         END SELECT

    	CASE WM_DESTROY
         ' // Ends the application by sending a WM_QUIT message
         PostQuitMessage(0)
         RETURN 0

   END SELECT

   ' // Default processing of Windows messages
   FUNCTION = DefWindowProcW(hwnd, uMsg, wParam, lParam)

END FUNCTION
' ========================================================================================

' ========================================================================================
' // Call main() and return the error code to the OS
' ========================================================================================
END main()
' ========================================================================================
