$Linkspeeds = (Get-NetAdapter -Physical | Where-Object { $_.MediaType -eq "802.3" -and $_.status -ne "Disconnected" })
 
$LinkspeedState = foreach ($Linkspeed in $Linkspeeds) {
    if ($Linkspeed.speed -lt 1000000000) { "$($Linkspeed.name) linkspeed is lower than 1000mb" }
}
if (!$Linkspeeds) { $LinkspeedState = "No physical links found" }
if (!$LinkspeedState) { $LinkspeedState = "Healthy" }