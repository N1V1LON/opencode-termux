# opencode-termux-native

> **OpenCode работает нативно в Termux — без proot, без эмуляции.**

Это решение найдено методом проб и ошибок за ~1.5 часа. Суть: используем `glibc-runner` чтобы запустить Linux aarch64 бинарник opencode прямо в Termux.

---

## Скриншоты

> OpenCode работает нативно на Android в Termux — TUI, мышление, команды, всё.

*(добавь сюда свои скриншоты)*

---

## Быстрая установка (1 команда)

```bash
curl -fsSL https://raw.githubusercontent.com/ТВОЙ_НИК/opencode-termux-native/main/install.sh | bash
```

После установки просто запускай:

```bash
opencode
```

---

## Ручная установка (4 шага)

### 1. Установить glibc-runner

```bash
pkg install glibc-repo && pkg update && pkg install glibc-runner
```

### 2. Скачать бинарник opencode для arm64

```bash
curl -LO https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-arm64.tar.gz
```

### 3. Распаковать

```bash
mkdir -p ~/opencode-arm64
tar -xzf opencode-linux-arm64.tar.gz -C ~/opencode-arm64
```

### 4. Добавить алиас

Для **zsh** (по умолчанию в Termux):
```bash
echo 'alias opencode="glibc-runner ~/opencode-arm64/opencode"' >> ~/.zshrc
exec zsh
```

Для **bash**:
```bash
echo 'alias opencode="glibc-runner ~/opencode-arm64/opencode"' >> ~/.bashrc
source ~/.bashrc
```

### Запуск

```bash
opencode
```

---

## Как это работает

Официальный бинарник opencode для `linux-arm64` собран под glibc, которой нет в Termux (там Android Bionic libc). `glibc-runner` из Termux репозитория предоставляет нужный слой совместимости, и бинарник запускается без проблем.

---

## Требования

- Android 7+ (aarch64)
- Termux (из F-Droid или GitHub, **не** Google Play)
- ~150MB свободного места
- Интернет для скачивания (~50MB)

---

## Известные проблемы

- При первом запуске выполняется `Database migration` — это нормально, займёт несколько секунд
- Алиас `opencode` должен быть добавлен в `.zshrc` или `.bashrc` иначе при новой сессии придётся запускать через `glibc-runner ~/opencode-arm64/opencode`

---

## Связанные проекты

- [anomalyco/opencode](https://github.com/anomalyco/opencode) — официальный репо
- [guysoft/opencode-termux](https://github.com/guysoft/opencode-termux) — кросс-компиляция нативного Android бинарника (другой подход, нет релизов)
- [Charlie6F/opencode_termux_alpine_aarch64](https://github.com/Charlie6F/opencode_termux_alpine_aarch64) — через proot Alpine

---

## Автор

Найдено и проверено на Xiaomi aarch64, Termux + zsh.
