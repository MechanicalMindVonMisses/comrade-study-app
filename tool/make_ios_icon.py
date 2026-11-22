"""Redraws the launcher icon (an open book on a red stand) at 1024 px and
writes every size the iOS AppIcon set asks for. iOS masks the corners itself,
so the art is full-bleed and opaque. Geometry is on the 192 px grid of the
Android icon."""
import json
from pathlib import Path
from PIL import Image, ImageDraw

BG = (18, 15, 12)
RED = (215, 86, 50)
LEFT_PAGE = (245, 237, 219)
RIGHT_PAGE = (236, 225, 204)
# Pages slope down toward the spine; the right page mirrors the left.
LEFT = [(34, 57), (94, 64), (94, 142), (34, 135)]
RIGHT = [(192 - x, y) for x, y in LEFT]
SPINE = (95, 64, 97, 154)
BASE = (56, 154, 136, 158)


def draw(size=1024, ss=4):
    n = size * ss
    s = n / 192
    im = Image.new('RGB', (n, n), BG)
    d = ImageDraw.Draw(im)
    d.polygon([(x * s, y * s) for x, y in LEFT], fill=LEFT_PAGE)
    d.polygon([(x * s, y * s) for x, y in RIGHT], fill=RIGHT_PAGE)
    for x0, y0, x1, y1 in (SPINE, BASE):
        d.rectangle([x0 * s, y0 * s, x1 * s - 1, y1 * s - 1], fill=RED)
    return im.resize((size, size), Image.LANCZOS)


root = Path(__file__).resolve().parent.parent
iconset = root / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
master = draw()
for img in json.loads((iconset / 'Contents.json').read_text())['images']:
    px = round(float(img['size'].split('x')[0]) * int(img['scale'][0]))
    master.resize((px, px), Image.LANCZOS).save(iconset / img['filename'])
print('wrote icons to', iconset)
