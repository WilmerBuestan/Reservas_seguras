#!/bin/bash

# Script para ejecutar SonarQube Scanner localmente
# Uso: ./run-sonar-scan.sh

set -e

echo "🔍 Iniciando escaneo de SonarQube..."
echo ""

# Verificar que SonarQube esté disponible
SONAR_HOST=${SONAR_HOST_URL:-http://localhost:9000}
SONAR_TOKEN=${SONAR_TOKEN}

if [ -z "$SONAR_TOKEN" ]; then
    echo "❌ Error: La variable SONAR_TOKEN no está configurada"
    echo "Configúrala con:"
    echo "  export SONAR_TOKEN=<tu_token_de_sonarqube>"
    exit 1
fi

echo "📍 SonarQube Host: $SONAR_HOST"
echo ""

# Verificar disponibilidad de SonarQube
if ! curl -s "$SONAR_HOST/api/system/status" > /dev/null; then
    echo "❌ Error: No se puede conectar a SonarQube en $SONAR_HOST"
    echo "Asegúrate de que SonarQube está levantado:"
    echo "  docker-compose -f sonarqube-compose.yml up -d"
    exit 1
fi

echo "✅ SonarQube está disponible"
echo ""

# Descargar SonarScanner si no existe
if ! command -v sonar-scanner &> /dev/null; then
    echo "📥 Descargando SonarScanner..."
    SONAR_SCANNER_VERSION="5.0.1.3006"
    SONAR_SCANNER_HOME="/opt/sonar-scanner-${SONAR_SCANNER_VERSION}"

    if [ ! -d "$SONAR_SCANNER_HOME" ]; then
        wget -q "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip" -O /tmp/sonar-scanner.zip
        unzip -q /tmp/sonar-scanner.zip -d /opt/
        rm /tmp/sonar-scanner.zip
    fi

    export PATH="$SONAR_SCANNER_HOME/bin:$PATH"
fi

echo "🚀 Ejecutando análisis..."
echo ""

# Ejecutar el escaneo
sonar-scanner \
  -Dsonar.projectKey=reservas-ec \
  -Dsonar.projectName=ReservasEC \
  -Dsonar.projectVersion=1.0.0 \
  -Dsonar.sources=. \
  -Dsonar.exclusions="node_modules/**,dist/**,.git/**,**/test/**,**/*.test.js,**/*.spec.js,*.config.js,coverage/**" \
  -Dsonar.host.url="$SONAR_HOST" \
  -Dsonar.login="$SONAR_TOKEN" \
  -Dsonar.qualitygate.wait=true

echo ""
echo "✅ Escaneo completado"
echo ""
echo "📊 Ver resultados en: $SONAR_HOST/dashboard?id=reservas-ec"
