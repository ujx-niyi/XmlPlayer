<#
.SYNOPSIS
    Runs Excel→XML→HTML→PDF conversion, pytest execution, and Allure report generation.
#>

param(
    [Parameter(Mandatory = $true)] [string]$OrgId,
    [Parameter(Mandatory = $true)] [string]$Project,
    [Parameter(Mandatory = $true)] [string]$Role
)

# ──────────────────────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────────────────────
$ProjectRoot = "C:\Projects\XmlPlay\my_pytest_playwright_project"
$ImageName   = "excel-converter-playwright"
$DataPath    = Join-Path $ProjectRoot "data"
$AllureResults = Join-Path $ProjectRoot "allure-results"
$AllureReport  = Join-Path $ProjectRoot "allure-report"

# ──────────────────────────────────────────────────────────────
# Utility: Ensure folder exists
# ──────────────────────────────────────────────────────────────
function Ensure-Folder([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

Ensure-Folder $AllureResults
Ensure-Folder $AllureReport

# ──────────────────────────────────────────────────────────────
# Docker health check
# ──────────────────────────────────────────────────────────────
Write-Host "`n🩺 Checking Docker daemon status..."
try {
    docker info | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not reachable"
    }
    Write-Host "✅ Docker engine is running."
}
catch {
    Write-Error "❌ Docker Desktop is not ready. Start Docker Desktop and rerun."
    exit 1
}

# ──────────────────────────────────────────────────────────────
# Ensure image exists
# ──────────────────────────────────────────────────────────────
Write-Host "`n🛠️  Checking Docker image..."
$exists = docker images -q $ImageName
if (-not $exists) {
    Write-Host "📦 Building Docker image '$ImageName'..."
    docker build -t $ImageName $ProjectRoot
} else {
    Write-Host "✅ Docker image '$ImageName' already available."
}

# ──────────────────────────────────────────────────────────────
# 1️⃣ Excel → XML → HTML → PDF
# ──────────────────────────────────────────────────────────────
Write-Host "`n▶ Running Excel→XML→HTML→PDF conversion..."
docker run --rm `
    -v "${DataPath}:/app/data" `
    $ImageName `
    $OrgId $Project $Role

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Conversion failed. Check logs in data/output."
    exit 1
}

# ──────────────────────────────────────────────────────────────
# 2️⃣ Run pytest with Allure reporting
# ──────────────────────────────────────────────────────────────
Write-Host "`n🧪 Executing pytest with Allure reporting..."
docker run --rm `
    -v "${DataPath}:/app/data" `
    -v "${AllureResults}:/app/allure-results" `
    $ImageName `
    pytest --alluredir=/app/allure-results

if ($LASTEXITCODE -ne 0) {
    Write-Warning "⚠️  Some tests failed. Allure report will still be generated."
}

# ──────────────────────────────────────────────────────────────
# 3️⃣ Generate Allure report
# ──────────────────────────────────────────────────────────────
Write-Host "`n📊 Generating Allure report..."
docker run --rm `
    --entrypoint bash `
    -v "${AllureResults}:/app/allure-results" `
    -v "${AllureReport}:/app/allure-report" `
    $ImageName `
    -c "allure generate /app/allure-results --clean -o /app/allure-report"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n🎉 Allure report successfully generated in: $AllureReport"
} else {
    Write-Error "❌ Failed to generate Allure report."
}
