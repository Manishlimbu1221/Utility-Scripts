# Import the WinSCP .NET assembly
Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

# Set the remote file path
$remoteDirectory = "//"

# Set the local file path
$localDirectory = "C:\localfilepath"

# Set the local archive directory path
$localArchiveDirectory = "C:\localarchivedirectory"

# Set the log file path
$Date = get-date -format yyyy-MM-dd
$logFilePath = "C:\logs\log.log"

# Set the WinSCP session options
$sessionOptions = New-Object WinSCP.SessionOptions
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.HostName = "Hostname"
$sessionOptions.UserName = "Username"
# Get the keypair and fingerprint by using puttygen on winscp to create it
$sessionOptions.SshHostKeyFingerprint = "ssh key fingerprint"
$sessionOptions.SshPrivateKeyPath = "C:\privatekeypath"

# Create a new WinSCP session
$session = New-Object WinSCP.Session

try
{
    # Connect to the remote host
    $session.Open($sessionOptions)

    $message = "{0} - Connection Successfully established" -f (Get-Date)
    Add-Content -Path $logFilePath -Value $message

    $transferOptions = New-Object WinSCP.TransferOptions -Property @{
    ResumeSupport = New-Object WinSCP.TransferResumeSupport -Property @{ State = [WinSCP.TransferResumeSupportState]::Off }
    }
    $transferOptions.FilePermissions = $Null # This is default
    $transferOptions.PreserveTimestamp = $False


    # Get a list of all files in the local directory
    $localFiles = Get-ChildItem $localDirectory -File

    # Loop through each file and upload it to the remote host
    foreach ($localFile in $localFiles)
    {
        # Upload the file
        $transferResult = $session.PutFiles($localFile.FullName, $remoteDirectory, $False, $transferOptions)

        # Check for any errors during the file transfer
        $transferResult.Check()

        # Log the result of the file transfer
        foreach ($transfer in $transferResult.Transfers)
        {
            if ($transfer.Error -eq $null)
            {
                
                # Move the local file to the archive directory
                $archivedfile = '{0}{1}{2}' -f $localFile.BaseName,(Get-Date).ToString("-yyyyMMdd-hhmmss"), $localFile.Extension
                $archivedfile = Join-Path $localArchiveDirectory $archivedfile
                $localFile.FullName | Move-Item -Destination $archivedfile

                $message = "{0} - {1} - File has been transferred successfully and has been archived" -f (Get-Date), $transfer.FileName
            }
            else
            {
                $message = "{0} - {1} - File has failed to transfer" -f (Get-Date), $transfer.FileName
            }
            Add-Content -Path $logFilePath -Value $message
        }

}
}
catch [Exception]
{
    
    $message = "{0} - Error: {1}" -f (Get-Date), $_.Exception.Message

    # If there is successful in the logs of the error then move the file to the error folder
    if ($message -like "*successful*"){ 
        Move-Item $localFiles.FullName -Destination $errorfolder
        }

    Add-Content -Path $logFilePath -Value $message
    break
}
finally
{
    # Disconnect from the remote host
    $session.Dispose()

    $message = "{0} - Connection Closed" -f (Get-Date)
    Add-Content -Path $logFilePath -Value $message
}

exit 0
