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
#$commands = @'
#    $env:username
#    ssh-keygen -t rsa -b 4096 -f C:\Users\$env:username\.ssh\jump-keys -C jump-key
#'@
# Start-Process Powershell -LoadUserProfile -Credential $Cred -wait -ArgumentList '-Command',"ssh-keygen -t rsa -b 4096 -f C:\Users\$env:username\.ssh\$Username-jump-keys -C $env:username"
Start-Process Powershell "-Command Read-host((whoami))" -LoadUserProfile -NoNewWindow .\assessment_guide.md-Credential $Cred -wait
Start-Process Powershell "-Command ssh-keygen -t rsa -b 4096 -f C:\Users\$env:username\.ssh\$Username-jump-keys -C $env:username" -LoadUserProfile -NoNewWindow -Credential $Cred -wait
# log off
Write-Host "When ready, reboot!"
