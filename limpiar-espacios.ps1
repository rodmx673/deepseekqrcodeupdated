# limpiar-espacios.ps1 - Limpia espacios finales en SRC y SCRIPT_URL
$projectPath = "C:\rod_apps\proyecto_qr"
$htmlFiles = Get-ChildItem -Path $projectPath -Filter *.html

foreach ($file in $htmlFiles) {
    Write-Host "Procesando: $($file.Name)" -ForegroundColor Cyan
    $bak = "$($file.FullName).bak"
    if (!(Test-Path $bak)) { Copy-Item $file.FullName -Destination $bak -Force }
    $content = Get-Content $file.FullName -Raw
    # Elimina espacio final en src="URL "
    $content = [regex]::Replace($content, '(src\s*=\s*["''])([^"'']*?)\s+["'']', { param($m) $m.Groups[1].Value + $m.Groups[2].Value.TrimEnd() + '"' })
    # Elimina espacio final en SCRIPT_URL
    $content = [regex]::Replace($content, '(const\s+SCRIPT_URL\s*=\s*["''])([^"'']*?)\s+["'']', { param($m) $m.Groups[1].Value + $m.Groups[2].Value.TrimEnd() + '"' })
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}
Write-Host "✅ Limpieza completada. Copias de respaldo (.bak) creadas." -ForegroundColor Green