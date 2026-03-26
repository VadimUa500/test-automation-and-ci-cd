Write-Host "Running check..."

.\scripts\run_tests.ps1 -cmd "cd sample_py && py -m pytest -q" -format html -project my_project