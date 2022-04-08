# Firefox profile

This is initial configuration for firefox profile. It's addition to puppet script in folder void-linux-desktop but you can also use standalone on your computer too.

## Instruction

1. Create new profile: `firefox -no-remote -ProfileManager` (-no-remote == no internet -> avoid sending telemetry on fresh start).
2. Close firefox.
3. Delete all files/folders from inside profile folder.
4. Copy files from folder `profile-abcxyz/` to profile folder.
5. Open firefox.
6. Go into addon settings and turn on all extensions.
7. Configure extensions to your liking.

Done!
