#****************************************************
#** Author: Birat Aryal                            **
#** Email: birataryal1998@gmail.com                **
#** Created date: 03/19/2022                       **
#** Supported OS: Windows                          **
#** Purpose: Deployment of BOSS                    **
#*****************************************************
#=============================================================================================================================
#=============================================================================================================================
#                                    Index:
# 1. Archive
#    1.1 Create Archive of the publish file ----
#    1.2 Extract Archive -------
# 2. IIS ------
#    2.1 Stop Site ------
#    2.2 Take port number
# 3. Text add/change inside config file ------
#    3.1 Change version info -------
#    3.2 Insert servername, databasename, sftpdetails ------
# 4. Download files from github ------
# 5. Take backup of sql server
# 6. Run Query 
#    5.1 All version query in sequential order
#    5.2 Create Database --------
# 7. Application Pool creation -----
# 8. Full Permission to the directory for 2 users -----
# 9. Create Website ----
#    9.1 Create website based on application pool -----
#    9.2 Asssign port number -----
# 10. Install files silently ---------
#=============================================================================================================================
#=============================================================================================================================
#                                   Stop and start IIS website
#Print column of the site.
#Get-ChildItem IIS:\Sites\ | Format-Wide -Property Physical*
$main_boss_website_name = Read-Host -Prompt 'Enter main boss website name [Case Sensitive]: '
Stop-IISSite -Name $main_boss_website_name -Confirm:$false
#=============================================================================================================================
#=============================================================================================================================
#                                        Create Archive
#               For creating archive except selective files start
#*****************************************************************************************************************************
#Target Path
$path = "E:\Scripts"
#Construct archive path
$DateTime = (Get-Date -Format "yyyyMMddHHmmss")
$destination = Join-Path $path ".\Boss_backup-$DateTime.zip"
#exclusion rules.
$exclude = @("Uploads","log","*.zip")
#get files to compress using exclusion filter
$files = Get-ChildItem -Path $path -Exclude $exclude
#Unzip file
Compress-Archive -Path $files -DestinationPath $destination -CompressionLevel Fastest
#*****************************************************************************************************************************
#*****************************************************************************************************************************
# Extract Archive
Expand-Archive -Path '.\Deployment_files.zip' -DestinationPath '.'
#*****************************************************************************************************************************
#*****************************************************************************************************************************
#=============================================================================================================================
#           Download file from github, from website hosting bundle and redistributable
#=============================================================================================================================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$source_code_url = 'https://github.com/BiratAryal/scripts/raw/master/powershell.zip'
$script_dir = $((Get-Location|Format-Table -HideTableHeaders|Out-String).Trim())+'\Deployment_files.zip'
$Destination = $script_dir
$web = New-Object -TypeName System.Net.WebClient
$web.DownloadFile($source_code_url,$Destination)
#Moving directories and replacing
#using copy-item because move-item doesnot replace directory. need to later on remove this directory
Copy-Item -Path '.\boss_jobs_versions\1.0.3\publish\*' -Destination '.\delete' -Force -Recurse
Copy-Item -Path '.\boss_versions\4.0.0.8\Publish\*' -Destination '.\delete' -Force -Recurse
#Remove-Item -Path '.\another directory' -Recurse
#*****************************************************************************************************************************
#                         Creating archive script stop
#*****************************************************************************************************************************
#=============================================================================================================================
#=============================================================================================================================
#           Download file from website hosting bundle and redistributable
#=============================================================================================================================
#*****************************************************************************************************************************
#                                            .net core 5 hosting bundle 
#*****************************************************************************************************************************
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$download_hosting_bundle = "https://download.visualstudio.microsoft.com/download/pr/d7d20e41-4bee-4f8a-a32c-278f0ef8ce1a/f5a0c59b42d01b9fc2115615c801866c/dotnet-hosting-5.0.15-win.exe"
$download_path_hosting_bundle = $((Get-Location|Format-Table -HideTableHeaders|Out-String).Trim())+'\hosting_bundle.exe'
$destination_hosting_bundle = $download_path_hosting_bundle
$web = New-Object -TypeName System.Net.WebClient
$web.DownloadFile($download_hosting_bundle,$destination_hosting_bundle)
#*****************************************************************************************************************************
#                                            visual c++ redistributable 32 bit
#*****************************************************************************************************************************
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$download_vc_redist = "https://aka.ms/vs/17/release/vc_redist.x86.exe"
$download_path_vc_redist = $((Get-Location|Format-Table -HideTableHeaders|Out-String).Trim())+'\vc_redist.exe'
$destination_vc_redist = $download_path_vc_redist
$web = New-Object -TypeName System.Net.WebClient
$web.DownloadFile($download_vc_redist,$destination_vc_redist)
#=============================================================================================================================
#=============================================================================================================================
#                         Changing files inside text document
#*****************************************************************************************************************************
#                           Variables declaration for changing inside file.
#*****************************************************************************************************************************
$boss_job_file = ".\appsettings.json"
$boss_srv_name_find = '(?<=Data Source=)'
$boss_db_name_find = '(?<=Initial Catalog=)'
$boss_db_name_add = Read-Host -Prompt "database_name"
$version_change_file = ".\AppSetting.config"
$version_find = '(?<=<add key="build" value=")[^"]*'
#$version_change = Read-Host -Prompt "Enter version name in format x.x.x"
$version_change = '4.0.0.8'
$sftp_host_match = '(?<=    "Host": ")'
$sftp_host_add = 'sftp.nepsetms.com.np'
$sftp_username_match = '?<=    "UserName": ")'
$sftp_username_add = Read-Host -Prompt 'Enter Username for sftp'
$port_number_find = '(?<="uri": "http://localhost:)[^"]*'
$sftp_password_match = '(?<=    "Password": ")'
$sftp_password_add = Read-Host -Prompt "Enter encrypted password for user"
$port_number_change = Read-Host -Prompt 'Enter Port number as that of boss'
$database_name = 'db_boss_jobs'
#Replace previous version with the new version
(Get-Content $version_change_file) -replace ($version_find, $version_change) | Set-Content $version_change_file
#Add Server Name
#(Get-Content $boss_job_file) -replace ($boss_srv_name_find, $env:COMPUTERNAME) | Set-Content $boss_job_file
#Add DB_Name
#(Get-Content $boss_job_file) -replace ($boss_db_name_find, $boss_db_name_add) | Set-Content $boss_job_file
#add sftp host
(Get-Content $boss_job_file) -replace ($sftp_host_match, $sftp_host_add)| Set-Content $boss_job_file
#Add Username to the sftp details
(Get-Content $boss_job_file) -replace ($sftp_username_match, $sftp_username_add)| Set-Content $boss_job_file
#Add Password to the sftp details
(Get-Content $boss_job_file) -replace ($sftp_password_match, $sftp_password_add)| Set-Content $boss_job_file
#(Get-Content $version_change_file) -replace ($sftp_match, $sftp_password)| Set-Content $boss_job_file
#Replace Port number
(Get-Content $boss_job_file) -replace ($port_number_find, "$port_number_change/api/client/") | Set-Content $boss_job_file
#*****************************************************************************************************************************
#                        Add to end of text server name & database name
#*****************************************************************************************************************************
$database_name = 'boss_jobs'
$Server_match = '(?<=Data Source=)'
$Database_match = '(?<=Initial Catalog=)'
$FilePath = 'E:\Scripts\appsettings.json'
(Get-Content $FilePath) -replace ($Server_match, $env:COMPUTERNAME)| Set-Content $FilePath
(Get-Content $FilePath) -replace ($Database_match, $database_name)| Set-Content $FilePath
#=============================================================================================================================

