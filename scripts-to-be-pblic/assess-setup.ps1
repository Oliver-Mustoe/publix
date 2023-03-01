#Requires -RunAsAdministrator
# Install OpenSSH , does not install if "ssh" folder exists
if (!(Test-Path "C:\ProgramData\ssh\ssh_host_rsa_key")) {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

# Start now and on startup
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# Make named user
$Username = Read-Host -prompt "What is the named administrative user you want to create?"
$Password = Read-Host -prompt "What is the password for this user?" -AsSecureString
$hostname = Read-Host -prompt "What is the hostname of this box supposed to be?"
New-LocalUser $Username -Password $Password -AccountNeverExpires -PasswordNeverExpires:$true
Add-LocalGroupMember -Group "Administrators" -Member $Username
$cred = New-Object System.Management.Automation.PSCredential $username, $Password

# Rename computer
Rename-Computer -NewName $hostname

# Add ssh-keys
Start-Process Powershell -LoadUserProfile -Credential $Cred -NoNewWindow -wait -ArgumentList'-Command',"ssh-keygen -t rsa -b 4096 -f C:\Users\$Username\.ssh\$hostname-jump-keys -C $hostname"

# log off
Write-Host "Logging off"
logoff.exe
