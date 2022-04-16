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
#Allias for Official Production environment
function vianet {fping 110.44.116.20 110.44.116.18 -c |foreach {"{0} - {1}" -f (Get-Date),$_}}
function subishu {fping 182.93.68.2 182.93.68.4 -c}
function nots {fping 182.93.68.2 110.44.116.18 -n 4 -b}
function website {fping 110.44.116.20 182.93.68.4 -n 4 -b}
function notsweb {fping 182.93.68.2 110.44.116.18 182.93.68.4 110.44.116.20 -c -b}
#Nepse to DH
function df-nep-dh {fping -b 192.168.88.1 192.168.88.2 -n 4 -b}
#------->failover
function sub-nep-dh {fping -b 192.168.77.1 192.168.77.2 -n 4 -b}
function web-nep-dh {fping -b 192.168.33.1 192.168.33.2 -n 4 -b}
#Nepse to DR
function dr-nep {fping 192.168.10.2 192.168.10.1 -n 4 -b}
#Esxi
function esxi {fping 172.16.11.30 172.16.11.31 172.16.11.32 172.16.11.33 -n 4 -b}
#Esxi 1
function esxi01 {fping 172.16.11.30 172.16.10.236 172.16.10.242 172.16.11.3 172.16.11.11 172.16.11.28 172.16.11.45 172.16.11.55 172.16.11.250 -n 2 -b} 
#Esxi 2
function esxi02 {fping 172.16.11.31 172.16.10.226 172.16.10.227 172.16.11.29 172.16.11.26 172.16.11.35 172.16.11.39 172.16.11.41 172.16.11.44 172.16.11.54 -n 2 -b}
#Esxi 3
function esxi03 {fping 172.16.11.32 172.16.11.2 172.16.11.4 172.16.11.10 172.16.11.16 172.16.11.27 172.16.11.36 172.16.11.42 172.16.37.226 172.16.37.228 172.16.11.251 -n 2 -b}
#Esxi 4
function esxi04 {fping 172.16.11.33 172.16.11.5 172.16.11.12 172.16.11.17 172.16.11.18 172.16.11.25 172.16.11.98 172.16.10.228 -n 2 -b}
#DR Vianet & SUBISHU
function dr-via-sub {fping 110.44.116.29 163.53.25.20 -n 4 -b}
#VRA clusters and datastores
function vra {fping 172.16.11.41 -n 4 -b}
#WAF
function waf {fping -a -r 1 -g 10.23.23.0/10.23.23.255 -b}
#Staging
function stage {fping 110.44.116.22 -b}
#iDRAC Nots Starts from wall to door
function idrac-nots {fping 172.24.24.81 172.24.24.82 172.24.24.83 172.24.24.84 -n 3 -b}
#migration check
function nots-srv-01 {fping 172.16.11.2 172.16.11.4 172.16.11.10 172.16.11.16 172.16.11.19 172.16.11.32 172.16.11.36 172.16.37.228 172.16.37.226 172.16.10.241 172.16.11.250 -n 3 -b}
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#personal use only also example of fping
#sends packets with size 100 to 115
#function google {fping www.google.com -S 100/115}
#to check (throughput) how large amount of package a system/switch could handle
#function google {fping www.google.com -t 10 -c}
