$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path reports | Out-Null

pytest sample_py > reports/test_output.txt 2>&1

Get-Content reports/test_output.txt

if ($LASTEXITCODE -ne 0) {
    exit 1
}