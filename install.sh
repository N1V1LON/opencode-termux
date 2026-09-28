#!/bin/bash
# opencode-termux-native installer
# https://github.com/ТВОЙ_НИК/opencode-termux-native

set -e

echo ""
echo "▄ █▀▀█ █▀▀█ █▀▀█ █▀▀▄ █▀▀▀ █▀▀█ █▀▀█ █▀▀█"
echo "█░░█ █░░█ █▀▀▀ █░░█ █░░░ █░░█ █░░█ █▀▀▀"
echo "▀▀▀▀ █▀▀▀ ▀▀▀▀ ▀ ▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀"
echo ""
echo "[1/4] Устанавливаем glibc-runner..."
pkg install glibc-repo -y 2>/dev/null || true
pkg update -y 2>/dev/null || true
pkg install glibc-runner -y

echo "[2/4] Скачиваем opencode linux-arm64..."
cd ~
curl -L --progress-bar -o opencode-linux-arm64.tar.gz \
  https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-arm64.tar.gz

echo "[3/4] Распаковываем..."
mkdir -p ~/opencode-arm64
tar -xzf opencode-linux-arm64.tar.gz -C ~/opencode-arm64
rm opencode-linux-arm64.tar.gz
chmod +x ~/opencode-arm64/opencode

echo "[4/4] Добавляем алиас..."
ALIAS_LINE='alias opencode="glibc-runner ~/opencode-arm64/opencode"'

for rc in .zshrc .bashrc; do
  target="$HOME/$rc"
  if [ -f "$target" ]; then
    if ! grep -q 'opencode-arm64' "$target"; then
      echo "$ALIAS_LINE" >> "$target"
      echo "  → добавлено в ~/$rc"
    else
      echo "  → алиас уже есть в ~/$rc"
    fi
  fi
done

echo ""
echo "✓ Готово! Перезапусти оболочку и запускай:"
echo ""
echo "  exec zsh   # или exec bash"
echo "  opencode"
echo ""
