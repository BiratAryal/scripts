#dummyfile with 1GB (useful)
fsutil file createnew D:\delete_directory\download-test\dummy.txt 1073741824
#for calculating bandwidth using netstat
$bandwidth = netstat -e
$new = $bandwidth | select -Skip 4 -First 1|ConvertFrom-String|select @{n='P2(B/s)';e={[int]($_.P2/1024)}}
echo "the download speed is:"$new
echo $bandwidth
ipconfig | grep Signal
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

