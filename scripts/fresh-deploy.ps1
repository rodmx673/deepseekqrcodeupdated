# fresh-deploy.ps1 - Versión optimizada
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  FRESH DEPLOY A NUEVO REPOSITORIO       " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Configuración
$NUEVO_REPO = "https://github.com/rodmx673/deepseekqrcodeupdated.git"
$REPO_NOMBRE = "deepseekqrcodeupdated"  # Ahora se usa
$PROJECT_NAME = "QR Gate Skool"  # Ahora se usa

Write-Host "📦 Nuevo repositorio: $NUEVO_REPO" -ForegroundColor Magenta
Write-Host "📁 Nombre: $REPO_NOMBRE" -ForegroundColor Magenta
Write-Host "🏫 Proyecto: $PROJECT_NAME" -ForegroundColor Magenta
Write-Host ""

# Paso 1: Preparar directorio
Write-Host "1. PREPARANDO DIRECTORIO..." -ForegroundColor Yellow

if (Test-Path ".git") {
    Write-Host "   [ℹ️] Hay un repositorio Git existente" -ForegroundColor Cyan
    $clean_git = Read-Host "   ¿Quieres eliminar la configuración Git actual y empezar fresco? (s/n)"
    if ($clean_git -eq 's' -or $clean_git -eq 'S') {
        Remove-Item -Path ".git" -Recurse -Force
        Write-Host "   [🗑️] Configuración Git eliminada" -ForegroundColor Green
    } else {
        Write-Host "   [⚠️] Usando repositorio existente" -ForegroundColor Yellow
    }
}

# Paso 2: Inicializar/Reiniciar Git
Write-Host "`n2. CONFIGURANDO GIT..." -ForegroundColor Yellow

if (-not (Test-Path ".git")) {
    git init
    Write-Host "   [✅] Nuevo repositorio Git inicializado" -ForegroundColor Green
}

# Configurar usuario
git config user.name "rodmx673"
$user_email = git config --global user.email
if (-not $user_email) {
    git config user.email "rodmx673@github.com"
}
Write-Host "   [✅] Usuario Git configurado: rodmx673" -ForegroundColor Green

# Paso 3: Verificar y organizar estructura
Write-Host "`n3. ORGANIZANDO ESTRUCTURA..." -ForegroundColor Yellow

# Crear frontend si no existe
if (-not (Test-Path "frontend")) {
    New-Item -ItemType Directory -Path "frontend" -Force | Out-Null
    Write-Host "   [+] Carpeta frontend creada" -ForegroundColor Green
}

# Mover archivos HTML a frontend
$html_files = Get-ChildItem "*.html" -ErrorAction SilentlyContinue
if ($html_files) {
    foreach ($file in $html_files) {
        Move-Item $file.FullName "frontend\" -Force
        Write-Host "   [→] $($file.Name) → frontend/" -ForegroundColor Cyan
    }
} else {
    Write-Host "   [ℹ️] No hay archivos HTML en el directorio raíz" -ForegroundColor Gray
}

# Limpiar .git interno si existe
if (Test-Path "frontend\qr-scanner-system\.git") {
    Remove-Item -Path "frontend\qr-scanner-system\.git" -Recurse -Force
    Write-Host "   [✅] .git interno eliminado de qr-scanner-system" -ForegroundColor Green
}

# Paso 4: Crear archivos esenciales
Write-Host "`n4. CREANDO ARCHIVOS DE CONFIGURACIÓN..." -ForegroundColor Yellow

# .gitignore
$gitignore = "# Dependencies
node_modules/
npm-debug.log*

# Environment
.env

# Editor
.vscode/

# OS
.DS_Store
Thumbs.db

# Logs
*.log"
Set-Content -Path ".gitignore" -Value $gitignore -Encoding UTF8
Write-Host "   [✅] .gitignore creado" -ForegroundColor Green

# README.md
$readme = "# $PROJECT_NAME

Sistema de control de acceso mediante códigos QR para $REPO_NOMBRE

## Características
- Escaneo QR en tiempo real
- Múltiples dashboards por rol
- Interfaz responsive

## Uso
Abre \`frontend/index.html\` en tu navegador.

## Deploy
Configurado para Netlify. Directorio: \`frontend/\`

## Autor
rodmx673

## Repositorio
$NUEVO_REPO"
Set-Content -Path "README.md" -Value $readme -Encoding UTF8
Write-Host "   [✅] README.md creado" -ForegroundColor Green

# netlify.toml
$netlify_config = "[build]
  publish = 'frontend'
  command = ''

[[redirects]]
  from = '/*'
  to = '/index.html'
  status = 200"
Set-Content -Path "netlify.toml" -Value $netlify_config -Encoding UTF8
Write-Host "   [✅] netlify.toml creado" -ForegroundColor Green

# Paso 5: Agregar y commit
Write-Host "`n5. PREPARANDO COMMIT..." -ForegroundColor Yellow

git add .
Write-Host "   [✅] Archivos agregados" -ForegroundColor Green

$commit_msg = "Initial commit: $PROJECT_NAME - $REPO_NOMBRE"
git commit -m $commit_msg
Write-Host "   [✅] Commit creado: '$commit_msg'" -ForegroundColor Green

# Paso 6: Configurar remoto y pushear
Write-Host "`n6. SUBIENDO A GITHUB..." -ForegroundColor Yellow

# Remover remoto existente si hay
git remote remove origin 2>$null

# Agregar nuevo remoto
git remote add origin $NUEVO_REPO
Write-Host "   [🔗] Remoto configurado: $REPO_NOMBRE" -ForegroundColor Cyan

# Crear rama main y pushear
git branch -M main
Write-Host "   [↑] Subiendo a GitHub..." -ForegroundColor Cyan
git push -u origin main --force

if ($LASTEXITCODE -eq 0) {
    Write-Host "   [🎉] ¡ÉXITO! Proyecto subido a $REPO_NOMBRE" -ForegroundColor Green
}

# Paso 7: Mostrar resumen
Write-Host "`n7. RESUMEN Y SIGUIENTES PASOS:" -ForegroundColor Magenta

$netlify_url = "https://$REPO_NOMBRE.netlify.app"
Write-Host @"
   
   ✅ DEPLOY COMPLETADO:
   --------------------
   📦 Proyecto: $PROJECT_NAME
   🔗 Repositorio: $NUEVO_REPO
   📁 Nombre: $REPO_NOMBRE
   🌿 Rama: main
   📦 Commit: $commit_msg
   
   🚀 PARA NETLIFY:
   ---------------
   1. Ve a: https://app.netlify.com
   2. 'Add new site' → 'Import an existing project'
   3. Busca: '$REPO_NOMBRE'
   4. Configura:
      - Build command: (vacío)
      - Publish directory: frontend
   5. 'Deploy site'
   
   🌐 URL PROBABLE:
   ---------------
   $netlify_url
   
   📁 ESTRUCTURA:
   -------------
   .gitignore
   README.md
   netlify.toml
   frontend/
   └── *.html
   
   ⏱️  Tiempo estimado: 2 minutos
"@

# Opción para abrir enlaces
Write-Host "`n¿Abrir enlaces? (s/n)" -ForegroundColor White
$abrir = Read-Host
if ($abrir -eq 's') {
    Start-Process $NUEVO_REPO
    Start-Sleep -Seconds 2
    Start-Process "https://app.netlify.com"
}

Write-Host "`n✨ ¡$PROJECT_NAME está listo en $REPO_NOMBRE!" -ForegroundColor Green