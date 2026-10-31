' ########################################################################################
' Microsoft Windows
' Contents: GDI+ - PathGradientBrushSetSurroundColors example
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
' The following example creates a PathGradientBrush object based on an array of three points
' that defines a triangular path. The code also initializes an array of three Color objects.
' The call to the PathGradientBrush::SetSurroundColors method associates each color in the
' color array with the corresponding (same index) point in the point array. After the surround
' colors of the path gradient brush have been set, the Graphics.FillRectangle method uses
' the path gradient brush to paint a rectangle that includes the triangular path.
' One edge of the rendered triangle changes gradually from red to green. The next edge
' changes gradually from green to black, and the third edge changes gradually from black
' to red. The code does not set the center color, so the center color has the default value
' of black. As you move along a straight line from any point on the boundary path (triangle)
' to the center point, the color changes gradually from that boundary point's color to black.
' ========================================================================================
SUB Example_SetSurroundColors (BYVAL hdc AS HDC)

   ' // Create a graphics object from the window device context
   DIM graphics AS CGpGraphics = hdc
   ' // Set the scale transform
   graphics.ScaleTransformForDpi

   DIM points(0 TO 2) AS GpPoint = {(20, 20), (100, 20), (100, 100)}
   DIM pthGrBrush AS CGpPathGradientBrush = CGpPathGradientBrush(@points(0), 3)

   DIM nCount AS LONG = 3
   DIM colors(0 TO 2) AS ARGB = {ARGB_RED, ARGB_BLUE, ARGB_AQUA}
   pthGrBrush.SetSurroundColors(@colors(0), @nCount)

   graphics.FillRectangle(@pthGrBrush, 0, 0, 200, 200)

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
   pWindow.Create(NULL, "GDI+ PathGradientBrushSetSurroundColors", @WndProc)
   ' // Size it by setting the wanted width and height of its client area
   pWindow.SetClientSize(400, 250)
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
   Example_SetSurroundColors(hdc)

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
