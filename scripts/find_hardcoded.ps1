param(
    [string]$Path = 'lib'
)
# Find Text() widgets with a hardcoded string literal (single or double quoted)
# as the first argument, reporting file + line.
$files = Get-ChildItem -Recurse -Path $Path -Filter *.dart | Select-Object -ExpandProperty FullName
$total = 0
foreach ($f in $files) {
    $lines = Get-Content -LiteralPath $f -ErrorAction SilentlyContinue
    if (-not $lines) { continue }
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        # Match Text( 'lit'  or  Text("lit"
        if ($line -match "Text\(\s*['""][A-Za-z]") {
            Write-Output ("{0}:L{1}: {2}" -f $f, ($i + 1), $line.Trim())
            $total++
        }
    }
}
Write-Output ("TOTAL: {0}" -f $total)
