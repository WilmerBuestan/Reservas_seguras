# Roles y Responsabilidades - Calidad de Código

Documento que define los roles del equipo en la implementación y mantenimiento del sistema de Quality Gates con SonarCloud y notificaciones vía Telegram.

---

## 👨‍💼 Líder de Calidad

**Responsabilidades:**
- Configurar y mantener SonarCloud
- Definir y ajustar los Quality Gates (umbrales de calidad)
- Monitorear métricas de código en el dashboard de SonarCloud
- Establecer estándares de calidad del proyecto
- Revisar reportes de SonarCloud periódicamente
- Comunicar cambios en políticas de calidad al equipo

**Acciones requeridas:**
1. Crear y configurar la organización en SonarCloud
2. Crear el Quality Gate "StrictGate" con 9 métricas
3. Asignar el Quality Gate al proyecto ReservasEC
4. Generar y almacenar de forma segura el `SONARCLOUD_TOKEN`
5. Crear documentación sobre los umbrales definidos

**Recursos:**
- Dashboard SonarCloud: https://sonarcloud.io/
- Documentación: `SETUP_SONARCLOUD_TELEGRAM.md`

---

## 🔧 DevOps / Ingeniero de CI-CD

**Responsabilidades:**
- Configurar y mantener los workflows de GitHub Actions
- Integrar SonarCloud con el pipeline CI/CD
- Configurar las notificaciones automáticas en Telegram
- Monitorear la ejecución de los workflows
- Resolver problemas en la automatización
- Documentar el proceso de CI/CD

**Acciones requeridas:**
1. Actualizar `.github/workflows/sonarqube.yml` según necesidades
2. Crear y mantener `.github/workflows/telegram-notify.yml`
3. Configurar los secrets en GitHub (SONARCLOUD_TOKEN, TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID)
4. Crear y administrar el bot de Telegram (@BotFather)
5. Mantener el grupo de Telegram actualizado
6. Monitorear que los workflows se ejecuten correctamente

**Recursos:**
- GitHub Actions: https://github.com/WilmerBuestan/Reservas_seguras/actions
- Documentación: `SETUP_SONARCLOUD_TELEGRAM.md`, `QUICKSTART.md`

---

## 👨‍💻 Desarrolladores

**Responsabilidades:**
- Cumplir con los umbrales de calidad definidos en el Quality Gate
- Revisar los reportes de SonarCloud después de hacer push
- Corregir problemas de código identificados por SonarCloud
- Evitar introducir deuda técnica
- Participar en la mejora continua de la calidad
- Responder a las notificaciones de Telegram sobre análisis fallidos

**Acciones requeridas:**
1. Leer y entender los umbrales de Quality Gate en `sonar-qualitygate.json`
2. Revisar el dashboard de SonarCloud: https://sonarcloud.io/dashboard?id=WilmerBuestan_Reservas_seguras
3. Corregir issues identificadas antes de hacer merge
4. No hacer push código que no cumpla con el Quality Gate
5. Mantener cobertura de código > 80%
6. Minimizar código duplicado

**Checklist antes de hacer push:**
- [ ] El código compila sin errores
- [ ] No hay problemas críticos o bloqueantes
- [ ] No hay más de 5 problemas mayores
- [ ] Cobertura de pruebas > 80%
- [ ] Sin código duplicado > 3%
- [ ] Complejidad ciclomática dentro de límites

---

## 🎯 Quality Gate "StrictGate" - Métricas Obligatorias

Todos los desarrolladores deben cumplir estas métricas en cada commit:

| Métrica | Umbral | Operador |
|---------|--------|----------|
| Blocker Issues | 0 | = (igual a) |
| Critical Issues | 0 | = (igual a) |
| Major Issues | 5 | ≤ (menor o igual) |
| Security Hotspots Reviewed | 100% | = (igual a) |
| Coverage | 80% | ≥ (mayor o igual) |
| Duplicated Lines (%) | 3% | ≤ (menor o igual) |
| Technical Debt Ratio | 2.5% | ≤ (menor o igual) |
| Cyclomatic Complexity | 50 | ≤ (menor o igual) |
| Cognitive Complexity | 30 | ≤ (menor o igual) |

---

## 📊 Flujo de Trabajo

```
Desarrollador
    ↓
git commit & git push origin main
    ↓
GitHub Actions dispara automáticamente
    ├→ SonarCloud Analysis (escanea el código)
    │   └→ Verifica Quality Gate StrictGate
    └→ Telegram Notification (notifica al equipo)
    ↓
¿Quality Gate pasó?
    ├→ SÍ: Merge permitido, notificación ✅
    └→ NO: Merge bloqueado, notificación ⚠️
```

---

## 📱 Notificaciones en Telegram

El grupo de Telegram `ReservasEC Dev` recibe automáticamente:

### Información incluida en cada notificación:
- 👤 **Autor:** Quién hizo el commit
- 🌿 **Rama:** Rama afectada (main/develop)
- 📝 **Mensaje:** Descripción del commit
- 🔗 **Link:** Enlace directo al commit en GitHub
- 📋 **Archivos:** Lista de archivos modificados
- 📊 **Resultado:** Estado del Quality Gate (✅/❌)

### Acciones al recibir notificación:
- **✅ Quality Gate PASSED:** Cambios listos para merge
- **❌ Quality Gate FAILED:** 
  1. El desarrollador revisa el reporte en SonarCloud
  2. Corrige los issues identificados
  3. Hace push de la solución
  4. Nuevo análisis se ejecuta automáticamente

---

## 🔐 Seguridad de Credenciales

### Tokens manejados:
- `SONARCLOUD_TOKEN` - Acceso a SonarCloud (guardado en GitHub Secrets)
- `TELEGRAM_BOT_TOKEN` - Acceso al bot (guardado en GitHub Secrets)
- `TELEGRAM_CHAT_ID` - ID del grupo (guardado en GitHub Secrets)

### Medidas de seguridad:
- ✅ Nunca exponer tokens en repositorio
- ✅ Usar GitHub Secrets para almacenar credenciales
- ✅ Rotar tokens periódicamente
- ✅ Limitar permisos del bot de Telegram
- ✅ Revisar acceso a SonarCloud regularmente

---

## 📞 Contacto y Soporte

### Canales de comunicación:
- **Grupo Telegram:** ReservasEC Dev (notificaciones automáticas)
- **GitHub Issues:** Para reportar problemas
- **Reuniones:** Retrospectivas de calidad (mensual)

### Escalado de problemas:
1. **SonarCloud caído:** Contactar Líder de Calidad
2. **Workflows fallando:** Contactar DevOps
3. **Duda sobre metrics:** Consultar `SETUP_SONARCLOUD_TELEGRAM.md`

---

## 📚 Documentación de referencia

- **SETUP_SONARCLOUD_TELEGRAM.md** - Guía de configuración completa
- **QUICKSTART.md** - Checklist rápido (9 pasos)
- **sonar-qualitygate.json** - Configuración técnica del QG
- **sonar-project.properties** - Configuración del proyecto en SonarCloud
- **.github/workflows/sonarqube.yml** - Workflow de análisis
- **.github/workflows/telegram-notify.yml** - Workflow de notificaciones

---

**Última actualización:** 2026-07-02
**Versión:** 1.0
