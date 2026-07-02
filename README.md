# 📆 ReservasEC

**ReservasEC** es una plataforma fullstack de gestión de reservas desarrollada con una arquitectura de microservicios. Permite a los usuarios registrarse, iniciar sesión, gestionar su perfil, crear y cancelar reservas, y recibir notificaciones. El sistema está dockerizado para facilitar el despliegue local.

## 🚀 Tecnologías principales

- **Frontend:** Next.js + Tailwind CSS
- **Backend (Microservicios):**
  - Auth Service (Node.js + Express)
  - Booking Service (Node.js + Express)
  - User Service (Node.js + Express)
  - Notification Service (Node.js + Express + Nodemailer)
- **Base de datos:** MongoDB
- **Autenticación:** JSON Web Tokens (JWT)
- **Contenedores:** Docker + Docker Compose

---

## 📁 Estructura de carpetas

```plaintext
/reservas-ec
├── frontend/             # Next.js App
├── auth-service/         # Servicio de autenticación
├── user-service/         # Servicio de usuarios
├── booking-service/      # Servicio de reservas
├── notification-service/ # Servicio de notificaciones por email
└── docker-compose.yml    # Orquestación de todos los servicios
```

---

## ⚙️ Configuración del entorno

### 1. Clonar el repositorio

```bash
git clone https://github.com/thegranwil/reservas-ec.git
cd reservas-ec
```

### 2. Variables de entorno

🔐 Frontend (frontend/.env.production.local)

```bash
NEXT_PUBLIC_API_URL=/api/auth
NEXT_PUBLIC_BOOKING_URL=/api/bookings
NEXT_PUBLIC_USER_URL=/api/users
```

🔐 Backend .env (cada microservicio)
Ejemplo para auth-service:

```bash
PORT=4000
MONGO_URI=mongodb://mongo:27017/auth-db
JWT_SECRET=supersecretkey
```

Repite para los demás servicios cambiando PORT, MONGO_URI y usando el mismo JWT_SECRET.

### 3. 🐳 Uso con Docker

1. Construir los contenedores

```bash
docker-compose build
```

3. Levantar los servicios

```bash
docker-compose up
```

La app estará disponible en http://localhost:3000

## ✅ Funcionalidades principales

- Registro e inicio de sesión de usuarios

- Perfil editable

- Creación y cancelación de reservas

- Historial de reservas activas y canceladas

- Límite de 5 reservas canceladas visibles

- Notificaciones por email (reserva y cancelación)

- Gestión de microservicios independientes

---

## 🔍 Calidad de Código y Seguridad

Este proyecto implementa un sistema integral de análisis automático de código usando **SonarCloud**, **GitHub Actions** y notificaciones en **Telegram**.

### 🎯 Herramientas Utilizadas

| Herramienta | Propósito |
|------------|-----------|
| **SonarCloud** | Análisis estático de código en la nube |
| **GitHub Actions** | Automatización de CI/CD en cada push/PR |
| **Telegram Bot** | Notificaciones automáticas al equipo |

### 📊 Dashboards y Monitoreo

- 📈 **SonarCloud Dashboard:** https://sonarcloud.io/dashboard?id=WilmerBuestan_Reservas_seguras
- 🔄 **GitHub Actions:** https://github.com/WilmerBuestan/Reservas_seguras/actions
- 💬 **Telegram Group:** ReservasEC Dev (notificaciones automáticas)

### 🚀 Flujo Automático

Cada vez que un desarrollador hace `git push`:

```
git push origin main
    ↓
GitHub Actions dispara automáticamente
    ├→ SonarCloud Analysis
    │   ├→ Escanea código completo
    │   ├→ Verifica Quality Gate "StrictGate"
    │   └→ Genera reporte
    └→ Telegram Notification
        └→ Notifica equipo con resultados
```

### 🎯 Quality Gate "StrictGate"

El proyecto define **9 métricas obligatorias** que todo commit debe cumplir:

| Métrica | Umbral | Operador | Descripción |
|---------|--------|----------|-------------|
| **Blocker Issues** | 0 | = | Problemas bloqueantes |
| **Critical Issues** | 0 | = | Problemas críticos de seguridad |
| **Major Issues** | 5 | ≤ | Problemas mayores |
| **Security Hotspots Reviewed** | 100% | = | Validación de hotspots de seguridad |
| **Coverage** | 80% | ≥ | Cobertura de pruebas |
| **Duplicated Lines** | 3% | ≤ | Código duplicado |
| **Technical Debt Ratio** | 2.5% | ≤ | Deuda técnica |
| **Cyclomatic Complexity** | 50 | ≤ | Complejidad ciclomática |
| **Cognitive Complexity** | 30 | ≤ | Complejidad cognitiva |

**Nota:** Si alguna métrica NO cumple, el Quality Gate **FALLA** y el merge está bloqueado hasta corregir.

