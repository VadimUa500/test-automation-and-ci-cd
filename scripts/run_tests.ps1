param(
    [string]$cmd,
    [string]$out = "reports",
    [string]$format = "text",
    [string]$run_id,
    [string]$project = "unknown"
)

# перевірка cmd
if (-not $cmd) {
    Write-Host "Usage: --cmd 'py -m pytest -q'"
    exit 1
}

# run_id
if (-not $run_id) {
    $run_id = Get-Date -Format "yyyyMMdd_HHmmss"
}

# шляхи
$base = "$out/runs/$run_id"
$raw = "$base/raw"
$summary = "$base/summary"
$html = "$base/html"

# створення папок
New-Item -ItemType Directory -Force -Path $raw,$summary,$html | Out-Null

# запуск тестів
Write-Host "Running tests..."
cmd /c $cmd 2>&1 | Tee-Object "$raw/test_output.txt"
$exitCode = $LASTEXITCODE

# статус
$status = if ($exitCode -eq 0) { "SUCCESS" } else { "FAIL" }
$status | Out-File "$summary/status.txt"

# статистика
$fails = (Select-String "$raw/test_output.txt" -Pattern "FAILED").Count
$errs = (Select-String "$raw/test_output.txt" -Pattern "ERROR").Count

"FAILED: $fails" | Out-File "$summary/stats.txt"
"ERROR: $errs" | Out-File "$summary/stats.txt" -Append

# meta
@"
Project: $project
Run ID: $run_id
Date: $(Get-Date)
Command: $cmd
"@ | Out-File "$summary/meta.txt"

# report.txt
$report = "$base/report.txt"

@"
Project: $project
Date: $(Get-Date)
Command: $cmd
Status: $status
Log: $raw/test_output.txt

FAILED: $fails
ERROR: $errs
"@ | Out-File $report

# HTML
if ($format -eq "html") {
    @"
<html>
<body>
<h1>Test Report</h1>
<p>Status: $status</p>
<p>Command: $cmd</p>
<p>FAILED: $fails</p>
<p>ERROR: $errs</p>
<p>Log: $raw/test_output.txt</p>
</body>
</html>
"@ | Out-File "$html/report.html"
}

# exit code
if ($exitCode -ne 0) {
    exit $exitCode
}