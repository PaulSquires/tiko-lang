[Home](Home) › [Tutorials](Category-Tutorials) › **OpenGL, The Open Graphics Language**

# OpenGL, The Open Graphics Language

OpenGL is a standardized and widely used cross-platform 3D graphics library.

 Usually OpenGL support comes as part of the system and the graphics drivers. There are many different projects providing a library that implements the main OpenGL API, and which one is used depends on the platform and system setup. For example, on Windows, the client API is implemented in Microsoft's opengl32.dll, while on Linux, there is for example the free Mesa3D project, which provides a libGL implementation. It depends on the used library or system setup which way the OpenGL API does its rendering, typically it uses OpenGL hardware drivers and is hardware-accelerated, but there also is software-rendered OpenGL (e.g. standalone Mesa3D). The system's graphics hardware drivers may provide additional OpenGL extensions, access to which is again system dependant.

 Besides plain OpenGL, there are several utility, helper and wrapper libraries, such as [GLUT](Glut-the-Opengl-Utility-Toolkit), [freeglut](Free-Alternative-to-the-Opengl-Utility-Toolkit) and [GLFW](Glfw-an-Opengl-Library), and even FreeBASIC's built-in graphics library has an OpenGL mode, see [Screen (Graphics) And Fb.Gfx_Opengl](Screen-Graphics).

 Websites:  
 OpenGL standard: http://www.opengl.org  
 Mesa3D: http://mesa3d.org/  
 Windows OpenGL: http://msdn.microsoft.com/en-us/library/dd374278.aspx

 Platforms supported: Win32, Linux  
 Headers to include: GL/gl.bi  
 Header version: Mesa-3D 10.5.1, MinGW-w64 3.3.0  
 Examples: yes, in examples/graphics/OpenGL/

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