#=============================================================================================================================
#                            Application pool Creation
#=============================================================================================================================
# Create New Application Pool
# Link: https://docs.microsoft.com/en-us/powershell/module/webadministration/new-webapppool?view=windowsserver2022-ps
Install-Module -Name 'IISAdministration'
New-WebAppPool -Name "NETCOREJOBS"
Set-ItemProperty -Path IIS:\AppPools\NETCOREJOBS managedRuntimeVersion "No Managed Code"
#=============================================================================================================================
#=============================================================================================================================
#                       Website Creation
#=============================================================================================================================
mkdir E:\Scripts\BOSS_JOBS
$website_path = "E:\Scripts\BOSS_JOBS"
Import-Module WebAdministration
# create website 
# configured IIS to listen for HTTP requests from ANY () IP address on port 8088 and the destination is the localhost.*
New-IISSite -Name 'BOSS_JOBS' -PhysicalPath $website_path -BindingInformation "*:5001:"
# Assign the application pool to a website
Set-ItemProperty -Path "IIS:\Sites\BOSS_JOBS" -name "applicationPool" -value "NETCOREJOBS"
#=============================================================================================================================
#=============================================================================================================================
#                       Provide full controll permission to the directory
#=============================================================================================================================
$Acl = Get-Acl "E:\Scripts\BOSS_JOBS"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("IUSR", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$Br = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
$Acl.SetAccessRule($Br)
Set-Acl $website_path $Acl
#=============================================================================================================================
#=============================================================================================================================
#           Download file from github, from website hosting bundle and redistributable
#=============================================================================================================================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$source_code_url = 'https://github.com/BiratAryal/scripts/raw/master/powershell.zip'
$script_dir = $((Get-Location|Format-Table -HideTableHeaders|Out-String).Trim())+'\powershell.zip'
$Destination = $script_dir
$web = New-Object -TypeName System.Net.WebClient
$web.DownloadFile($source_code_url,$Destination)
#=============================================================================================================================
#                       Install Application .net core 5 x86 & visual c++ redistributable hosting bundle
#=============================================================================================================================
.\hosting_bundle.exe /S
.\vc_redist.exe /S
#=============================================================================================================================
#Start-IISSite -Name $main_boss_website_name
#Create database 
$db_name= Read-Host -Prompt "Enter name of database"
sqlcmd -S $env:COMPUTERNAME\SQL_SRV_2019 -Q "create database $db_name"
