# toss-the-ball
My attempt at making something playable :3
>[!NOTE]
>This game was made for LÖVE 11.5 (Mysterious Mysteries). You need to install Love2D on your machine first to be able to run this game.

## Platform support:
Although testing is limited, this game should run fine on every platform you can install love in. This includes:
- Linux
- Android
- Windows **(not tested)**
- macOS **(not tested)**
- iOS **(not tested)**

## Losing progress:
The save directory gets changed frequently so the game might ignore your current progress when moving to a different version.

You can usually fix this by renaming your save directory to match the value of your target version's `t.identity` in `game/conf.lua`.\
Alternatively, you can edit its value to match your existing folder name. (This only works if you know what the original identity was.)

Save directory path:
OS|Path|Alternative
---|---|---
Windows|C:\Users\user\AppData\Roaming\LOVE\identity|%appdata%\LOVE\identity
macOS|/Users/user/Library/Application Support/LOVE/identity|-
Linux|$XDG_DATA_HOME/love/identity|~/.local/share/love/identity
Android|/data/data/org.love2d.android/files/save/identity|/sdcard/Android/data/org.love2d.android/files/save/identity

[source](https://www.love2d.org/wiki/love.filesystem)
>[!NOTE]
>Android users may have problems accessing the save directory. You can use the alternate method mentioned above or connect another device and follow the steps mentioned above.
