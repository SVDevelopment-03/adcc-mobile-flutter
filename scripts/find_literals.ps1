param(
    [string]$Path = 'lib'
)
# Comprehensive scan: find any string literal containing letters inside common UI patterns.
# Patterns: Text('  /  const Text(" /  "text in lists /  reasons = [  /  list items
$files = Get-ChildItem -Recurse -Path $Path -Filter *.dart | Select-Object -ExpandProperty FullName
foreach ($f in $files) {
    $raw = Get-Content -LiteralPath $f -Raw -ErrorAction SilentlyContinue
    if (-not $raw) { continue }
    $lines = $raw -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        # catch:  'Some words'  or  "Some words"  as a standalone string (list item, Text child, etc.)
        if ($line -match "['""][^'""]{2,}[A-Za-z][^'""]*['""]") {
            # skip obvious non-UI lines (imports, comments, keys)
            if ($line -match "^\s*(import|//|//\/|package:)" ) { continue }
            Write-Output ("{0}:L{1}: {2}" -f $f, ($i + 1), $line.Trim())
        }
    }
}
