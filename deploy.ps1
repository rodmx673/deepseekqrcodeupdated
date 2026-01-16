# deploy-final.ps1 - Versión simplificada y corregida
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  QR GATE SKOOL - DEPLOY FINAL           " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Organizar archivos HTML
Write-Host "1. ORGANIZANDO ARCHIVOS HTML..." -ForegroundColor Yellow

# Crear carpeta frontend si no existe
if (-not (Test-Path "frontend")) {
    New-Item -ItemType Directory -Path "frontend" -Force | Out-Null
}

# Mover todos los archivos HTML
$html_files = Get-ChildItem "*.html"
foreach ($file in $html_files) {
    Move-Item $file.FullName "frontend\" -Force
    Write-Host "   [→] $($file.Name) → frontend/" -ForegroundColor Green
}

# Paso 2: Mover qr-scanner-system
if (Test-Path "qr-scanner-system") {
    Move-Item "qr-scanner-system" "frontend\" -Force
    Write-Host "   [→] qr-scanner-system/ → frontend/" -ForegroundColor Green
}

# Paso 3: Crear archivos básicos de configuración
Write-Host "`n2. CREANDO ARCHIVOS DE CONFIGURACIÓN..." -ForegroundColor Yellow

# .gitignore simple
$gitignore = "# Dependencies
node_modules/
npm-debug.log*

# Environment
.env

# Editor
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db"

Set-Content -Path ".gitignore" -Value $gitignore -Encoding UTF8
Write-Host "   [+] .gitignore creado" -ForegroundColor Green

# netlify.toml simple
$netlify_config = "[build]
  publish = 'frontend'
  command = ''

[[redirects]]
  from = '/*'
  to = '/index.html'
  status = 200"

Set-Content -Path "netlify.toml" -Value $netlify_config -Encoding UTF8
Write-Host "   [+] netlify.toml creado" -ForegroundColor Green

# Paso 4: Git commit
Write-Host "`n3. ACTUALIZANDO GITHUB..." -ForegroundColor Yellow

git add .
git commit -m "deploy: Organize project structure for Netlify"
git push origin main

Write-Host "   ✅ Cambios subidos a GitHub" -ForegroundColor Green

# Paso 5: Instrucciones para Netlify
Write-Host "`n4. INSTRUCCIONES PARA NETLIFY:" -ForegroundColor Magenta
Write-Host @"

   PASOS PARA NETLIFY:
   -------------------
   1. Ve a: https://app.netlify.com
   2. Click en 'Add new site' → 'Import an existing project'
   3. Conecta tu cuenta de GitHub
   4. Busca: 'rodmx673/kimi_k2qrcode'
   5. Configura:
      - Build command: (dejar vacío)
      - Publish directory: frontend
   6. Click en 'Deploy site'

   URLs PROBABLES:
   ---------------
   - https://kimi-k2qrcode.netlify.app
   - https://kimi-k2qrcode.netlify.app/scanner.html

   TIEMPO DE DEPLOY:
   -----------------
   Aproximadamente 1-2 minutos
"@

Write-Host "`n✅ ¡LISTO! Tu proyecto está organizado." -ForegroundColor Green