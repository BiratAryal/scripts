######################################################################
#
# This script will find the 10 (default) largest files and then list the
# folders sizes of the c:\ drive (default). The results will be written to a
# formatted text file. At the end of the script is an option to scan and list
# the size of all sub folders within a particular folder, output will be 
# appended to the txt file generated during the initial scan.
#
######################################################################

######################################################################
#
#  Another way to run in specific drive directly from powershell
#
###################################################################### 
#Get-ChildItem -r|sort -descending -property length | select -first 10 name, @{Name="Gigabytes";Expression={[Math]::round($_.length / 1GB, 2)}}

###################################################################
#Uncomment upper line gci -r .... for running in powershell, gives decimal output in GB but not directory of file listed.
###################################################################


# Modify these 3 variables as needed
 
# Output file location and name
$findFilesFoldersOutput = "D:\FindLargestFilesAndFolders.txt";
# Drive to Scan
$diskDrive = "D:"
# Limit number of rows on output, top XX files
$filesLimit = 20;
 
 
###################################
# Do not edit below!
###################################
# Misc settings
# Root location to scan for folder size
$filesLocation = "$diskDrive\";
$rootLocation = $filesLocation;
# Set output width
$outputWidth = 150;
# Minimum file size
$fileSize = 1GB;
# Search for specific file extensions - Default *.*
$extension = "*.*";
# Time stamp
$Time = Get-Date -format "dd-MMM-yyyy-HH-mm"
 
###################################
# Scan Drive for capacity and free space
###################################
 
Function driveScan {
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$diskDrive'" | Select-Object Size,FreeSpace
$total = "{0:N0}" -f ($disk.Size / 1GB) + " GB"
$free = "{0:N0}" -f ($disk.FreeSpace / 1GB) + " GB"
$freeMB = "{0:N0}" -f ($disk.FreeSpace / 1MB) + " MB"
Write-Host " "
write-host "Total capacity of $diskDrive - $total"
write-host "Total space free on $diskDrive - $free / $freeMb"
" " | out-file $findFilesFoldersOutput -append
"Total capacity of $diskDrive - $total" | out-file $findFilesFoldersOutput -append
"Total space free on $diskDrive - $free / $freeMb" | out-file $findFilesFoldersOutput -append
" " | out-file $findFilesFoldersOutput -append
" " | out-file $findFilesFoldersOutput -append
}   
 
###################################
# Top Largest Files Scan
###################################
 
Function fileScan {
Write-Host " "
Write-Host "Scanning $filesLocation for the $filesLimit largest files, this process will take a few minutes..."
"Below are the $filesLimit largest files on $filesLocation from largest to smallest:" | out-file -width $outputWidth $findFilesFoldersOutput -append
$largeSizefiles = get-ChildItem -path $filesLocation -include $Extension -recurse -ErrorAction "SilentlyContinue" | ? { $_.GetType().Name -eq "FileInfo" } | where-Object {$_.Length -gt $fileSize} | sort-Object -property length -Descending | Select-Object Name, @{Name="Size In GB";Expression={ "{0:N0}" -f ($_.Length / 1GB)}},@{Name="LastWriteTime";Expression={$_.LastWriteTime}},@{Name="Path";Expression={$_.directory}} -first $filesLimit
$largeSizefiles | format-list -property Name,"Size In GB",Path,LastWriteTime | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
Write-Host "File Scan Complete..."
Write-Host " "
}
 
###################################
# Top Largest Folders Scan
###################################
 
Function folderScan {
$subDirectories = Get-ChildItem $rootLocation | Where-Object{($_.PSIsContainer)} | foreach-object{$_.Name}
Write-Host "Calculating folder sizes for $rootLocation,"
Write-Host "this process will take a few minutes..."
"Estimated subfolder sizes for $rootLocation :" | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
" "  | out-file -width $outputWidth $findFilesFoldersOutput -append
$folderOutputFixed = @{}
foreach ($i in $subDirectories)
	{
	$targetDir = $rootLocation + $i
	$folderSize = (Get-ChildItem $targetDir -Recurse -Force | Measure-Object -Property Length -Sum).Sum 2> $null
    $folderSizeComplete = "{0:N0}" -f ($folderSize / 1MB) + "MB"
	$folderOutputFixed.Add("$targetDir" , "$folderSizeComplete")
	write-host " Calculating $targetDir..."
}
$folderOutputFixed.GetEnumerator() | sort-Object Name | format-table -autosize | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
Write-Host "Attempting to open scan results with notepad..."
c:\windows\system32\notepad.exe "$findFilesFoldersOutput"
Write-Host " "
Write-Host "Scan saved to: $findFilesFoldersOutput..."
Write-Host " "
}
 
###################################
# Custom Folder Scan
###################################
 
Function customScan {
Write-Host " "
write-host "Would you like to scan a specific directory for subfolder sizes?"
write-host "Ex C:\, C:\Windows"
write-host " "
write-host "Press CTRL + C to exit at any time."
write-host " "
$customLocation= Read-Host 'Please enter directory path here'
$subDirectories = Get-ChildItem $customLocation | Where-Object{($_.PSIsContainer)} | foreach-object{$_.Name}
Write-Host " "
Write-Host "Calculating folder sizes for $customLocation,"
Write-Host "this process will take a few minutes..."
" "  | out-file -width $outputWidth $findFilesFoldersOutput -append
"Estimated folder sizes for $customLocation :" | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
" "  | out-file -width $outputWidth $findFilesFoldersOutput -append
$folderOutput = @{}
foreach ($i in $subDirectories)
	{
	$targetDir = $customLocation + "\" + $i
	$folderSize = (Get-ChildItem $targetDir -Recurse -Force | Measure-Object -Property Length -Sum).Sum 2> $null
    $folderSizeComplete = "{0:N0}" -f ($folderSize / 1MB) + "MB" 
	$folderOutput.Add("$targetDir" , "$folderSizeComplete")
    write-host " Calculating $targetDir..."
}
$folderOutput.GetEnumerator() | sort-Object Name | format-table -autosize | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
Write-Host "Attempting to open scan results with notepad..."
c:\windows\system32\notepad.exe "$findFilesFoldersOutput"
Write-Host " "
Write-Host "Scan saved to: $findFilesFoldersOutput..."
Write-Host " "
customScan
}
 
# Pause
Function Pause {
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
 
# Clear the screen
clear
 
# Clear the output file if it exists by writing a timestamp
$time | out-file -width $outputWidth $findFilesFoldersOutput
 
# Execute the functions
# Comment out any of the below functions to prevent them from running
driveScan
fileScan
folderScan
customScan