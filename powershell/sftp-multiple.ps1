try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "192.168.21.16"
        UserName = "tms"
        Password = "$t@ge!!@Tm$C"
        # SshHostKeyFingerprint = "ssh-rsa 2048 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
    }
 
    $session = New-Object WinSCP.Session
 
     $sessionOptions_second_server = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "192.168.21.167"
        UserName = "infra_user"
        Password = "!nfr@123#"
        # SshHostKeyFingerprint = "ssh-rsa 2048 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
    }
 
    $session_second_server = New-Object WinSCP.Session
   
    try
    {
      # Connect to download from server 1
        $session.Open($sessionOptions)
 
    #     # Download files
    #     $transferOptions = New-Object WinSCP.TransferOptions
    #     $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
 
    #     $transferResult = $session.GetFiles("/home/user/*", "d:\download\", $False, $transferOptions)
 
    #     # Throw on any error
    #     $transferResult.Check()
 
    #     # Print results
    #   $files_downloaded = 0
    #     foreach ($transfer in $transferResult.Transfers)
    #     {
    #         Write-Host ("Download of {0} succeeded" -f $transfer.FileName)
    #      $files_downloaded++
    #     }
        $session.Dispose()
   
      if ($files_downloaded)
      {   
         # Connect to upload to server 2
        $session_second_server.Open($sessionOptions_second_server)
    
         # Upload files
        #  $transferOptions_second_server = New-Object WinSCP.TransferOptions
        #  $transferOptions_second_server.TransferMode = [WinSCP.TransferMode]::Binary
    
        #  $transferResult_second_server = $session_second_server.PutFiles("d:\download\*", "/home/user/", $False, $transferOptions_second_server)
    
        #  # Throw on any error
        #  $transferResult_second_server.Check()
    
        #  # Print results
        #  foreach ($transfer in $transferResult.Transfers)
        #  {
        #     Write-Host ("Upload of {0} succeeded" -f $transfer.FileName)
        #  }
        $session_second_server.Dispose()

      }
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
      $session_second_server.Dispose()
    }
 
    exit 0
}
catch [Exception]
{
    Write-Host ("Error: {0}" -f $_.Exception.Message)
    exit 1
}


C#
using (Sftp client = new Sftp())
{
    // Set security settings.
    client.Config.HostKeyAlgorithms = SecureShellHostKeyAlgorithm.RSA;
    client.Config.KeyExchangeAlgorithms = SecureShellKeyExchangeAlgorithm.DiffieHellmanGroupExchangeSHA256;
    // Enable compression
    client.Config.EnableCompression = true;

    // Connect to the server.
    client.Connect(serverName);

    // ...
}
VB.NET
Using client As New Sftp()
    ' Set security settings.
    client.Config.HostKeyAlgorithms = SecureShellHostKeyAlgorithm.RSA
    client.Config.KeyExchangeAlgorithms = SecureShellKeyExchangeAlgorithm.DiffieHellmanGroupExchangeSHA256
    ' Enable compression
    client.Config.EnableCompression = True

    ' Connect to the server.
    client.Connect(serverName)

    ' ...
End Using


Set connection settings

The Sftp.Config property has several useful connection options like EnableCompression, HostKeyAlgorithms, MacAlgorithms, etc. If needed, set those before connecting to a server.
