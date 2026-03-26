$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path reports | Out-Null

cd sample_py
pytest test_math.py > ../reports/test_output.txt 2>&1

cd ..

Get-Content reports/test_output.txt

if ($LASTEXITCODE -ne 0) {
    exit 1
}