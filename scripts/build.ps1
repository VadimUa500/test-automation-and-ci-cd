$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path artifacts | Out-Null

$time = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"

try {
    $commit = git rev-parse --short HEAD
} catch {
    $commit = "unknown"
}

"build_time: $time" | Out-File artifacts/build_info.txt
"commit: $commit" | Out-File artifacts/build_info.txt -Append
"project: test-automation-and-ci-cd" | Out-File artifacts/build_info.txt -Append
"version: 1.0.0" | Out-File artifacts/build_info.txt -Append