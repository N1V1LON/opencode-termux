# @n1v1lon/opencode-android

![NPM Version](https://img.shields.io/badge/npm-v1.0.3-blue?style=flat-square&logo=npm)
![License](https://img.shields.io/badge/license-GPL--3.0-green?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Android%20|%20Termux-orange?style=flat-square&logo=android)
![Arch](https://img.shields.io/badge/arch-aarch64-red?style=flat-square)

> **OpenCode работает нативно в Termux — без proot, без эмуляции и лишних потерь производительности.**

Самый быстрый и легкий способ запустить OpenCode на Android. Мы используем `glibc-runner` для прямого запуска официального Linux-бинарника в среде Termux.

---

## 📸 Скриншоты
<details>
<summary>Нажми, чтобы развернуть скриншоты работы</summary>

| | |
|---|---|
| ![Screen 1](Screenshot_2026-04-27-12-32-31-004_com.termux.jpg) | ![Screen 2](Screenshot_2026-04-27-12-32-45-070_com.termux.jpg) |
| ![Screen 3](Screenshot_2026-04-27-12-33-23-590_com.termux.jpg) | ![Screen 4](Screenshot_2026-04-27-12-33-55-784_com.termux.jpg) |

</details>

---

## 🚀 Установка

### 1. Через NPM (Рекомендуется)
```bash
npm config set @n1v1lon:registry=https://npm.pkg.github.com/
npm install -g @n1v1lon/opencode-android

2. Быстрый скрипт (One-liner)

curl -fsSL https://raw.githubusercontent.com/N1V1LON/opencode-termux/main/install.sh | bash

3. Ручная установка (Для профи)

1.  Подготовка glibc:
    pkg install glibc-repo -y && pkg update -y && pkg install glibc-runner -y
2.  Загрузка бинарника:
    curl -L -o opencode.tar.gz https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-arm64.tar.gz
3.  Распаковка:
    mkdir -p ~/opencode-arm64 && tar -xzf opencode.tar.gz -C ~/opencode-arm64
    chmod +x ~/opencode-arm64/opencode
4.  Алиас:
    echo 'alias opencode="glibc-runner ~/opencode-arm64/opencode"' >> ~/.bashrc

🛠 Запуск

После установки введите:

opencode

(Если команда не найдена, перезапустите терминал командой exec bash или exec
zsh)

🔍 Как это работает?

В отличие от методов через proot (Alpine/Ubuntu), этот проект запускает бинарник
напрямую. glibc-runner обеспечивает слой совместимости между glibc и Android
Bionic libc. Результат: минимальное потребление ОЗУ и нативная скорость CPU.

📋 Требования

  - ОС: Android 7.0+
  - Архитектура: aarch64 (ARM64)
  - Приложение: Termux (F-Droid / GitHub)
  - Место: ~150 MB

🤝 Ссылки

  - OpenCode Official — Исходный проект.
  - GitHub N1V1LON — Автор портации.

Автор: @N1V1LON

