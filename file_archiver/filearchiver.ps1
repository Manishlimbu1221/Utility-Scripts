param (
    [string]$sourceDir = "source",
    [string]$destinationDir = "destination",
    [int]$daysThreshold = 3,
    [int]$batchSize = 1000,
    [string]$logDir = "logs"
)

# Function to move old files
function Move-OldFiles {
    param (
        [string]$sourceDir,
        [string]$destinationDir,
        [int]$daysThreshold,
        [int]$batchSize,
        [string]$logDir
    )

    # Create log file with current date and time
    if (-not (Test-Path -Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force
    }
    $logFileName = "move_old_files_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    $logFilePath = Join-Path -Path $logDir -ChildPath $logFileName

    # Get the current time
    $currentTime = Get-Date

    # Counter for moved files
    $filesMoved = 0

    # Stream files and process them in batches
    $fileBatch = @()
    Get-ChildItem -Path $sourceDir -Recurse -File | ForEach-Object {
        $fileBatch += $_
        if ($fileBatch.Count -ge $batchSize) {
            $filesMoved += Process-Batch $fileBatch $sourceDir $destinationDir $daysThreshold $logFilePath
            $fileBatch = @()
        }
    }

    # Process any remaining files in the last batch
    if ($fileBatch.Count -gt 0) {
        $filesMoved += Process-Batch $fileBatch $sourceDir $destinationDir $daysThreshold $logFilePath
    }

    # Output summary
    if ($filesMoved -eq 0) {
        $noFilesMessage = "$(Get-Date) - No files currently older than $daysThreshold days."
        Write-Output $noFilesMessage | Out-File -FilePath $logFilePath -Append
    }
    else {
        $movedFilesMessage = "$(Get-Date) - Moved $filesMoved files."
        Write-Output $movedFilesMessage | Out-File -FilePath $logFilePath -Append
    }
}

# Function to process a batch of files
function Process-Batch {
    param (
        [array]$fileBatch,
        [string]$sourceDir,
        [string]$destinationDir,
        [int]$daysThreshold,
        [string]$logFilePath
    )

    $movedCount = 0

    foreach ($file in $fileBatch) {
        try {
            # Get the last write time of the file
            $modifiedTime = $file.LastWriteTime

            # Calculate the difference in days
            $daysDifference = (Get-Date) - $modifiedTime

            # Check if the file is older than the threshold
            if ($daysDifference.TotalDays -ge $daysThreshold) {
                # Get the relative path of the file
                $relativePath = $file.FullName.Substring($sourceDir.Length + 1)

                # Create the destination directory if it doesn't exist
                $destinationDirectory = Join-Path -Path $destinationDir -ChildPath $relativePath | Split-Path -Parent
                if (-not (Test-Path -Path $destinationDirectory)) {
                    New-Item -ItemType Directory -Path $destinationDirectory -Force
                }

                # Move the file to the destination directory
                $destinationPath = Join-Path -Path $destinationDir -ChildPath $relativePath
                Move-Item -Path $file.FullName -Destination $destinationPath -Force

                # Log the action with current date and time
                $logMessage = "$(Get-Date) - Moved file: $($file.FullName) to $destinationPath"
                Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
                
                $movedCount++
            }
        } catch {
            # Log the error with current date and time
            $errorMessage = "$(Get-Date) - Error moving file: $($file.FullName). Error: $_"
            Write-Output $errorMessage | Out-File -FilePath $logFilePath -Append
        }
    }

    return $movedCount
}

# Call the function to move old files
$movedFilesCount = Move-OldFiles -sourceDir $sourceDir -destinationDir $destinationDir -daysThreshold $daysThreshold -batchSize $batchSize -logDir $logDir
