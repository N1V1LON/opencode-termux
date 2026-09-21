#!/bin/bash
# opencode-termux-native installer
# https://github.com/N1V1LON/opencode-termux

set -e

echo ""
echo "▄ █▀▀█ █▀▀█ █▀▀█ █▀▀▄ █▀▀▀ █▀▀█ █▀▀█ █▀▀█"
echo "█░░█ █░░█ █▀▀▀ █░░█ █░░░ █░░█ █░░█ █▀▀▀"
echo "▀▀▀▀ █▀▀▀ ▀▀▀▀ ▀ ▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀"
echo ""
echo "[1/5] Устанавливаем зависимости..."
pkg update -y
pkg install glibc-repo -y
pkg update -y
pkg install curl wget glibc-runner -y

echo "[2/5] Скачиваем opencode linux-arm64..."
curl -L --progress-bar -o ~/opencode.tar.gz \
  https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-arm64.tar.gz

echo "[3/5] Распаковываем..."
mkdir -p ~/opencode-arm64
tar -xzf ~/opencode.tar.gz -C ~/opencode-arm64
rm -f ~/opencode.tar.gz
chmod +x ~/opencode-arm64/opencode

echo "[4/5] Создаем wrapper-скрипт..."
mkdir -p ~/.local/bin
cat > ~/.local/bin/opencode << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
exec glibc-runner ~/opencode-arm64/opencode "$@"
EOF
chmod +x ~/.local/bin/opencode

echo "[5/5] Добавляем в PATH..."
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

# bash
if [ -f ~/.bashrc ]; then
  if ! grep -q '\.local/bin' ~/.bashrc; then
    echo "$PATH_LINE" >> ~/.bashrc
    echo "  → добавлено в ~/.bashrc"
  else
    echo "  → PATH уже настроен в ~/.bashrc"
  fi
else
  echo "$PATH_LINE" >> ~/.bashrc
  echo "  → создан ~/.bashrc и добавлен PATH"
fi

# zsh
if [ -f ~/.zshrc ]; then
  if ! grep -q '\.local/bin' ~/.zshrc; then
    echo "$PATH_LINE" >> ~/.zshrc
    echo "  → добавлено в ~/.zshrc"
  else
    echo "  → PATH уже настроен в ~/.zshrc"
  fi
fi

echo ""
echo "✓ Готово! Перезапусти оболочку и запускай:"
echo ""
echo "  exec zsh   # или exec bash"
echo "  opencode --version"
echo ""
