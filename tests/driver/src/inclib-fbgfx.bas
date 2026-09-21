'' '#inclib "fbgfx?"' IS fbgfx.bi's REQUEST FOR THE GRAPHICS LIBRARY, not a library
'' name: fbc turns it into its -fbgfx option and never passes it to the linker. tiko
'' passed it on, lld-link answered "could not open 'fbgfx?.lib'", and every program
'' that included fbgfx.bi failed to link. Written out here rather than by including
'' fbgfx.bi, so the test does not depend on the toolchain's headers. fbc-modern builds
'' the same program and prints FF00FF00.
#inclib "fbgfx?"
screenres 64, 48, 32, , -1
line (0, 0)-(10, 10), &hFF00FF00, bf
dim as ulong c = point( 5, 5 )
screen 0
print hex( c )
