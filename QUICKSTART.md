# ⚡ Quick Start: SonarQube + GitHub Actions + Telegram

## 📋 Checklist de Configuración

### Paso 1: Levantar SonarQube ✅
```bash
docker-compose -f sonarqube-compose.yml up -d
# Espera 2-3 minutos...
# Accede en: http://localhost:9000 (admin/admin)
```
- [ ] SonarQube iniciado y accesible

### Paso 2: Crear Quality Gate en SonarQube
Ve a http://localhost:9000 → Administration → Quality Gates → Create
- [ ] Quality Gate "StrictGate" creado con condiciones del archivo `SETUP_SONARQUBE_TELEGRAM.md`
- [ ] Quality Gate asignado al proyecto "ReservasEC"

### Paso 3: Generar Token de SonarQube
En SonarQube: Avatar → My Account → Security → Tokens → Generate
- [ ] Token generado y guardado (ej: `squ_abc123...`)

### Paso 4: Crear Bot de Telegram
Telegram: Busca @BotFather → /newbot
- [ ] Bot creado
- [ ] Token guardado (ej: `123456:ABC-DEF123456`)
- [ ] Grupo creado e invitado el bot

### Paso 5: Obtener Chat ID de Telegram
```bash
# Reemplaza <TELEGRAM_BOT_TOKEN>
curl https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates
```
- [ ] Chat ID obtenido (número negativo como `-1001234567890`)

### Paso 6: Configurar Secrets en GitHub
Repository → Settings → Secrets and variables → Actions → New secret

Agrega estos 4 secrets:
- [ ] `SONAR_HOST_URL` = `http://localhost:9000`
- [ ] `SONAR_TOKEN` = `squ_abc123...`
- [ ] `TELEGRAM_BOT_TOKEN` = `123456:ABC-DEF123456`
- [ ] `TELEGRAM_CHAT_ID` = `-1001234567890`

### Paso 7: Hacer Push
```bash
git push origin main
```
- [ ] Commit hecho y pusheado
- [ ] GitHub Actions ejecutándose (ve a Actions tab)
- [ ] SonarQube análisis completado en http://localhost:9000
- [ ] Telegram notificación recibida en el grupo

---

## 🔄 Flujo Automático (después de configurar)

```
Tu commit (git push)
    ↓
GitHub Actions dispara
    ├→ SonarQube Analysis (escanea el código)
    │   ├→ Verifica Quality Gate
    │   └→ Genera reporte
    └→ Telegram Notify (envía mensaje al grupo)
        └→ Incluye autor, rama, mensaje, archivos, link
```

---

## 📊 Ver Resultados

- **SonarQube Dashboard:** http://localhost:9000/dashboard?id=reservas-ec
- **GitHub Actions:** Repository → Actions → Click en workflow
- **Telegram:** Grupo del equipo (mensajes automáticos)

---

## 🐛 Verificación Rápida

### ¿SonarQube levantado?
```bash
curl http://localhost:9000/api/system/status
# Debe responder: {"status":"UP"}
```

### ¿Token de SonarQube válido?
```bash
export SONAR_TOKEN=<tu_token>
curl -u $SONAR_TOKEN: http://localhost:9000/api/user_tokens/search
```

### ¿Telegram bot válido?
```bash
# Reemplaza valores
curl https://api.telegram.org/bot<TOKEN>/getMe
```

---

## 📖 Documentación Completa

Lee `SETUP_SONARQUBE_TELEGRAM.md` para:
- Instrucciones paso a paso detalladas
- Solución de problemas
- Configuración avanzada

---

## 🎯 Próximos pasos

1. ✅ Configura los 6 pasos de arriba
2. 📤 Haz un push para probar
3. 📊 Verifica que los workflows se ejecuten
4. 📱 Recibe notificación en Telegram
5. 🔄 A partir de ahora, todo es automático

¡Listo! Cualquier push ejecutará SonarQube y notificará al equipo via Telegram 🎉
