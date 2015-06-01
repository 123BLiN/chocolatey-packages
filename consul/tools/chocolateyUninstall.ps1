$nssmVersion = '2.24'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$service = Get-Service "consul" -ErrorAction SilentlyContinue

if ($service) {
	if ($service.Status -eq "Running") {
		Write-Host "Stopping consul process ..."
		net stop consul | Out-Null
	}

	$service = Get-WmiObject -Class Win32_Service -Filter "Name='consul'"
	$service.delete() | Out-Null

}

Write-Host "Removing C:\ProgramData\consul\ ..."
takeown /f "C:\ProgramData\consul\" /a /r /d Y | Out-Null
icacls "C:\ProgramData\consul" /grant administrators:F /t | Out-Null
Remove-Item -Path "C:\ProgramData\consul\" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
