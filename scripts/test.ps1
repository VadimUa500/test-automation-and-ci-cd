$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path reports | Out-Null

pytest

pytest > reports/test_output.txt 2>&1

if ($LASTEXITCODE -ne 0) {
    exit 1
}