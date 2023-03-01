# publix
Commands to run **(ADMINISTRATIVE POWERSHELL)**
```powershell
New-NetIPAddress -InterfaceIndex 0 -IPAddress 10.0.17.25 -PrefixLength 24 -DefaultGateway 10.0.17.2
Set-DnsClientServerAddress -InterfaceIndex 0 -ServerAddresses ("10.0.17.2")
wget  -Outfile assess-setup.ps1
Unblock-File .\assess-setup.ps1
Set-ExecutionPolicy -scope process unrestricted
.\assess-setup.ps1
```
