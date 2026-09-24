Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   Git Push + Split APK Auto Version" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

# =========================================
# APP NAME
# =========================================

$APP_NAME = "Alif-Ecommmerce"

# =========================================
# CHECK REQUIRED COMMANDS
# =========================================

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Git not found in PATH" -ForegroundColor Red
    exit 1
}
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Flutter not found in PATH" -ForegroundColor Red
    exit 1
}
# if (-not (Get-Command fvm -ErrorAction SilentlyContinue)) {
#     Write-Host "ERROR: FVM not found in PATH" -ForegroundColor Red
#     exit 1
# }

Write-Host "Git and FLUTTER found." -ForegroundColor Green

# =========================================
# CHECK GIT REPO
# =========================================

git rev-parse --is-inside-work-tree 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Not inside a Git repository." -ForegroundColor Red
    exit 1
}

# =========================================
# CHECK PUBSPEC
# =========================================

$PUBSPEC = "pubspec.yaml"

if (-not (Test-Path $PUBSPEC)) {
    Write-Host "ERROR: pubspec.yaml not found." -ForegroundColor Red
    exit 1
}

# =========================================
# READ VERSION
# =========================================

$versionLine = Select-String -Path $PUBSPEC -Pattern "^version:"

if (-not $versionLine) {
    Write-Host "ERROR: version not found in pubspec.yaml." -ForegroundColor Red
    exit 1
}

$currentVersion = ($versionLine.Line -split "\s+")[1]

Write-Host ""
Write-Host "Current Version : $currentVersion" -ForegroundColor Yellow

# =========================================
# PARSE VERSION
# =========================================

$versionParts = $currentVersion.Split("+")

$versionName = $versionParts[0]

if ($versionParts.Count -gt 1) {
    $buildNumber = [int]$versionParts[1]
}
else {
    $buildNumber = 0
}

$versionNumbers = $versionName.Split(".")

if ($versionNumbers.Count -ne 3) {
    Write-Host "ERROR: Version must look like 1.2.3+4" -ForegroundColor Red
    exit 1
}

$major = [int]$versionNumbers[0]
$minor = [int]$versionNumbers[1]
$patch = [int]$versionNumbers[2]

# =========================================
# AUTO INCREMENT
# =========================================

$patch = $patch + 1
$buildNumber = $buildNumber + 1

$newVersion = "$major.$minor.$patch+$buildNumber"
$apkVersion = "$major.$minor.$patch"

Write-Host "New Version     : $newVersion" -ForegroundColor Green

# =========================================
# UPDATE PUBSPEC
# =========================================

$content = Get-Content $PUBSPEC -Raw

$content = $content -replace "(?m)^version:.*$", "version: $newVersion"

Set-Content -Path $PUBSPEC -Value $content -Encoding UTF8

Write-Host "pubspec.yaml updated." -ForegroundColor Green

# =========================================
# SELECT REMOTE
# =========================================

$remotes = @(git remote)

if ($remotes.Count -eq 0) {

    Write-Host ""
    Write-Host "No Git remote found." -ForegroundColor Yellow

    $remote = Read-Host "Remote name (origin)"

    if ([string]::IsNullOrWhiteSpace($remote)) {
        $remote = "origin"
    }

    $remoteUrl = Read-Host "Remote URL"

    if ([string]::IsNullOrWhiteSpace($remoteUrl)) {
        Write-Host "ERROR: Remote URL required." -ForegroundColor Red
        exit 1
    }

    git remote add $remote $remoteUrl

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Could not add remote." -ForegroundColor Red
        exit 1
    }
}
else {

    Write-Host ""
    Write-Host "Available Git remotes:" -ForegroundColor Cyan

    for ($i = 0; $i -lt $remotes.Count; $i++) {
        Write-Host "[$($i + 1)] $($remotes[$i])"
    }

    $remoteChoice = Read-Host "Select remote number (Enter = first)"

    if ([string]::IsNullOrWhiteSpace($remoteChoice)) {

        $remote = $remotes[0]

    }
    else {

        $remoteIndex = [int]$remoteChoice - 1

        if ($remoteIndex -lt 0 -or $remoteIndex -ge $remotes.Count) {
            Write-Host "ERROR: Invalid remote selection." -ForegroundColor Red
            exit 1
        }

        $remote = $remotes[$remoteIndex]
    }
}

Write-Host "Using remote: $remote" -ForegroundColor Green

# =========================================
# SELECT BRANCH
# =========================================

$branches = @(git branch --format="%(refname:short)")

