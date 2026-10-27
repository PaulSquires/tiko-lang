#!/usr/bin/env python3
"""
Draws tkEdit's program icon: a lower-case "te" on a rounded dark square, in the style of
tiko-editor's "tk" (src/eda/res/app.ico there) -- its slate background, its light-blue letters,
its 1/256 inset and corner radius. The letters are Inter (fonts/Inter-Regular.ttf, OFL),
thickened to tk's stroke weight.

    python tools/make-icon.py        # needs Pillow

Writes src/app/res/tkedit.ico (16-256 px; the .exe's icon through src/app/res/tkEdit.rc) and
icons/tkedit.png (256 px; the window icon, set at run time on every platform).
"""
import os
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONT = os.path.join(ROOT, "fonts", "Inter-Regular.ttf")
ICO = os.path.join(ROOT, "src", "app", "res", "tkedit.ico")
PNG = os.path.join(ROOT, "icons", "tkedit.png")

BG = (0x28, 0x2C, 0x34, 255)      # tk's background
FG = (0x94, 0xCA, 0xF0, 255)      # tk's letters
TEXT = "te"
N = 1024                          # drawn at 4x 256, then reduced
INSET = N * 1 // 256
RADIUS = N * 30 // 256
INK_H = N * 108 // 256            # the "t" top to the "e" bottom
STROKE = N * 2 // 256             # Inter Regular is lighter than tk's face
TRACK = N * 12 // 256             # tk's letters stand further apart than Inter sets them


def master():
    im = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rounded_rectangle((INSET, INSET, N - 1 - INSET, N - 1 - INSET), RADIUS, fill=BG)
    # size the face so the ink is INK_H tall, then centre the ink box (not the advance box)
    size = INK_H
    for _ in range(4):
        f = ImageFont.truetype(FONT, size)
        l, t, r, b = d.textbbox((0, 0), TEXT, font=f, stroke_width=STROKE)
        size = int(size * INK_H / (b - t))
    f = ImageFont.truetype(FONT, size)
    # each letter at its own advance plus TRACK; the ink box of the pair is centred
    pen, boxes = 0, []
    for ch in TEXT:
        boxes.append((pen, d.textbbox((pen, 0), ch, font=f, stroke_width=STROKE)))
        pen += f.getlength(ch) + TRACK
    l = min(bb[0] for _, bb in boxes); r = max(bb[2] for _, bb in boxes)
    t = min(bb[1] for _, bb in boxes); b = max(bb[3] for _, bb in boxes)
    x = (N - (r - l)) / 2 - l
    y = (N - (b - t)) / 2 - t
    for (px, _), ch in zip(boxes, TEXT):
        d.text((x + px, y), ch, font=f, fill=FG, stroke_width=STROKE, stroke_fill=FG)
    return im


def main():
    big = master()
    os.makedirs(os.path.dirname(ICO), exist_ok=True)
    os.makedirs(os.path.dirname(PNG), exist_ok=True)
    i256 = big.resize((256, 256), Image.LANCZOS)
    i256.save(PNG)
    sizes = [16, 24, 32, 48, 64, 128, 256]
    i256.save(ICO, format="ICO", sizes=[(s, s) for s in sizes],
              append_images=[big.resize((s, s), Image.LANCZOS) for s in sizes])
    print("wrote", os.path.relpath(ICO, ROOT), os.path.getsize(ICO), "bytes;",
          os.path.relpath(PNG, ROOT), os.path.getsize(PNG), "bytes")


if __name__ == "__main__":
    main()
