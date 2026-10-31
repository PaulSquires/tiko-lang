' ########################################################################################
' Microsoft Windows
' Contents: GDI+ - ImageAttributesSetThreshold example
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
' The following example creates an Image object based on a .bmp file. The code also creates
' an ImageAttributes object and sets its bitmap threshold value to 0.6. Then the code draws
' the image twice: once with no color adjustment and once with the adjustment specified by
' the threshold.
' ========================================================================================
SUB Example_SetThreshold (BYVAL hdc AS HDC)

   ' // Create a graphics object from the window device context
   DIM graphics AS CGpGraphics = hdc
   ' // Set the scaling factors using the DPI ratios
   graphics.ScaleTransformForDpi

   ' // Create an Image object based on a .bmp file.
   ' // The image has one stripe with RGB components (160, 0, 0)
   ' // and one stripe with RGB components (0, 140, 0).
   DIM image AS CGpBitmap = "RedGreenThreshold.bmp"
   image.SetResolutionForDpi

   ' // Create an ImageAttributes object, and set its bitmap threshold to 0.6.
   DIM imgAttr AS CGpImageAttributes
   imgAttr.SetThreshold(0.6)

   ' // Get the width and height of the image
   DIM nWidth AS UINT = image.GetWidth
   DIM nHeight AS UINT = image.GetHeight

   ' // Draw the image with no color adjustment.
   graphics.DrawImage(@image, 10, 10, nWidth, nHeight)

   ' // Draw the image with the threshold applied.
   ' // 160 > 0.6 * 255, so the red stripe will be changed to full intensity.
   ' // 140 < 0.6 * 255, so the green stripe will be changed to zero intensity.
   DIM rc AS GpRect = (100, 10, nWidth, nHeight)
   graphics.DrawImage(@image, @rc, 0, 0, nWidth, nHeight, UnitPixel, @imgAttr)

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
   pWindow.Create(NULL, "GDI+ ImageAttributesSetThreshold", @WndProc)
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
   Example_SetThreshold(hdc)

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
'  Call main() and return the error code to the OS
' ========================================================================================
END main()
' ========================================================================================
