# Define the path to the directory, the number of days, and the log file location
$directoryPath = "C:\Users\Manish.Limbu\Downloads\Fileremove" 
$daysThreshold = 1  # Change this to your desired number of days
$batchSize = 1000  # Define the size of each batch
$logDirectoryPath = "C:\Users\Manish.Limbu\OneDrive - Octopus Capital Ltd\Documents\file_archiver3"  # Change this to your desired log file location

# Ensure the log directory exists
if (-not (Test-Path -Path $logDirectoryPath)) {
    New-Item -Path $logDirectoryPath -ItemType Directory | Out-Null
}

# Calculate the date threshold
$dateThreshold = (Get-Date).AddDays(-$daysThreshold)

# Define the log file path
$logFilePath = Join-Path -Path $logDirectoryPath -ChildPath ("CleanupLog_" + (Get-Date).ToString("yyyyMMdd_HHmmss") + ".txt")

# Initialize the log file
Add-Content -Path $logFilePath -Value ("Log started on: " + (Get-Date))

# Check if the directory exists
if (Test-Path -Path $directoryPath) {
    # Get all files in the directory and subdirectories
    $files = Get-ChildItem -Path $directoryPath -File -Recurse

    # Process files in batches
    $fileBatch = @()
    foreach ($file in $files) {
        $fileBatch += $file

        # If the batch size is reached, process the batch
        if ($fileBatch.Count -ge $batchSize) {
            foreach ($batchFile in $fileBatch) {
                if ($batchFile.LastWriteTime -lt $dateThreshold) {
                    Remove-Item -Path $batchFile.FullName -Force
                    $logMessage = "$(Get-Date) - Removed file: $($batchFile.FullName), File Date: $($batchFile.LastWriteTime)"
                    Write-Output $logMessage
                    Add-Content -Path $logFilePath -Value $logMessage
                }
            }
            # Clear the batch to free up memory
            $fileBatch = @()
        }
    }

    # Process any remaining files in the last batch
    if ($fileBatch.Count -gt 0) {
        foreach ($batchFile in $fileBatch) {
            if ($batchFile.LastWriteTime -lt $dateThreshold) {
                Remove-Item -Path $batchFile.FullName -Force
                $logMessage = "$(Get-Date) - Removed file: $($batchFile.FullName), File Date: $($batchFile.LastWriteTime)"
                Write-Output $logMessage
                Add-Content -Path $logFilePath -Value $logMessage
            }
        }
    }

    # After file cleanup, check for empty directories and delete them
    $directories = Get-ChildItem -Path $directoryPath -Directory -Recurse
    foreach ($directory in $directories) {
        $filesInDirectory = Get-ChildItem -Path $directory.FullName -File -Force
        if ($filesInDirectory.Count -eq 0) {
            Remove-Item -Path $directory.FullName -Recurse -Force
            $logMessage = "$(Get-Date) - Deleted empty directory: $($directory.FullName)"
            Write-Output $logMessage
            Add-Content -Path $logFilePath -Value $logMessage
        } else {
            $logMessage = "$(Get-Date) - Directory not empty: $($directory.FullName)"
            Write-Output $logMessage
            Add-Content -Path $logFilePath -Value $logMessage
        }
    }
} else {
    $errorMessage = "Directory not found: $directoryPath"
    Write-Error $errorMessage
    Add-Content -Path $logFilePath -Value $errorMessage
}

Add-Content -Path $logFilePath -Value ("Log ended on: " + (Get-Date))
