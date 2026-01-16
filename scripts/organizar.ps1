# setup.ps1 - Script para organizar QR Gate Skool
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  ORGANIZANDO QR GATE SKOOL PARA GIT     " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 1. CREAR CARPETAS
Write-Host "1. CREANDO ESTRUCTURA..." -ForegroundColor Yellow

$carpetas = @(
    "frontend",
    "backend\google-apps-script",
    "backend\server-local", 
    "backend\config",
    "public\assets\css",
    "public\assets\js",
    "public\assets\images"
)

foreach ($carpeta in $carpetas) {
    if (!(Test-Path $carpeta)) {
        New-Item -ItemType Directory -Path $carpeta -Force | Out-Null
        Write-Host "   [+] $carpeta" -ForegroundColor Green
    } else {
        Write-Host "   [✓] $carpeta" -ForegroundColor Gray
    }
}

# 2. MOVER ARCHIVOS HTML
Write-Host ""
Write-Host "2. MOVIENDO ARCHIVOS HTML..." -ForegroundColor Yellow

$html_files = Get-ChildItem "*.html" -ErrorAction SilentlyContinue

if ($html_files) {
    foreach ($file in $html_files) {
        Move-Item $file.FullName "frontend\" -Force
        Write-Host "   [→] $($file.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "   [!] No hay archivos HTML" -ForegroundColor Red
}

# 3. CREAR ARCHIVOS DE CONFIGURACIÓN
Write-Host ""
Write-Host "3. CREANDO ARCHIVOS DE CONFIG..." -ForegroundColor Yellow

# .gitignore
$gitignore_content = @"
# Dependencias
node_modules/
npm-debug.log*

# Environment
.env
.env.local

# Editor
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# No subir archivos de usuarios
uploads/
database/
backups/

# Logs
*.log
"@

Set-Content -Path ".gitignore" -Value $gitignore_content
Write-Host "   [+] .gitignore" -ForegroundColor Green

# package.json
$package_json_content = '{
  "name": "qr-gate-skool",
  "version": "1.0.0",
  "description": "Sistema de control de acceso QR",
  "main": "frontend/index.html",
  "scripts": {
    "start": "serve frontend",
    "dev": "serve frontend",
    "deploy": "echo \"Ejecuta: netlify deploy --prod\""
  },
  "devDependencies": {
    "serve": "^14.0.0"
  }
}'

Set-Content -Path "package.json" -Value $package_json_content
Write-Host "   [+] package.json" -ForegroundColor Green

# README.md - USANDO HERE-STRING CON COMILLAS DOBLES
$readme_content = @"
# QR Gate Skool

Sistema de control de acceso con códigos QR.

## 🚀 Características
- Escaneo QR en tiempo real
- Notificaciones por email
- Dashboard por roles
- Almacenamiento en Google Sheets

## 📦 Instalación
\`\`\`bash
npm install
npm start
\`\`\`

## 📁 Estructura del Proyecto
\`\`\`
frontend/          # Archivos HTML/CSS/JS
backend/           # Lógica del servidor y Google Apps Script
public/            # Recursos públicos
\`\`\`

## 🔧 Configuración
1. Clona el repositorio
2. Instala dependencias: \`npm install\`
3. Ejecuta: \`npm start\`
4. Abre http://localhost:3000

## 📄 Licencia
MIT
"@

# Guardar el README.md
Set-Content -Path "README.md" -Value $readme_content
Write-Host "   [+] README.md" -ForegroundColor Green

Write-Host ""
Write-Host "✅ ESTRUCTURA CREADA CORRECTAMENTE" -ForegroundColor Green
Write-Host "📁 Carpetas organizadas" -ForegroundColor Cyan
Write-Host "📄 Archivos de configuración generados" -ForegroundColor Cyan