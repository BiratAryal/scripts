$BandwidthAlertThreshold = "800" #megabits per second
 
$Counter = 0
$UsedBandwidth = do {
    $counter ++
    (Get-CimInstance -Query "Select BytesTotalPersec from Win32_PerfFormattedData_Tcpip_NetworkInterface" | Select-Object BytesTotalPerSec).BytesTotalPerSec / 1Mb * 8
} while ($counter -le 10)
 
$AvgBandwidth = [math]::round(($UsedBandwidth | Measure-Object -Average).average, 2)
$BandwidthAlert = if ($AvgBandwidth -gt $BandwidthAlertThreshold) { "Unhealthy - Bandwidth is at $AvgBandwidth" } else { "Healthy" }