### 📄 Configuración Técnica

- **Definición completa:** [sonar-qualitygate.json](./sonar-qualitygate.json)
- **Propiedades del proyecto:** [sonar-project.properties](./sonar-project.properties)
- **Workflow de análisis:** [.github/workflows/sonarqube.yml](./.github/workflows/sonarqube.yml)
- **Workflow de Telegram:** [.github/workflows/telegram-notify.yml](./.github/workflows/telegram-notify.yml)

### 📋 Procedimiento para Ejecutar Análisis

#### Análisis Automático (Recomendado)
```bash
# 1. Hacer commit y push
git add .
git commit -m "feat: Nueva funcionalidad"
git push origin main

# 2. GitHub Actions ejecuta automáticamente:
#    - SonarCloud escanea el código
#    - Verifica Quality Gate
#    - Notifica a Telegram
#    - Resultado disponible en https://sonarcloud.io/

# 3. Revisar resultados:
#    - Ir a https://sonarcloud.io/dashboard?id=WilmerBuestan_Reservas_seguras
#    - Buscar el análisis más reciente
```

#### Análisis Manual (Desarrollo Local)
Para desarrolladores que quieran analizar localmente antes de push:

```bash
# Requiere: SonarQube Community Edition instalado localmente

# 1. Instalar SonarScanner (si no está instalado)
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
unzip sonar-scanner-cli-5.0.1.3006-linux.zip
export PATH=$PATH:$(pwd)/sonar-scanner-5.0.1.3006/bin

# 2. Configurar token local
export SONAR_TOKEN=<tu_token_local>

# 3. Ejecutar análisis
sonar-scanner \
  -Dsonar.projectKey=reservas-ec-local \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=$SONAR_TOKEN
```

### 🔐 Configuración del Bot de Telegram

#### 1. Crear el Bot

```bash
# En Telegram:
# 1. Buscar @BotFather
# 2. Enviar: /newbot
# 3. Seguir las instrucciones
# 4. Guardar el token generado
```

#### 2. Crear Grupo de Trabajo

```bash
# En Telegram:
# 1. New Group → ReservasEC Dev
# 2. Agregar miembros del equipo
# 3. Invitar al bot al grupo
```

#### 3. Obtener Chat ID

```bash
# En navegador:
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates

# En el JSON respuesta, buscar:
# "chat": {"id": -1001234567890}
# Copiar el número (será negativo)
```

#### 4. Agregar Secrets en GitHub

```bash
# En https://github.com/WilmerBuestan/Reservas_seguras/settings/secrets/actions
# Crear 3 secrets:

SONARCLOUD_TOKEN = <token_de_sonarcloud>
TELEGRAM_BOT_TOKEN = <token_de_botfather>
TELEGRAM_CHAT_ID = <chat_id_grupo>
```

### 📨 Información en Notificaciones de Telegram

Cada notificación incluye:
- 👤 **Autor:** Quién hizo el commit
- 🌿 **Rama:** main o develop
- 📝 **Mensaje:** Descripción del commit
- 🔗 **Link:** Enlace directo a GitHub
- 📋 **Archivos:** Qué se modificó
- 📊 **Resultado:** ✅ Quality Gate PASSED o ❌ FAILED

### 👥 Roles y Responsabilidades

Lee [ROLES_Y_RESPONSABILIDADES.md](./ROLES_Y_RESPONSABILIDADES.md) para:
- **Líder de Calidad:** Configura SonarCloud y Quality Gates
- **DevOps:** Mantiene CI/CD y Telegram
- **Desarrolladores:** Cumplen umbrales de calidad

### 📖 Guías de Configuración

- **[SETUP_SONARCLOUD_TELEGRAM.md](./SETUP_SONARCLOUD_TELEGRAM.md)** - Guía paso a paso (9 pasos)
- **[QUICKSTART.md](./QUICKSTART.md)** - Checklist rápido
- **[ROLES_Y_RESPONSABILIDADES.md](./ROLES_Y_RESPONSABILIDADES.md)** - Asignación de roles

### ✅ Checklist para Desarrolladores

Antes de hacer `git push`:

- [ ] El código compila sin errores
- [ ] No hay problemas bloqueantes o críticos
- [ ] No hay más de 5 problemas mayores
- [ ] Cobertura de pruebas ≥ 80%
- [ ] Código duplicado ≤ 3%
- [ ] Complejidad dentro de límites
- [ ] Revisión manual del código hecha

### 🔗 Enlaces Útiles

- **SonarCloud:** https://sonarcloud.io/
- **GitHub Actions:** https://github.com/WilmerBuestan/Reservas_seguras/actions
- **Telegram Bot API:** https://core.telegram.org/bots/api
- **SonarCloud Docs:** https://docs.sonarcloud.io/

---
