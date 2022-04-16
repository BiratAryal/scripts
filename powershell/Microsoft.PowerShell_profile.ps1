#for changing appearance of powershell 
Import-Module -Name oh-my-posh
oh-my-posh --init --shell pwsh --config C:\Scripts\powershell\birat.omp.json | Invoke-Expression

#For Icons
Import-Module -Name Terminal-Icons

#For autocompletion
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

#Remove Duplicates
Set-PSReadLineOption –HistoryNoDuplicates:$True

#Alias for normal use
Set-Alias -Name grep -Value Select-String
Set-Alias -Name ifconfig -Value ipconfig
Set-Alias -Name touch -Value New-Item
Set-Alias -Name vim -Value nvim
Set-Alias -Name ll -Value Get-ChildItem
function wrkspc {code C:\Scripts\VSCode-docker-workspace.code-workspace}
function update-remove {& 'C:\Softwares\Update&Remove.ps1'}
function lsr {Get-ChildItem -Recurse}
function git-log {Get-Content C:\Logs\script_logs.txt}
#Utilities
function which ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
		Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
	}
Set-Alias -Name file -Value explorer.exe
#function file ($location) {
#	explorer.exe	
#	}
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#personal use only also example of fping
#sends packets with size 100 to 115
#function google {fping www.google.com -S 100/115}
#to check (throughput) how large amount of package a system/switch could handle
#function google {fping www.google.com -t 10 -c}