if ($branches.Count -eq 0) {

    Write-Host ""
    Write-Host "No branch found." -ForegroundColor Yellow

    $branch = Read-Host "Create branch name (main)"

    if ([string]::IsNullOrWhiteSpace($branch)) {
        $branch = "main"
    }

    git checkout -b $branch

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Could not create branch." -ForegroundColor Red
        exit 1
    }

}
else {

    $currentBranch = git rev-parse --abbrev-ref HEAD

    Write-Host ""
    Write-Host "Current branch: $currentBranch" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Available branches:" -ForegroundColor Cyan

    for ($i = 0; $i -lt $branches.Count; $i++) {

        if ($branches[$i] -eq $currentBranch) {
            Write-Host "[$($i + 1)] $($branches[$i])  <current>"
        }
        else {
            Write-Host "[$($i + 1)] $($branches[$i])"
        }
    }

    $branchChoice = Read-Host "Select branch number (Enter = current)"

    if ([string]::IsNullOrWhiteSpace($branchChoice)) {

        $branch = $currentBranch

    }
    else {

        $branchIndex = [int]$branchChoice - 1

        if ($branchIndex -lt 0 -or $branchIndex -ge $branches.Count) {
            Write-Host "ERROR: Invalid branch selection." -ForegroundColor Red
            exit 1
        }

        $branch = $branches[$branchIndex]

        if ($branch -ne $currentBranch) {

            git checkout $branch

            if ($LASTEXITCODE -ne 0) {
                Write-Host "ERROR: Could not checkout branch." -ForegroundColor Red
                exit 1
            }
        }
    }
}

Write-Host "Using branch: $branch" -ForegroundColor Green

# =========================================
# COMMIT MESSAGE
# =========================================

Write-Host ""

$commit = Read-Host "Commit message"

if ([string]::IsNullOrWhiteSpace($commit)) {
    Write-Host "ERROR: Commit message required." -ForegroundColor Red
    exit 1
}

$addTime = Read-Host "Add timestamp suffix? (Y/n)"

if ([string]::IsNullOrWhiteSpace($addTime)) {
    $addTime = "Y"
}

if ($addTime -match "^[Yy]$") {

    $time = Get-Date -Format "hh:mm:ss tt"

    # IMPORTANT:
    # Do NOT put a literal pipeline character inside
    # a double quoted PowerShell expression.
    $commit = $commit + " | " + $time
}

Write-Host "Commit message: $commit" -ForegroundColor Cyan

# =========================================
# FLUTTER CLEAN
# =========================================

Write-Host ""
Write-Host "Cleaning Flutter project..." -ForegroundColor Cyan

 flutter clean

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Flutter clean failed." -ForegroundColor Red
    exit 1
}

# =========================================
# FLUTTER PUB GET
# =========================================

Write-Host ""
Write-Host "Getting Flutter packages..." -ForegroundColor Cyan

flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Flutter pub get failed." -ForegroundColor Red
    exit 1
}

# =========================================
# BUILD SPLIT APK
# =========================================

Write-Host ""
Write-Host "Building Split APK..." -ForegroundColor Cyan
Write-Host "Version: $newVersion" -ForegroundColor Yellow

 flutter build apk --split-per-abi

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: APK build failed." -ForegroundColor Red
    exit 1
}

# =========================================
# APK DIRECTORY
# =========================================

$APK_DIR = "build\app\outputs\flutter-apk"

if (-not (Test-Path $APK_DIR)) {
    Write-Host "ERROR: APK directory not found." -ForegroundColor Red
    exit 1
}

# =========================================
# FIND ARM64 APK
# =========================================

Write-Host ""
Write-Host "Finding ARM64 APK..." -ForegroundColor Cyan

$targetApk = Get-ChildItem `
    -Path $APK_DIR `
    -Filter "*arm64-v8a*.apk" `
    -File |
    Select-Object -First 1

# =========================================
# FALLBACK APK
# =========================================

if (-not $targetApk) {

    Write-Host "ARM64 APK not found. Searching any APK..." -ForegroundColor Yellow

    $targetApk = Get-ChildItem `
        -Path $APK_DIR `
        -Filter "*.apk" `
        -File |
        Select-Object -First 1
}

if (-not $targetApk) {
    Write-Host "ERROR: No APK found." -ForegroundColor Red
    exit 1
}

# =========================================
# COPY / RENAME APK
# =========================================

$newName = "$APP_NAME-v$apkVersion.apk"

$newPath = Join-Path $APK_DIR $newName

Copy-Item `
    -Path $targetApk.FullName `
    -Destination $newPath `
    -Force

Write-Host ""
Write-Host "APK created:" -ForegroundColor Green
Write-Host "$newName" -ForegroundColor Green

# =========================================
# GIT ADD
# =========================================

Write-Host ""
Write-Host "Adding files to Git..." -ForegroundColor Cyan

git add .

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: git add failed." -ForegroundColor Red
    exit 1
}

# =========================================
# CHECK CHANGES
# =========================================

git diff --cached --quiet

if ($LASTEXITCODE -eq 0) {
    Write-Host "WARNING: Nothing to commit." -ForegroundColor Yellow
    exit 0
}

# =========================================
# GIT COMMIT
# =========================================

Write-Host ""
Write-Host "Creating Git commit..." -ForegroundColor Cyan

git commit -m "$commit"

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Git commit failed." -ForegroundColor Red
    exit 1
}

# =========================================
# GIT PUSH
# =========================================

Write-Host ""
Write-Host "Pushing to Git..." -ForegroundColor Cyan

git push -u $remote $branch

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Git push failed." -ForegroundColor Red
    exit 1
}

# =========================================
# COMPLETE
# =========================================

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Code pushed!" -ForegroundColor Green
Write-Host "Remote : $remote" -ForegroundColor Green
Write-Host "Branch : $branch" -ForegroundColor Green
Write-Host "Version: $newVersion" -ForegroundColor Green
Write-Host "APK    : $newName" -ForegroundColor Green
Write-Host "Folder : $APK_DIR" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan