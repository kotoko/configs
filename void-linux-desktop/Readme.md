# void-linux-desktop

This is a simple configuration to apply after installing void linux from livecd. It does steps from official installation guide. It also installs KDE with arbitrarily chosen programs and creates user accounts in the end. You can specify a list of user accounts to be created.

## Context

Windows 10 is a big no-no, so after death of Windows 7 I decided to search for linux distribution that I can install for my friends and family. Main requirements:

* can be used as desktop,
* has "minimal" edition,
* has up-to-date programs (rolling release),
* is easy to update/manage.

After a few experiments turned out that void linux fits perfectly. I had to repeat installing few times, so I decided to automate this process and thus this script was created.

## Usage

`runs.sh` is a simple bash script which applies puppet configuration. It is designed to be as simple as possible. Bash script and puppet configuration are idempotent (or should be).

I am assuming that during running this script computer is connected to the internet via ethernet cable.

1. Install with official void installer. Choose network installation. Create default user `void` with trivial password.
2. Reboot.
3. Go to tty2: `Ctrl` + `Alt` + `F2`. (It's important to not be on tty1.)
4. Login as `root`.
5. Copy files to the computer.
    * You can download repository with git:
        - `xbps-install -S git`
        - `git clone "https://github.com/kotoko/configs.git" /root/configs`
        - `cd /root/configs`
    * Edit users in the file `manifests/init.pp`:
        - `xbps-install -S nano`
        - `nano manifests/init.pp`
6. Run script: `bash run.sh 2>&1 | tee out.log`.
    * During installation of sddm it may switch your screen to something else. You can go back to the terminal: `Ctrl` + `Alt` + `F2`.
    * When finished you can read log from file `out.log`.
7. Reboot.

Things to do after reboot:
* set passwords for user accounts,
* configure at least one user to run any command as root via sudo
* remove/disable password for root
* remove user `void`
* install additional drivers (?),
* remove copied files (?),
* configure ssh server (?),

## See also

* official livecd - [voidlinux-iso](https://repo-default.voidlinux.org/live/current/)
* my customized livecd - [voidlinux-iso-extra](https://github.com/kotoko/voidlinux-iso-extra)
* official documentation - [docs.voidlinux.org](https://docs.voidlinux.org/)
