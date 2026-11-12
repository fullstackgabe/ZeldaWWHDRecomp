#!/bin/sh
# Uma janela só (sem a janela do GamePad; Ctrl+G mostra) e tela cheia. Rodar com o jogo fechado.
# Uso: REL=<pasta do release> mac-local/config.sh
set -eu
REL="${REL:-$HOME/zeldaww/WindWakerHD-v0.5.1-macos-arm64}"
F="$REL/data/user/display.plist"
[ -f "$F" ] || { mkdir -p "$(dirname "$F")"; plutil -create xml1 "$F"; }
cp "$F" "$F.bak"
plutil -replace drcMode -string off "$F"
plutil -replace tvFullScreen -bool YES "$F"
plutil -p "$F"
