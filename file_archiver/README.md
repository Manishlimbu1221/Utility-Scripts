
# File Archiver Script
This PowerShell script automates the task of archiving old files by moving them from a source directory to a destination directory based on their age. It also logs all operations for easy tracking.


## 📄 Scripts Overview

### 1. `upload.ps1`
  - **Purpose**: 
  - Archive files that are older than a specified number of days.
  - Process files in batches to optimize performance and prevent memory issues.
  - Log operations, including successful moves and errors, for audit purposes.
- **Features**:
  - Processes files in a **source directory** recursively.
  - Moves files older than a configurable number of days to a **destination directory**.
  - Supports **batch processing** to handle large numbers of files efficiently.
  - Generates detailed logs in a configurable **log directory**.
- **Usage**:
  ./file_archiver.ps1
- **Customizations**:
- Modify the script's default parameter values to suit your environment.
- Enhance logging or add email notifications for failed operations (optional).


## 🔧 Prerequisites

- PowerShell 5.0 or higher.
- Appropriate permissions to read from the `sourceDir` and write to the `destinationDir` and `logDir`.

---




