# ⚡ Quick Start: SonarCloud + GitHub Actions + Telegram

## 📋 Checklist de Configuración (9 pasos)

### Paso 1: Conectar SonarCloud con GitHub
- [ ] Ve a https://sonarcloud.io
- [ ] Sign up with GitHub
- [ ] Autoriza acceso

### Paso 2: Crear Organización en SonarCloud
- [ ] Organization key: `wilmerbuestan-org`
- [ ] Creada exitosamente

### Paso 3: Crear Proyecto en SonarCloud
- [ ] Selecciona repositorio: `WilmerBuestan/Reservas_seguras`
- [ ] Selecciona GitHub Actions
- [ ] Proyecto importado

### Paso 4: Generar Token en SonarCloud
- [ ] Ve a My Account → Security → Tokens
- [ ] Genera token: `github-actions`
- [ ] Token guardado (ej: `squ_abc123...`)

### Paso 5: Crear Bot de Telegram
- [ ] @BotFather → `/newbot`
- [ ] Bot creado
- [ ] Token guardado (ej: `123456:ABC-DEF123456`)

### Paso 6: Crear Grupo de Telegram
- [ ] Grupo creado: `ReservasEC Dev`
- [ ] Bot invitado al grupo

### Paso 7: Obtener Chat ID de Telegram
```bash
curl https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates
```
- [ ] Chat ID obtenido (número negativo)

### Paso 8: Configurar Secrets en GitHub
Repository → Settings → Secrets and variables → Actions

Agrega 3 secrets:
- [ ] `SONARCLOUD_TOKEN` = `squ_abc123...`
- [ ] `TELEGRAM_BOT_TOKEN` = `123456:ABC-DEF123456`
- [ ] `TELEGRAM_CHAT_ID` = `-1001234567890`

### Paso 9: Hacer Push
```bash
git push origin main
```
- [ ] Commit pusheado
- [ ] GitHub Actions ejecutándose (Actions tab)
- [ ] SonarCloud análisis en https://sonarcloud.io/
- [ ] Telegram notificación recibida

---

## 🔄 Flujo Automático

```
git push origin main
    ↓
GitHub Actions dispara
    ├→ SonarCloud Analysis (escanea en la nube)
    │   ├→ Verifica Quality Gate
    │   └→ Reporte en https://sonarcloud.io/
    └→ Telegram Notification (mensaje al grupo)
```

---

## 📊 Ver Resultados

- **SonarCloud Dashboard:** https://sonarcloud.io/dashboard?id=WilmerBuestan_Reservas_seguras
- **GitHub Actions:** https://github.com/WilmerBuestan/Reservas_seguras/actions
- **Telegram:** Tu grupo de equipo

---

## 📖 Documentación Completa

Lee `SETUP_SONARCLOUD_TELEGRAM.md` para instrucciones detalladas y troubleshooting.

---

## ✨ ¡Listo!

Una vez configurado, cada push:
1. ✅ Escanea el código en SonarCloud
2. ✅ Verifica Quality Gate
3. ✅ Notifica al equipo en Telegram

¡Sin servidores locales! 🎉
