"""Cuts Noto Sans SC down to the characters tkEdit's Chinese interface uses: fonts/NotoSansSC-tkEdit.otf.

tkEdit's UI font (Inter) has no CJK glyphs, so mainwin hangs this font behind every UI role as an
SDL_ttf fallback. The whole of Noto Sans SC is ~8 MB; the interface needs only the characters
lang/zh.toml holds, so the subset is every character above U+007F in that file (Inter covers
ASCII). Run it again whenever lang/zh.toml changes -- tkEdit's self-test checks that the font
holds every character of the catalog, and fails if it does not.

    python tools/make-cjk-font.py <NotoSansSC-Regular.otf>

The source is notofonts/noto-cjk, tag Sans2.004, Sans/SubsetOTF/SC/NotoSansSC-Regular.otf
(SHA-256 faa6c9df652116dde789d351359f3d7e5d2285a2b2a1f04a2d7244df706d5ea9), SIL OFL 1.1
(fonts/OFL-NotoSansSC.txt). The subset is renamed (OFL: a modified version may not keep the
reserved name), so its family is "Noto Sans SC tkEdit". Needs fontTools (pip install fonttools).
"""
import os
import sys

from fontTools import subset
from fontTools.ttLib import TTFont

OUT_NAME = 'NotoSansSC-tkEdit.otf'
FAMILY = 'Noto Sans SC tkEdit'


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    here = os.path.dirname(os.path.abspath(__file__))
    tk = os.path.normpath(os.path.join(here, '..'))
    catalog = open(os.path.join(tk, 'lang', 'zh.toml'), encoding='utf-8').read()
    chars = sorted({ord(c) for c in catalog if ord(c) > 0x7F})
    src = TTFont(sys.argv[1])
    cmap = src.getBestCmap()
    missing = [c for c in chars if c not in cmap]
    if missing:
        sys.exit('not in the source font: ' + ' '.join('U+%04X' % c for c in missing))
    opts = subset.Options()
    opts.layout_features = ['*']
    opts.name_IDs = ['*']
    opts.notdef_outline = True
    sub = subset.Subsetter(opts)
    sub.populate(unicodes=chars)
    sub.subset(src)
    # a modified OFL font takes another name (Reserved Font Name "Noto")
    for rec in src['name'].names:
        if rec.nameID in (1, 4, 16):
            rec.string = FAMILY if rec.nameID != 4 else FAMILY + ' Regular'
        elif rec.nameID == 6:
            rec.string = FAMILY.replace(' ', '') + '-Regular'
    out = os.path.join(tk, 'fonts', OUT_NAME)
    src.save(out)
    print('%s: %d characters, %d bytes' % (os.path.normpath(out), len(chars), os.path.getsize(out)))


if __name__ == '__main__':
    main()
