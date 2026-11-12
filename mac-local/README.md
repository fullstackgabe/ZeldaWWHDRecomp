# Wind Waker HD no Mac — receita local

Branch `ww-hd-mac` deste fork, a partir da **v0.5.1** do [ZeldaWWHDRecomp](https://github.com/ZeldaWWHDRecomp/ZeldaWWHDRecomp).
Só scripts e anotações: **nenhum arquivo do jogo, chave, save ou imagem** fica aqui. Tudo é montado a partir do seu próprio jogo.

## Requisitos
- Mac Apple Silicon, macOS 14+, Xcode Command Line Tools (`xcode-select --install`)
- Seu jogo Wii U já extraído (pastas `code/`, `content/`, `meta/`), EUA `00050000-10143500` ou Europa `00050000-10143600`, **versão 0**, num zip
- Para o ícone: `python3` com Pillow (`pip3 install pillow`)

## Passos
```sh
GAME_ZIP="/caminho/do/The Legend of Zelda - The Wind Waker HD.zip" DEST=~/zeldaww mac-local/setup.sh
mac-local/config.sh            # uma janela só (Ctrl+G mostra o GamePad) + tela cheia
IMG=/caminho/da/sua/imagem.png mac-local/icone.sh   # opcional
```
- `setup.sh` baixa o release `WindWakerHD-v0.5.1-macos-arm64.zip`, confere o SHA-256 e roda o setup do projeto
  (`tools/installer/setup.py --game-dir`): ~2-3 min, compila o código e prepara os shaders (Metal e Vulkan).
- A pasta `game/` é usada no lugar: tem que ficar no SSD. O app fica **dentro** da pasta do release (precisa de `tools/` e `sdk/` ao lado).
- `config.sh` grava em `data/user/display.plist`: `drcMode = off`, `tvFullScreen = true` (faz backup `.bak`).
- `icone.sh` põe o ícone no app (reassina ad-hoc) e troca `game/meta/iconTex.tga`, que o executável usa como ícone enquanto o jogo roda
  (o original fica em `iconTex.original.tga`).

## Saves
Ficam em `data/save` dentro da pasta do release. Release novo: descompactar ao lado, rodar o setup com o mesmo `game/`
e copiar `data/save` e `data/user`.
