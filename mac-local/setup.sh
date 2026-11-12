#!/bin/sh
# Monta o port do Wind Waker HD (este fork, release v0.5.1) a partir do SEU jogo.
# Uso: GAME_ZIP=<zip com a pasta extraída do jogo (code/content/meta)> DEST=<pasta no SSD> mac-local/setup.sh
# O jogo precisa ser o Wii U EUA (00050000-10143500) ou Europa (00050000-10143600), versão 0.
set -eu
: "${GAME_ZIP:?defina GAME_ZIP}"
DEST="${DEST:-$HOME/zeldaww}"
VER="${VER:-v0.5.1}"
SHA="${SHA:-3e5d7b8715ee7263c641f5eaa7ccd400299601d6c6ae1a0ff01578e4130d92f6}"   # WindWakerHD-v0.5.1-macos-arm64.zip
ZIP="WindWakerHD-$VER-macos-arm64.zip"
mkdir -p "$DEST" && cd "$DEST"
if [ ! -d game ]; then
  unzip -q "$GAME_ZIP" -x "__MACOSX/*" "*/._*" -d unpack
  mv unpack/*/ game && rmdir unpack
fi
[ -f "$ZIP" ] || curl -fsSL -o "$ZIP" "https://github.com/ZeldaWWHDRecomp/ZeldaWWHDRecomp/releases/download/$VER/$ZIP"
echo "$SHA  $ZIP" | shasum -a 256 -c -
[ -d "WindWakerHD-$VER-macos-arm64" ] || unzip -q "$ZIP" -d .
cd "WindWakerHD-$VER-macos-arm64"
python3 tools/installer/setup.py --game-dir "$DEST/game" --yes --no-launch --no-shortcuts --code-mods 0
echo "Pronto: $DEST/WindWakerHD-$VER-macos-arm64/Wind Waker HD.app (não tire o app de dentro dessa pasta)"
