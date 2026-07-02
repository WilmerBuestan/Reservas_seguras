# 🐛 Troubleshooting: SonarCloud + Telegram

Soluciones para problemas comunes en la configuración.

---

## ❌ Error: "Organization key does not exist"

**Síntoma:** 
```
ERROR Organization key 'wilmerbuestan-org' does not exist.
Process completed with exit code 3.
```

**Causa:** La organización especificada en el workflow no existe en SonarCloud.

**Solución:**

SonarCloud detecta automáticamente la organización desde el binding de GitHub. 

**Verificar:**
1. Ve a: https://sonarcloud.io/
2. Verifica que tu organización esté listada
3. El nombre generalmente es tu **usuario de GitHub** o algo similar
4. El workflow ahora NO especifica organización (usa la detectada automáticamente)

**Fix ya aplicado:** Se eliminó `-Dsonar.organization=wilmerbuestan-org` del workflow.

---

## 🤖 Telegram: No llegan mensajes

**Síntoma:** GitHub Actions ejecuta exitosamente pero NO recibes mensajes en Telegram.

**Posibles causas:**
1. ❌ `TELEGRAM_BOT_TOKEN` no está en GitHub Secrets
2. ❌ `TELEGRAM_CHAT_ID` no está en GitHub Secrets
3. ❌ El token es inválido
4. ❌ El bot no está en el grupo
5. ❌ El Chat ID es incorrecto

**Solución paso a paso:**

### Paso 1: Verificar que los secrets existen

Ve a: https://github.com/WilmerBuestan/Reservas_seguras/settings/secrets/actions

Deberías ver estos 3 secrets:
- ✅ `SONARCLOUD_TOKEN`
- ✅ `TELEGRAM_BOT_TOKEN`
- ✅ `TELEGRAM_CHAT_ID`

Si faltan alguno, ve a **New repository secret** y agrégalos.

### Paso 2: Verificar que el token de Telegram es válido

En tu navegador, reemplaza `<TOKEN>` y ve a:

```
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getMe
```

**Debería responder:**
```json
{
  "ok": true,
  "result": {
    "id": 1234567890,
    "is_bot": true,
    "first_name": "EquipoDevNotifierBot",
    "username": "EquipoDevNotifierBot",
    ...
  }
}
```

Si dice `"ok": false`, el token es **inválido**.

**¿Cómo obtener un token válido?**
1. Telegram → Busca `@BotFather`
2. Envía `/newbot`
3. Sigue las instrucciones
4. Copia el token que genera

### Paso 3: Verificar que el Chat ID es correcto

En tu navegador, reemplaza `<TOKEN>` y ve a:

```
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates
```

**Busca en la respuesta JSON:**
```json
{
  "ok": true,
  "result": [
    {
      "update_id": 123456,
      "message": {
        "message_id": 1,
        "date": 1234567890,
        "chat": {
          "id": -1001234567890,  ← ¡ESTE ES TU CHAT ID!
          "type": "group",
          ...
        }
      }
    }
  ]
}
```

El `chat.id` es tu **Chat ID** (será un número **negativo**).

**⚠️ Importante:** Asegúrate que el Chat ID tiene el **signo negativo** (-)

### Paso 4: Verificar que el bot está en el grupo

1. Abre Telegram
2. Ve a tu grupo "ReservasEC Dev"
3. Haz click en el nombre del grupo
4. Busca en **Members** a tu bot
5. Si no está, invítalo:
   - Busca tu bot por nombre (@EquipoDevNotifierBot)
   - Agrega al grupo

### Paso 5: Actualizar los secrets en GitHub

1. Ve a: https://github.com/WilmerBuestan/Reservas_seguras/settings/secrets/actions
2. Para cada secret, haz clic en el nombre
3. Haz clic en **Update secret**
4. Pega el valor correcto
5. Guarda

---

## ✅ Verificar que TODO funciona

### Test 1: Verificar SonarCloud Token

```bash
# En tu terminal:
export SONAR_TOKEN="<tu_token_sonarcloud>"
curl -u $SONAR_TOKEN: https://api.sonarcloud.io/api/user_tokens/search

# Debería responder sin error
```

### Test 2: Verificar Telegram Bot Token

```bash
# En tu navegador:
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getMe

# Debería responder: "ok": true
```

### Test 3: Verificar Telegram Chat ID

```bash
# En tu navegador:
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates

# Busca: "chat": {"id": <NUMERO_NEGATIVO>}
```

### Test 4: Enviar mensaje de prueba a Telegram

```bash
# En terminal:
curl https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/sendMessage \
  -d "chat_id=<TELEGRAM_CHAT_ID>&text=Test%20from%20GitHub"

# Debería llegar un mensaje a tu grupo
```

Si llegó el mensaje de prueba, tu Telegram está OK.

---

## 🚀 Si todo está OK: Haz un push de prueba

```bash
cd /ruta/al/proyecto

echo "# Test" >> TEST_FIX.md
git add TEST_FIX.md
git commit -m "test: Verify SonarCloud and Telegram fix"
git push origin main
```

**Espera 5 minutos** y verifica:

1. ✅ **GitHub Actions** → 2 workflows sin errores
2. ✅ **SonarCloud** → Análisis completado
3. ✅ **Telegram** → Mensaje recibido en el grupo

---

## 📋 Checklist de Verificación

- [ ] `SONARCLOUD_TOKEN` en GitHub Secrets ✅
- [ ] `TELEGRAM_BOT_TOKEN` en GitHub Secrets ✅
- [ ] `TELEGRAM_CHAT_ID` en GitHub Secrets ✅
- [ ] Token de Telegram es válido (getMe responde OK)
- [ ] Chat ID es correcto (número negativo)
- [ ] Bot está en el grupo de Telegram
- [ ] Workflow de SonarCloud sin `-Dsonar.organization`
- [ ] Último commit pusheado exitosamente

---

## 🆘 Aún hay problemas?

Si después de todo esto aún hay errores:

1. **Copia el error** del workflow en GitHub Actions
2. **Verifica que:**
   - No hay espacios en blanco en los secrets
   - El Chat ID tiene el signo `-`
   - El token no tiene comillas ni caracteres raros
3. **Borra los secrets** y vuelve a agregarlos (a veces hay caracteres ocultos)
4. **Prueba manualmente** con curl como se muestra arriba

---

**Última actualización:** 2026-07-02
