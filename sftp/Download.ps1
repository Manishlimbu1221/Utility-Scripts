# Import the WinSCP .NET assembly 
Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

# Set the remote file path
$remoteDirectory = "//"

# Set the local file path
$localDirectory = "C:\localdirectory"

# Set the log file path
$Date = get-date -format yyyy-MM-dd
$logFilePath = "C:\logs\logs.log"

# Set the WinSCP session options
$sessionOptions = New-Object WinSCP.SessionOptions
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.HostName = "HostName"
$sessionOptions.UserName = "UserName"
$sessionOptions.SshHostKeyFingerprint = "sshkeyfingerprint"
$sessionOptions.SshPrivateKeyPath = "C:\privatekeypath"


# Create a new WinSCP session
$session = New-Object WinSCP.Session

try
{
    # Connect to the remote host
    $session.Open($sessionOptions)

    $message = "{0} - Connection Successfully established" -f (Get-Date)
    Add-Content -Path $logFilePath -Value $message

    # Get a list of files in the directory, excluding subdirectories
    $files = $session.ListDirectory($remoteDirectory).Files | Where-Object { -not $_.IsDirectory }
 
    # Loop through the files and download them
    if ($files.Count -eq 0) {
    $message = "{0} - No Files to download from '{1}'" -f (Get-Date), $remoteDirectory
    Add-Content -Path $logFilePath -Value $message
}
    else {
        foreach ($file in $files) {
            $localPath = $localDirectory + $file.Name
            $session.GetFiles($file.FullName, $localPath).Check()

            $message = "{0} - Successfully transferred file '{1}' to {2}" -f (Get-Date), $file, $localDirectory
            Add-Content -Path $logFilePath -Value $message
    }
}
}
finally
{
    # Disconnect from the remote host
    $session.Dispose()

    $message = "{0} - Connection Closed" -f (Get-Date)
    Add-Content -Path $logFilePath -Value $message

}
 
exit 0

catch [Exception]
{
    $message = "{0} - Error: {1}" -f (Get-Date), $_.Exception.Message
    Add-Content -Path $logFilePath -Value $message
}
