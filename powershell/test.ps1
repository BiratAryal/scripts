#dummyfile with 1GB (useful)
fsutil file createnew C:\dummy.txt 1073741824
#for calculating bandwidth using netstat
$bandwidth = netstat -e
$new = $bandwidth | select -Skip 4 -First 1|ConvertFrom-String|select @{n='P2(B/s)';e={[int]($_.P2/1024)}}
echo "the download speed is:"$new
echo $bandwidth
ipconfig | grep Signal
# *******************************************************************************************************
# Port scan for windows start
# *******************************************************************************************************
$value1=Read-Host "Enter the starting port";
$value2=Read-Host "Enter the ending port";
$hostaddress=Read-Host "Enter the ip address you want to scan"
$value1..$value2|ForEach-Object{Write-Output "Port $_ scan result";Test-Connection -TcpPort $_ $hostaddress};
79..80|ForEach-Object{echo "port scan result of port: $_";Test-Connection -TcpPort $_ www.google.com}
# *******************************************************************************************************
# Port scan for windows end
# ******************************************************************************************************* 
#Param([Parameter(Mandatory=$True,Position=2)][String]$Name,[Parameter(Mandatory=$True,Position=1)][String]$Greeeting)
#Write-Host $Greeeting $Name

#netstat -e $username| Select -expand memberof | select @{n='GroupName';e={$_.split(',')[0].Substring(3)}} -expand GroupName

#$server_event = Get-Content -Path "D:\Server.txt"

#foreach($servers in $server_event)
#{

#$event = Get-EventLog -computerName $servers -logname system | Where-Object {$_.EventID -eq 6009} | Select TimeGenerated -First 1

#$event

#} 
#Create 1G file with your desired text
#echo "This is just a sample line appended  to create a big file. " > dummy.txt 
#for /L %i in (1,1,24)do type dummy.txt >> dummy.txt

