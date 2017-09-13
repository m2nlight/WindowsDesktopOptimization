# WindowsDesktopOptimization

A bat script to auto config Windows 10 2016 LTSB

Run `Windows Desktop Optimization.bat` as Administrator:

```
Windows Desktop Optimization
============================
Microsoft Windows 10 Enterprise 2016 LSTB
Current Domain: DESKTOP-G3MPCR3
Current User: Administrator

Are you ready? (Y/N):y
(1/3) Config Service
- [Disabled] Windows Update
- [Disabled] Windows Search
- [Manual] Update Orchestrator Service for Windows Update
- [Manual] Superfetch
- [Disabled] Security Center
- [Disabled] Network Connected Devices Auto-Setup
- [Disabled] Microsoft Windows SMS Router Service
- [Disabled] HomeGroup Provider Server
- [Disabled] HomeGroup Listener Server
- [Manual] Function Discovery Resource Publication
- [Manual] Function Discovery Provider Host
(2/3) Config Registry And Settings
- Disable UAC (NEED REBOOT)
- Disable TCP Auto-Tuning
- Hide This PC 6 folders
- Show extensions for known file types
- Open File Explorer to This PC
- Hide recently used files in Quick access
- Hide frequently used files in Quick access
- Hide Recycle bin on Desktop
- Pin Recycle bin to Quick access
(3/3) Config Appx
- Remove XBox
- Remove Zune
- Remove Bing

Press any key to EXIT...
```

## BAT Will Do:
* Config Service
  - \[Disabled] Windows Update
  - \[Disabled] Windows Search
  - \[Manual] Update Orchestrator Service for Windows Update
  - \[Manual] Superfetch
  - \[Disabled] Security Center
  - \[Disabled] Network Connected Devices Auto-Setup
  - \[Disabled] Microsoft Windows SMS Router Service
  - \[Disabled] HomeGroup Provider Server
  - \[Disabled] HomeGroup Listener Server
  - \[Manual] Function Discovery Resource Publication
  - \[Manual] Function Discovery Provider Host

* Config Registry and GroupPolicy
  - Disable UAC (NEED REBOOT)
  - Disable TCP Auto-Tuning
  - Hide This PC 6 folders
  - Show extensions for known file types
  - Open File Explorer to This PC
  - Hide recently used files in Quick access
  - Hide frequently used files in Quick access
  - Hide Recycle bin on Desktop
  - Pin Recycle bin to Quick access

* Config Appx (for other win10 version)
  - Remove XBox
  - Remove Zune
  - Remove Bing

## Edit the bat by yourself

You can edit `Windows Desktop Optimization.bat` anytime.

Good luck!
