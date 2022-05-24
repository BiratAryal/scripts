#=============================================================================================================================
#=============================================================================================================================
#                                   Stop and start IIS website  
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
#*****************************************************************************************************************************
#*****************************************************************************************************************************
#                        Extract Archive
Expand-Archive -Path '.\Deployment_files.zip' -DestinationPath '.'