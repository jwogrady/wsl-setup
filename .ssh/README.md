# 🚨 Temporary SSH Key Staging Directory for WSL Setup

> **⚠️ Important:**  
> **Never store your SSH keys here permanently.**  
> This directory is for **temporary transfer only**.

---

## How to Use

1. **Copy** your SSH keys (e.g., `id_ed25519`, `id_rsa`) into this folder **only when you need to move them into your WSL environment**.
2. **Run** the copy script (e.g., `wsl-copy.ps1`) to securely transfer your keys into your WSL home directory.
3. **Delete** the SSH keys from this directory **immediately after transfer**.

---

## Security Notice

Storing sensitive keys on a Windows NTFS volume is **unsafe**.  
Files here are accessible to all Windows users and processes.

---

## Best Practices

- Treat the keys inside your WSL environment as your **primary copies**.
- **Always keep at least two backups** of your SSH keys:
    - One local backup (on secure, encrypted storage)
    - One remote backup (e.g., a secure cloud vault or password manager)
    - *(Optional)* A third backup on offline media (e.g., an encrypted USB drive)
- **Remove** keys from this folder as soon as they are copied to WSL.

---

> **Summary:**  
> This directory is for **temporary staging only**.  
> **Remove your SSH keys from here immediately after use.**