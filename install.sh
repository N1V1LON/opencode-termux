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
VERSION="v1.18.33"
EXPECTED_SHA256="c63486624621924bf43be5c01abd252885661a734814224f6d70188a33aea858"

cd ~
curl -L --progress-bar -o opencode-linux-arm64.tar.gz \
  "https://github.com/anomalyco/opencode/releases/download/${VERSION}/opencode-linux-arm64.tar.gz"

echo "Проверяем целостность файла (SHA256)..."
ACTUAL_SHA256=$(sha256sum opencode-linux-arm64.tar.gz | awk '{print $1}')

if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
  echo "❌ Ошибка: Контрольная сумма SHA256 не совпадает!"
  echo "Ожидалось: $EXPECTED_SHA256"
  echo "Получено:   $ACTUAL_SHA256"
  rm -f opencode-linux-arm64.tar.gz
  exit 1
fi
echo "  → Контрольная сумма подтверждена"

echo "[3/4] Распаковываем..."
mkdir -p ~/opencode-arm64
tar -xzf opencode-linux-arm64.tar.gz -C ~/opencode-arm64
rm opencode-linux-arm64.tar.gz
chmod +x ~/opencode-arm64/opencode

echo "[4/4] Добавляем алиас..."
ALIAS_LINE='alias opencode="glibc-runner ~/opencode-arm64/opencode"'

# zsh
if [ -f ~/.zshrc ]; then
  if ! grep -q 'opencode-arm64' ~/.zshrc; then
    echo "$ALIAS_LINE" >> ~/.zshrc
    echo "  → добавлено в ~/.zshrc"
  else
    echo "  → алиас уже есть в ~/.zshrc"
  fi
fi

# bash
if [ -f ~/.bashrc ]; then
  if ! grep -q 'opencode-arm64' ~/.bashrc; then
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo "  → добавлено в ~/.bashrc"
  fi
fi

echo ""
echo "✓ Готово! Перезапусти оболочку и запускай:"
echo ""
echo "  exec zsh   # или exec bash"
echo "  opencode"
echo ""
