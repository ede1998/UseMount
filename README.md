# UseMount

Simple Classic WoW-Addon to automatically choose the AQ40 mount if your in The Temple of Ahn'Qiraji and your normal mount elsewhere.

## How to use

Bind the automatically created macro `UseMount` to your mount hotkey and you're set up.
To check which mount the addon is going to use, type `/usemount` or `/um`. Example output:
```
AQ40 mount (/um aq40 <mount name>): Yellow Qiraji Resonating Crystal
Normal mount (/um normal <mount name>): normal mount
```

If you find that the addon chose the wrong mount or could not determine the mount you wish to use, you can use the following commands:
- `/usemount aq40 <mount name>` or `/um aq40 <mount name>` to set your AQ40 mount
- `/usemount normal <mount name>` or `/um normal <mount name>` to set your normal mount

## How it works

The addon creates a macro called `UseMount` on the first start. This macro contains the command to use your mount, e.g. `/use Swift Palomino`.
When you enter AQ40, the addon is edited to instead use your AQ40 mount, e.g. `/use Yellow Qiraji Resonating Crystal`.

Caveat: There is a short delay before the macro is edited because `GetRealZoneText()` can return the wrong zone name right after a new zone is entered.

## Author
Trpatches-Bloodfang
