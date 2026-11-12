#!/bin/sh
# Aplica um ícone a partir de uma imagem SUA (quadrada, png/jpg). Nenhuma imagem fica neste repositório.
# Uso: IMG=<imagem> REL=<pasta do release> GAME=<pasta game> mac-local/icone.sh   (precisa de python3 com Pillow)
set -eu
: "${IMG:?defina IMG}"
REL="${REL:-$HOME/zeldaww/WindWakerHD-v0.5.1-macos-arm64}"; GAME="${GAME:-$HOME/zeldaww/game}"
A="$REL/Wind Waker HD.app"; T="$(mktemp -d)"
python3 - "$IMG" "$T/icon.png" <<'PY'
import sys
from PIL import Image, ImageDraw, ImageFilter
N, BOX, OFF = 1024, 824, 100
art = Image.open(sys.argv[1]).convert('RGB')
s = min(art.size); art = art.crop(((art.width-s)//2, (art.height-s)//2, (art.width+s)//2, (art.height+s)//2)).resize((BOX, BOX), Image.LANCZOS)
S4 = BOX*4; r = S4/2; mask = Image.new('L', (S4, S4), 0); px = mask.load()
for y in range(S4):
    dy = abs((y+0.5-r)/r)**5
    if dy >= 1: continue
    w = int(r*(1-dy)**0.2)
    for x in range(int(r-w), int(r+w)): px[x, y] = 255
mask = mask.resize((BOX, BOX), Image.LANCZOS)
c = Image.new('RGBA', (N, N), (0, 0, 0, 0)); sh = Image.new('L', (N, N), 0); sh.paste(mask, (OFF, OFF+12))
sh = sh.filter(ImageFilter.GaussianBlur(18)).point(lambda v: int(v*0.35)); c.paste(Image.new('RGBA', (N, N), (0, 0, 0, 255)), (0, 0), sh)
b = art.convert('RGBA'); b.putalpha(mask); c.alpha_composite(b, (OFF, OFF)); c.save(sys.argv[2])
PY
mkdir "$T/i.iconset"
for s in 16 32 128 256 512; do sips -z $s $s "$T/icon.png" --out "$T/i.iconset/icon_${s}x${s}.png" >/dev/null; d=$((s*2)); sips -z $d $d "$T/icon.png" --out "$T/i.iconset/icon_${s}x${s}@2x.png" >/dev/null; done
mkdir -p "$A/Contents/Resources"; iconutil -c icns "$T/i.iconset" -o "$A/Contents/Resources/AppIcon.icns"
/usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string AppIcon" "$A/Contents/Info.plist" 2>/dev/null || true
codesign -f -s - "$A"
# ícone do jogo rodando: o executável usa game/meta/iconTex.tga (o original é guardado uma vez)
[ -f "$GAME/meta/iconTex.original.tga" ] || cp "$GAME/meta/iconTex.tga" "$GAME/meta/iconTex.original.tga"
python3 -c "import sys;from PIL import Image;Image.open(sys.argv[1]).convert('RGBA').resize((128,128),Image.LANCZOS).save(sys.argv[2],format='TGA')" "$T/icon.png" "$GAME/meta/iconTex.tga"
touch "$A"; killall Dock || true; rm -rf "$T"; echo "ícone aplicado"
