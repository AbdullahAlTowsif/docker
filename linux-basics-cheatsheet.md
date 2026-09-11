# 🐧 Linux Command Line Cheat Sheet

A quick reference for basic Linux commands, user/group management, and file permissions.

---

## 📁 Basic File & Directory Commands

| # | Command | Description |
|---|---------|-------------|
| 1 | `pwd` | Print working directory (shows current location) |
| 2 | `ls` / `ls -l` / `ls -a` / `ls -la` | List files (`-l` long format, `-a` show hidden, `-la` both) |
| 3 | `cd` | Change directory |
| 4 | `mkdir` | Make a new folder |
| 5 | `touch filename` | Create a new file |
| 6 | `rm filename` | Remove a file |
| 7 | `cat filename` | View contents of a file |
| 8 | `head -n / tail -n filename` | View first/last N lines of a file |
| 9 | `echo "text" >> filename` | Append content to a file |
| 10 | `echo "text" > filename` | Overwrite file content (previous content removed) |
| 11 | `rm foldername` | Remove an (empty) folder |
| 12 | `rm -rf foldername` | Force-remove a folder (and its contents) |
| 13 | `mkdir -p folder1/folder2` | Create nested folders in one command |
| 14 | `cp file1.txt file2.txt` | Copy contents of file1 into file2 |
| 15 | `cp -r folder1/ folder2/` | Copy everything from folder1 into folder2 |
| 16 | `mv filePrv.txt fileNew.txt` | Rename (or move) a file |

### Examples
```bash
head -n 6 a.txt        # show first 6 lines of a.txt
echo hello world > a.txt   # overwrite a.txt with "hello world"
mkdir -p folder1/folder2   # create folder2 inside folder1
```

---

## 👤 Managing Users, Groups & Permissions

### Creating & Inspecting Users

```bash
useradd -m username     # create a new user (-m also creates home directory)
id username             # see identification (uid, gid, groups) of a user
```

> ⚠️ If you skip `-m`, the user is created but **no home directory** is made for them.

### Listing All Users on the System

```bash
cd /etc/
cat passwd
# or, in one line:
cat /etc/passwd
```

### Navigating User Directories

```bash
cd /            # go to root directory
cd home         # then ls to see all user folders
ls
cd ~            # go to the current user's home directory
```

### Switching Users

```bash
su - username
```
- **Prompt symbol changes** based on the active user:
  - `#` → root user (e.g. `root@6eb00c35567f:~#`)
  - `$` → normal user
- `exit` → returns you to the previous (root) user

> 💡 Once inside the **root** user, you can freely `passwd` (set/change passwords) since root has full system power.

### Deleting, Locking & Unlocking Users

```bash
userdel -r username     # delete user AND home directory (-r removes home dir too)
usermod -L username     # lock a user account
usermod -U username     # unlock a user account
```

### Managing Groups

```bash
groupadd grpName              # create a new group
cat /etc/group                # view all groups on the system
groups                        # see which group(s) the current user belongs to
usermod -aG groupName username  # append a user to a group (-aG = append + group)
groupdel grpName              # delete a group
gpasswd -d userName grpName   # remove a user from a specific group
```

---

## 🔐 File Permissions

View permissions with:
```bash
ls -l
```

### Understanding `rwx`

| Symbol | Meaning |
|--------|---------|
| `r` | Read |
| `w` | Write |
| `x` | Execute |

Permissions are grouped in **three sets**: `rw-rw-r--` → `(rw-)` User · `(rw-)` Group · `(r--)` Others

### Example Breakdown — Regular File

```
-rw-rw-r-- 1 towsif towsif 0 Sep 8 18:36 a.txt
```

| Field | Value | Meaning |
|-------|-------|---------|
| `-` | Regular file | File type (`-` = file, `d` = directory) |
| `rw-rw-r--` | Permissions | See breakdown below |
| `1` | Hard links | Number of hard links |
| `towsif` | Owner | File owner (user) |
| `towsif` | Group | Group associated with the file |
| `0` | Size | File size in bytes |
| `Sep 8 18:36` | Timestamp | Last modified date/time |
| `a.txt` | Name | File name |

**Permission breakdown:**
- **User (owner)** → `rw-` → read, write, **no execute**
- **Group** → `rw-` → read, write, **no execute** (applies to any user in this group)
- **Others** → `r--` → read only, **no write/execute**

### Example Breakdown — Directory

```
drwxrwxr-x 2 towsif towsif 4096 Sep 8 18:36 files
```

| Field | Value | Meaning |
|-------|-------|---------|
| `d` | Directory | File type |
| `rwxrwxr-x` | Permissions | Full breakdown below |
| `2` | Links | Number of links to the directory |
| `towsif` | Owner | Directory owner |
| `towsif` | Group | Group |
| `4096` | Size | Directory size in bytes |
| `Sep 8 18:36` | Timestamp | Last modification time |
| `files` | Name | Directory name |

### Changing Permissions — `chmod`

```bash
chmod u+x a.txt    # give the user (owner) execute permission
chmod u-w a.txt     # remove write permission from the user
chmod g-r a.txt     # remove read permission from the group
chmod o+x a.txt     # give others execute permission
```

`chmod` = **ch**ange **mod**e. The letter before `+`/`-` sets the target:
- `u` = user (owner)
- `g` = group
- `o` = others
- `a` = all

### Changing Ownership — `chown`

```bash
chown newUser file.txt   # change ownership of file.txt to newUser
```

---

## 🧩 Quick Concepts

- **User types:** `root` (superuser, full system power) and `normal` (regular, limited permissions)
- **Group types:** `primary` (GID — every user has exactly one) and `supplementary` (additional groups a user can belong to)

---

*Cheat sheet compiled from personal Linux practice notes.*
