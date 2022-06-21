[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$url = "https://nots.com.np:7051/"
$req = [Net.HttpWebRequest]::Create($url)
$req.GetResponse() | Out-Null
$output = [PSCustomObject]@{
   URL = $url
   'Cert Start Date' = $req.ServicePoint.Certificate.GetEffectiveDateString()
   'Cert End Date' = $req.ServicePoint.Certificate.GetExpirationDateString()
}
$output