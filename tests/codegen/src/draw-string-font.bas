' DRAW STRING with a custom FONT, its default method and a written one.
screenres 64, 32, 32
dim as any ptr f = imagecreate(8 * 96, 9, rgb(255, 0, 0))
draw string (0, 0), "AB", , f
draw string (0, 10), "AB", , f, pset
draw string (0, 20), "AB", rgb(0, 255, 0)
print "ok"
imagedestroy f
