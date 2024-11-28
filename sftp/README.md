
# SFTP Utility Scripts
This repository contains PowerShell scripts for performing SFTP operations such as uploading and downloading files using winscp module and ssh keys.


## 📄 Scripts Overview

### 1. `upload.ps1`
- **Purpose**: Upload files to an SFTP server via ssh keypair, then archives it.
- **Features**:
  - Connects to an SFTP server.
  - Uploads specified files or folders to the target directory.
  - Archives the files after it has been uploaded.
  - logs the outcomes
- **Usage**:
  ./upload.ps1
- **Customizations**:
  - Edit the script to configure:
    - SFTP server address.
    - Username and hostname.
    - local file path.
    - Archive File path.
    - log file path.
    - Target directory on the SFTP server.
    - Private key path.

### 2. `download.ps1`
- **Purpose**: Download files from an SFTP server via ssh keypair.
- **Features**:
  - Connects to an SFTP server.
  - Downloads specified files or folders to the local system.
- **Usage**:
  ./download.ps1
- **Customizations**:
  - Edit the script to configure:
    - SFTP server address.
    - Username and hostname.
    - Remote file path.
    - log file path.
    - Target directory on your system.
    - Private key path.

---

## 🔧 Prerequisites
Before using the scripts, ensure the following:
1. PowerShell is installed on your system.
2. Required PowerShell modules are installed:
   - [WinSCP .NET Assembly](https://winscp.net/eng/docs/library_powershell) or other SFTP libraries.
3. A valid keypair is generated and configured, once generated add the location of the private key on the script and provide add the public key to the server you are downloading files from in the authorized_keys file on the server.

---

## 🚀 Getting Started
1. Clone this repository or download the files directly.
2. Navigate to the `sftp` directory.
3. Open and edit the scripts to configure the SFTP connection details.
4. Run the scripts:
   ./upload.ps1
   ./download.ps1

---

## 💡 Customization Notes
- Update the scripts with your:
  - SFTP server hostname or IP.
  - Authentication credentials (private key path).
  - Paths for files to upload/download.
- Add logging paths for production use.

---

## 📜 License
This project is open-source and available under the [MIT License](LICENSE).

---

## 🤝 Contributing
Feel free to open an issue or submit a pull request if you want to contribute enhancements or fixes to these scripts.

---

## 📞 Contact
For questions or support, please reach out via my [GitHub Profile](https://github.com/Manishlimbu1221).


