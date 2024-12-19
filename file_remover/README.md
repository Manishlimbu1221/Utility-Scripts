
# File Remover Script
This PowerShell script automates the task of removing old files and empty directories.


## 📄 Scripts Overview

### 1. `upload.ps1`
  - **Purpose**: 
  - Remove files that are older than a specified number of days.
  - Remove empty directories
  - Process files in batches to optimize performance and prevent memory issues.
  - Log operations, including successful moves and errors, for audit purposes.
- **Features**:
  - Processes files in a **source directory** recursively.
  - Removes files older than a configurable number of days to a **destination directory**.
  - Supports **batch processing** to handle large numbers of files efficiently.
  - Removes directories and child directories that are empty
  - Generates detailed logs in a configurable **log directory**.
- **Usage**:
  ./fileRemover.ps1
- **Customizations**:
- Modify the script's default parameter values to suit your environment.
- Enhance logging or add email notifications for failed operations (optional).


## 🔧 Prerequisites

- PowerShell 5.0 or higher.
- Appropriate permissions to read from the `sourceDir` and write to the `destinationDir` and `logDir`.

---




