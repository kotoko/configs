# void-linux-desktop

This is simple configuration to apply after installing void linux from livecd. It does steps from official installation guide. It also installs KDE with arbitrarily chosen programs and creates user accounts in the end. You can specify a list of user accounts to be created.

## Context

Windows 10 is a big no-no, so after death of Windows 7 I decided to search for linux distribution that I can install for my friends and family. Main requirements:

* can be used as desktop,
* has "minimal" edition,
* has up-to-date programs,
* is easy to update/manage.

After a few experiments turned out that void linux fits. I had to repeat installing many times, so I decided to automate this and thus this script was created.

## Usage

`runs.sh` is simple bash script witch applies puppet configuration. It is designed to be as simple as possible. Bash script and puppet configuration are idempotent (or should be).

I am assuming that during running this script computer is connected to the internet via ethernet cable.

1. Install with official void installer. Choose network installation.
2. Reboot.
3. Go to tty2: `Ctrl` + `Alt` + `F2`. (It's important to not be on tty1.)
4. Login as `root`.
5. Copy files to the computer.
    * Edit users in the file `manifests/init.pp`.
6. Run script: `bash run.sh | tee out.log`.
    * During installation sddm will start. You can go back to the terminal with running script: `Ctrl` + `Alt` + `F2`.
    * After finishing you can read log from file `out.log`.
7. Reboot.

Things to do after reboot:
* set passwords for user accounts,
* remove copied files,
* install drivers (?).
