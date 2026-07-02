# Setup: SonarQube + GitHub Actions + Telegram

Guía paso a paso para configurar análisis automático de código con SonarQube, GitHub Actions y notificaciones en Telegram.

---

## 📋 Índice

1. [Levantar SonarQube en Docker](#-levantar-sonarqube-en-docker)
2. [Crear Quality Gate "StrictGate"](#-crear-quality-gate-strictgate)
3. [Configurar Token de SonarQube](#-configurar-token-de-sonarqube)
4. [Crear Bot de Telegram](#-crear-bot-de-telegram)
5. [Configurar Secrets en GitHub](#-configurar-secrets-en-github)
6. [Hacer Push y Verificar](#-hacer-push-y-verificar)

---

## 🚀 Levantar SonarQube en Docker

### Paso 1: Iniciar SonarQube

```bash
cd /ruta/al/proyecto
docker-compose -f sonarqube-compose.yml up -d
```

Espera ~2-3 minutos para que SonarQube se inicie completamente.

### Paso 2: Acceder a SonarQube

- URL: `http://localhost:9000`
- Usuario: `admin`
- Contraseña: `admin` (cámbiala en el primer login)

### Paso 3: Crear un nuevo proyecto

1. Ve a **Projects** → **Create Project**
2. Selecciona **Manually** (no GitHub)
3. Project Key: `reservas-ec`
4. Project Name: `ReservasEC`
5. Main branch: `main`
6. Haz clic en **Create project**

---

## 🎯 Crear Quality Gate "StrictGate"

### Paso 1: Ir a Quality Gates

En SonarQube:
1. **Administration** → **Quality Gates**
2. Haz clic en **Create** (esquina superior derecha)

### Paso 2: Ingresar datos

- **Name:** `StrictGate`
- **Set as default:** NO (déjalo desmarcado)
- Haz clic en **Create**

### Paso 3: Agregar condiciones

Para cada métrica abajo, haz clic en **Add Condition** y configura:

| Métrica | Operador | Valor |
|---------|----------|-------|
| Blocker Issues | is greater than | 0 |
| Critical Issues | is greater than | 0 |
| Major Issues | is greater than | 5 |
| Security Hotspots Reviewed | is less than | 100 |
| Coverage | is less than | 80 |
| Duplicated Lines (%) | is greater than | 3 |
| Maintainability Rating | is worse than | A |
| Cyclomatic Complexity (total) | is greater than | 50 |
| Cognitive Complexity (total) | is greater than | 30 |

### Paso 4: Asignar Quality Gate al proyecto

1. Ve a **Projects** → **ReservasEC**
2. **Project Settings** → **Quality Gate**
3. Selecciona `StrictGate`
4. Guarda cambios

---

## 🔐 Configurar Token de SonarQube

### Paso 1: Generar Token

En SonarQube:
1. Haz clic en tu **Avatar** (esquina superior derecha) → **My Account**
2. **Security** → **Tokens**
3. **Generate Tokens**
4. **Name:** `github-actions`
5. Selecciona el token generado y **cópialo** (lo necesitarás)

### Paso 2: Guardar la URL y Token

```
SONAR_HOST_URL: http://localhost:9000 (para local)
SONAR_TOKEN: <el_token_que_copiaste>
```

Si usas SonarQube en la nube, reemplaza la URL con la proporcionada.

---

## 🤖 Crear Bot de Telegram

### Paso 1: Buscar BotFather

1. Abre Telegram
2. Busca `@BotFather` (bot oficial de Telegram)
3. Envía `/newbot`

### Paso 2: Nombrar el bot

```
¿Cuál es el nombre del bot? Responde con tu nombre deseado.
Ejemplo: EquipoDevNotifierBot
```

### Paso 3: Obtener el Token

BotFather te dará un mensaje similar a:

```
Done! Congratulations on your new bot. You'll find it at t.me/YourBotName.
Use this token to access the HTTP API:
1234567890:ABCDefGhIjKlMnOpQrStUvWxYz1234567890
```

**Copia este token** (será `TELEGRAM_BOT_TOKEN`)

### Paso 4: Crear grupo de Telegram

1. Abre Telegram
2. **New Group** → Agrega el nombre del grupo (ej. "ReservasEC Dev")
3. Agrega a los miembros del equipo
4. Haz clic en **Create**

### Paso 5: Obtener Chat ID

1. Invita al bot al grupo (búscalo por @YourBotName)
2. En un navegador, ve a:

```
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates
```

Reemplaza `<TELEGRAM_BOT_TOKEN>` con el token que copiaste.

3. Busca en el JSON la clave `"chat"` → `"id"` (será un número negativo como `-1001234567890`)
4. **Copia este ID** (será `TELEGRAM_CHAT_ID`)

---

## 🔑 Configurar Secrets en GitHub

### Paso 1: Ir a GitHub

1. Ve a tu repositorio
2. **Settings** → **Secrets and variables** → **Actions**
3. Haz clic en **New repository secret**

### Paso 2: Agregar secrets

Agrega 4 secrets:

#### Secret 1: SONAR_HOST_URL
- **Name:** `SONAR_HOST_URL`
- **Value:** `http://localhost:9000` (o la URL de SonarQube en la nube)
- **Add secret**

#### Secret 2: SONAR_TOKEN
- **Name:** `SONAR_TOKEN`
- **Value:** `<el_token_de_sonarqube_que_copiaste>`
- **Add secret**

#### Secret 3: TELEGRAM_BOT_TOKEN
- **Name:** `TELEGRAM_BOT_TOKEN`
- **Value:** `<el_token_del_bot_de_telegram>`
- **Add secret**

#### Secret 4: TELEGRAM_CHAT_ID
- **Name:** `TELEGRAM_CHAT_ID`
- **Value:** `<el_chat_id_del_grupo>`
- **Add secret**

---

## ✅ Hacer Push y Verificar

### Paso 1: Hacer un commit y push

```bash
cd /ruta/al/proyecto
git add .
git commit -m "feat: Add SonarQube and Telegram automation"
git push origin main
```

### Paso 2: Verificar GitHub Actions

1. Ve a tu repositorio en GitHub
2. **Actions** (pestaña)
3. Deberías ver los workflows:
   - `SonarQube Analysis`
   - `Telegram Notification`

### Paso 3: Monitorear SonarQube

1. Ve a `http://localhost:9000`
2. Verifica que el proyecto `ReservasEC` tiene el análisis más reciente
3. Mira el **Quality Gate** status

### Paso 4: Recibir Telegram

En el grupo de Telegram del equipo, deberías recibir un mensaje automático con:
- Autor del commit
- Rama
- Mensaje del commit
- Enlace al commit en GitHub
- Archivos modificados

---

## 🐛 Troubleshooting

### SonarQube no inicia

```bash
# Ver logs
docker-compose -f sonarqube-compose.yml logs sonarqube

# Reintentar
docker-compose -f sonarqube-compose.yml down
docker-compose -f sonarqube-compose.yml up -d
```

### GitHub Actions falla

- Verifica que los **secrets** estén configurados correctamente
- Mira los **logs** del workflow en GitHub → **Actions** → el workflow específico

### Telegram no recibe mensajes

- Verifica que el bot está en el grupo
- Verifica que `TELEGRAM_CHAT_ID` es correcto (debe ser negativo)
- Prueba manualmente: `curl https://api.telegram.org/bot<TOKEN>/sendMessage -d "chat_id=<ID>&text=Test"`

---

## 📚 Recursos útiles

- [Documentación de SonarQube](https://docs.sonarqube.org/)
- [GitHub Actions - SonarQube](https://github.com/SonarSource/sonarqube-scan-action)
- [API de Telegram](https://core.telegram.org/bots/api)

---

## 🎯 Próximos pasos

Una vez configurado:

1. **Hacer push** regularmente verificará automáticamente el código
2. **SonarQube** analizará en busca de problemas
3. **GitHub Actions** ejecutará el Quality Gate
4. **Telegram** notificará al equipo de cada push
5. **Quality Gate** fallará si no cumple los umbrales (bloqueará PRs en el futuro)

¡Listo! 🎉
