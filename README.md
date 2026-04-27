Понял — тебе нужно, чтобы весь README был оформлен так, чтобы можно было легко скопировать, без сломанных блоков и с нормальными Markdown‑кодблоками.

Вот идеально выровненная версия, полностью готовая для GitHub.  
Все блоки — корректные, копируются без проблем.

---

@n1v1lon/opencode-android

https://img.shields.io/badge/npm-v1.0.3-blue?style=flat-square&logo=npm
https://img.shields.io/badge/license-GPL--3.0-green?style=flat-square
https://img.shields.io/badge/platform-Android%20%7C%20Termux-orange?style=flat-square&logo=android
https://img.shields.io/badge/arch-aarch64-red?style=flat-square

> OpenCode работает нативно в Termux — без proot, без эмуляции и без потерь производительности.

Самый быстрый и лёгкий способ запустить OpenCode на Android.  
Используется glibc-runner для прямого запуска официального Linux‑бинарника.

---

📸 Скриншоты

<details>
<summary><strong>Нажми, чтобы развернуть</strong></summary>

| Скрин 1 | Скрин 2 |
|--------|---------|
| [Похоже, результат оказался небезопасным для отображения. Давайте внесем изменения и попробуем что-нибудь другое!] | [Похоже, результат оказался небезопасным для отображения. Давайте внесем изменения и попробуем что-нибудь другое!] |

| Скрин 3 | Скрин 4 |
|--------|---------|
| [Похоже, результат оказался небезопасным для отображения. Давайте внесем изменения и попробуем что-нибудь другое!] | [Похоже, результат оказался небезопасным для отображения. Давайте внесем изменения и попробуем что-нибудь другое!] |

</details>

---

🚀 Установка

1. Через NPM (рекомендуется)

`bash
npm config set @n1v1lon:registry=https://npm.pkg.github.com/
npm install -g @n1v1lon/opencode-android
`

---

2. Быстрый скрипт (One‑liner)

`bash
curl -fsSL https://raw.githubusercontent.com/N1V1LON/opencode-termux/main/install.sh | bash
`

---

3. Ручная установка (для профи)

1. Установка glibc

`bash
pkg install glibc-repo -y
pkg update -y
pkg install glibc-runner -y
`

2. Загрузка бинарника

`bash
curl -L -o opencode.tar.gz https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-arm64.tar.gz
`

3. Распаковка

`bash
mkdir -p ~/opencode-arm64
tar -xzf opencode.tar.gz -C ~/opencode-arm64
chmod +x ~/opencode-arm64/opencode
`

4. Алиас

`bash
echo 'alias opencode="glibc-runner ~/opencode-arm64/opencode"' >> ~/.bashrc
`

---

🛠 Запуск

`bash
opencode
`

Если команда не найдена:

`bash
exec bash

или
exec zsh
`

---

🔍 Как это работает?

В отличие от proot‑окружений (Alpine/Ubuntu), проект запускает бинарник напрямую.  
glibc-runner создаёт слой совместимости между glibc и Android Bionic libc.

Преимущества:

- минимальное потребление ОЗУ  
- нативная скорость CPU  
- отсутствие эмуляции  
- стабильность и предсказуемость  

---

📋 Требования

- Android 7.0+
- Архитектура: aarch64 (ARM64)
- Termux (F‑Droid / GitHub)
- Свободное место: ~150 MB

---

🤝 Ссылки

- OpenCode Official — исходный проект  
- GitHub N1V1LON — автор портации  

---

Автор: @N1V1LON

---

Если хочешь — могу:

🔹 сделать красивый баннер  
🔹 добавить GIF‑демо  
🔹 оформить секцию FAQ  
🔹 сделать английскую версию README  

Скажи, что добавить.
