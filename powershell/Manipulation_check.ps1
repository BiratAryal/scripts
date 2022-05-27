$filePath = 'C:\Scripts\powershell\users.txt'
$linenumber = (Get-Content $filePath).Length
$fileContent = Get-Content $filePath
$texttoadd = Add-Content $filePath -Value "randomvalue1`r`nrandomvalue2"
$fileContent[$linenumber-1] += $texttoadd
$fileContent | Set-Content $filePath 
# insert into text file multi lines.
#Add-Content .\users.txt -Value "app setting .json `r`n new line number"
