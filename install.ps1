# dalgurum-claude-team 설치 스크립트 (Windows PowerShell)

$ErrorActionPreference = "Stop"

$ClaudeDir = "$env:USERPROFILE\.claude"
$SkillsDir = "$ClaudeDir\skills"
$AgentsDir = "$ClaudeDir\agents"

Write-Host "🚀 dalgurum-claude-team 설치를 시작합니다..." -ForegroundColor Cyan
Write-Host ""

# ~/.claude 디렉토리 생성
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $AgentsDir | Out-Null

# Skills 설치
Write-Host "📦 Skills 설치 중..." -ForegroundColor Yellow

Get-ChildItem -Path "skills" -Directory | ForEach-Object {
    $skillName = $_.Name
    $source = $_.FullName
    $target = "$SkillsDir\$skillName"

    if (Test-Path $target) {
        $answer = Read-Host "  ⚠️  $skillName — 이미 존재합니다. 덮어쓸까요? (y/N)"
        if ($answer -ne "y" -and $answer -ne "Y") {
            Write-Host "  ⏭️  $skillName — 건너뜁니다" -ForegroundColor Gray
            return
        }
        Remove-Item -Recurse -Force $target
    }

    Copy-Item -Recurse -Force $source $target
    Write-Host "  ✅ $skillName" -ForegroundColor Green
}

# Agents 설치
Write-Host ""
Write-Host "🤖 Agents 설치 중..." -ForegroundColor Yellow

Get-ChildItem -Path "agents" -Filter "*.md" | ForEach-Object {
    $agentName = $_.Name
    $source = $_.FullName
    $target = "$AgentsDir\$agentName"

    if (Test-Path $target) {
        $answer = Read-Host "  ⚠️  $agentName — 이미 존재합니다. 덮어쓸까요? (y/N)"
        if ($answer -ne "y" -and $answer -ne "Y") {
            Write-Host "  ⏭️  $agentName — 건너뜁니다" -ForegroundColor Gray
            return
        }
    }

    Copy-Item -Force $source $target
    Write-Host "  ✅ $agentName" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ 설치 완료!" -ForegroundColor Green
Write-Host ""
Write-Host "설치 위치:"
Write-Host "  Skills : $SkillsDir"
Write-Host "  Agents : $AgentsDir"
Write-Host ""
Write-Host "설치된 Skills:"
Get-ChildItem -Path "skills" -Directory | ForEach-Object {
    Write-Host "  - $($_.Name)"
}
Write-Host ""
Write-Host "설치된 Agents:"
Get-ChildItem -Path "agents" -Filter "*.md" | ForEach-Object {
    Write-Host "  - $($_.BaseName)"
}
Write-Host ""
Write-Host "Claude Code를 재시작하면 적용됩니다." -ForegroundColor Cyan
