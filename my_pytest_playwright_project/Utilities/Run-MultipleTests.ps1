param(
    [string]$OrgId = "UJX",
    [string[]]$ProjectRoles = @("PUBLIC_USER", "PUBLIC_ADMIN", "PRIVATE_USER")
)

# Build if not already available
Write-Host "🛠️  Checking Docker image..."
if (-not (docker images -q excel-converter-playwright)) {
    Write-Host "📦 Building Docker image..."
    docker build -t excel-converter-playwright .
}

$jobs = @()

foreach ($entry in $ProjectRoles) {
    $parts = $entry.Split("_", 2)
    if ($parts.Count -ne 2) {
        Write-Warning "⚠️ Skipping invalid entry '$entry' (expected PROJECT_ROLE format)"
        continue
    }

    $project = $parts[0]
    $role    = $parts[1]

    $logDir  = "data\logs"
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    $logFile = Join-Path $logDir "$OrgId`_${project}_${role}_$(Get-Date -f 'yyyyMMdd_HHmmss').log"

    Write-Host "▶ Launching $OrgId $project $role in background..."

    $jobs += Start-Job -ScriptBlock {
        param($OrgId, $project, $role, $logFile)
        docker run --rm `
            -v "${pwd}/data:/app/data" `
            excel-converter-playwright $OrgId $project $role `
            *>&1 | Tee-Object -FilePath $logFile
    } -ArgumentList $OrgId, $project, $role, $logFile
}

Write-Host "`n⏳ Waiting for all jobs to complete..."
Wait-Job $jobs | Out-Null

Write-Host "`n✅ All conversions finished. Logs saved under data\logs"
