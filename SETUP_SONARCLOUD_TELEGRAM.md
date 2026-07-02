# Setup: SonarCloud + GitHub Actions + Telegram

Guía paso a paso para configurar análisis automático de código con **SonarCloud**, GitHub Actions y notificaciones en Telegram.

> **Ventaja:** ¡Sin necesidad de servidor local! Todo ocurre en GitHub Actions.

---

## 📋 Pasos

### 1️⃣ Conectar SonarCloud con GitHub

1. Ve a: https://sonarcloud.io
2. Haz clic en **Sign up** (si no tienes cuenta)
3. Selecciona **Sign up with GitHub**
4. Autoriza SonarCloud para acceder a tu GitHub
5. Selecciona tu organización GitHub: `WilmerBuestan`
6. Haz clic en **Import an organization**

---

### 2️⃣ Crear Organización en SonarCloud

1. En SonarCloud, ve a **My Account** → **Organizations**
2. Haz clic en **Create an organization**
3. Organization key: `wilmerbuestan-org`
4. Organization name: `Wilmer Buestan`
5. Haz clic en **Create**

---

### 3️⃣ Crear Proyecto en SonarCloud

1. En SonarCloud, haz clic en **+** → **Analyze new project**
2. Selecciona tu repositorio: `WilmerBuestan/Reservas_seguras`
3. Haz clic en **Import project**
4. Selecciona **GitHub Actions**
5. Sigue las instrucciones (solo confirma)

---

### 4️⃣ Generar Token en SonarCloud

1. En SonarCloud, ve a **My Account** → **Security** → **Tokens**
2. Haz clic en **Generate Tokens**
3. Name: `github-actions`
4. Type: `Project Analysis`
5. Haz clic en **Generate**
6. **Copia el token** (algo como: `squ_abc123def456...`)

---

### 5️⃣ Crear Bot de Telegram

1. Abre Telegram
2. Busca: **@BotFather**
3. Envía: `/newbot`
4. Name: `EquipoDevNotifierBot` (o tu nombre)
5. BotFather dará un token: `1234567890:ABCDefGhIjKlMnOpQrStUvWxYz1234567890`
6. **Cópialo y guárdalo**

---

### 6️⃣ Crear Grupo de Telegram

1. En Telegram: **New Group**
2. Name: `ReservasEC Dev`
3. Agrega miembros
4. **Create**
5. Busca tu bot (`@EquipoDevNotifierBot`) e **invítalo al grupo**

---

### 7️⃣ Obtener Chat ID de Telegram

En tu navegador, ve a:

```
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates
```

Reemplaza `<TELEGRAM_BOT_TOKEN>` con tu token de BotFather.

En el JSON, busca:
```json
"chat": {
  "id": -1001234567890
}
```

**Copia el ID** (número negativo)

---

### 8️⃣ Agregar Secrets en GitHub

1. Ve a: https://github.com/WilmerBuestan/Reservas_seguras
2. **Settings** → **Secrets and variables** → **Actions**
3. **New repository secret** (2 veces):

#### Secret 1:
- **Name:** `SONARCLOUD_TOKEN`
- **Value:** `<el_token_que_copiaste_en_paso_4>`
- **Add secret**

#### Secret 2:
- **Name:** `TELEGRAM_BOT_TOKEN`
- **Value:** `<el_token_que_copiaste_en_paso_5>`
- **Add secret**

#### Secret 3:
- **Name:** `TELEGRAM_CHAT_ID`
- **Value:** `<el_chat_id_que_copiaste_en_paso_7>`
- **Add secret**

---

### 9️⃣ Hacer Push y Verificar

```bash
git add .
git commit -m "ci: Configure SonarCloud and Telegram notifications"
git push origin main
```

---

### ✅ Verificar que TODO funciona

#### En GitHub Actions:
- Ve a: https://github.com/WilmerBuestan/Reservas_seguras/actions
- Deberías ver 2 workflows:
  - ✅ `SonarCloud Analysis`
  - ✅ `Telegram Notification`

#### En SonarCloud:
- Ve a: https://sonarcloud.io/organizations/wilmerbuestan-org
- **Projects** → Deberías ver `Reservas_seguras` con un análisis reciente

#### En Telegram:
- En tu grupo, deberías recibir un mensaje con:
  - 👤 Autor
  - 🌿 Rama
  - 📝 Mensaje del commit
  - 🔗 Link a GitHub
  - 📋 Archivos modificados

---

## 📊 Ver Resultados

- **SonarCloud Dashboard:** https://sonarcloud.io/dashboard?id=WilmerBuestan_Reservas_seguras
- **GitHub Actions:** https://github.com/WilmerBuestan/Reservas_seguras/actions
- **Telegram:** Tu grupo de equipo

---

## 🔄 Flujo Automático

```
git push origin main
    ↓
GitHub Actions dispara automáticamente:
    ├→ SonarCloud Analysis (escanea código)
    │  ├→ Verifica Quality Gate
    │  └→ Genera reporte en https://sonarcloud.io/
    └→ Telegram Notification (envía mensaje al grupo)
```

---

## 🐛 Troubleshooting

### ¿Los workflows no ejecutan?

1. Verifica que los **secrets** estén configurados:
   - https://github.com/WilmerBuestan/Reservas_seguras/settings/secrets/actions

2. Mira los logs en:
   - https://github.com/WilmerBuestan/Reservas_seguras/actions

### ¿Telegram no recibe mensajes?

1. Verifica que el bot esté en el grupo
2. Verifica que `TELEGRAM_CHAT_ID` es correcto (negativo)
3. Prueba manualmente:
```bash
curl https://api.telegram.org/bot<TOKEN>/sendMessage \
  -d "chat_id=<ID>&text=Test"
```

### ¿SonarCloud no aparece en GitHub?

1. Asegúrate de estar logueado en SonarCloud con tu cuenta GitHub
2. Ve a https://sonarcloud.io/apps/github y autoriza acceso

---

## ✨ Próximos pasos

1. ✅ Configura los 9 pasos arriba
2. 📤 Haz un push para probar
3. 📊 Verifica que SonarCloud analiza en https://sonarcloud.io/
4. 📱 Recibe notificación en Telegram
5. 🔄 **Desde ahora, cada push es automático**

¡Listo! 🎉

---

## 📚 Recursos

- [SonarCloud Docs](https://docs.sonarcloud.io/)
- [GitHub Actions - SonarCloud](https://github.com/SonarSource/sonarcloud-github-action)
- [Telegram Bot API](https://core.telegram.org/bots/api)
