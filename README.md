# Customize Toolbar

A plugin for [Notepad++](https://notepad-plus-plus.org/) that allows the toolbar to be fully
customised by the user, and adds twenty-six buttons for frequently used menu commands.

All buttons on the toolbar can be customised, whether they are Notepad++ built-in buttons, the
additional buttons, or buttons belonging to other plugins. Custom buttons for Notepad++ or plugin
menu commands can be defined in a configuration file.

Originally written by DW-dev and published on
[SourceForge](https://sourceforge.net/projects/npp-customize/), which never had a Git, SVN,
Mercurial or CVS repository — only a file release area. This repository imports the three releases
for which a source zip exists (5.1, 5.2, 5.3) unchanged and in order, each dated to its original
release date, so that every later change can be read as a diff against real upstream history.

## Using it

Open the toolbar customisation dialog box from Plugins &rarr; Customize Toolbar &rarr;
**Customize Toolbar...**, from the toolbar button, or by double-clicking empty space on the toolbar.
Buttons can also be rearranged by holding Shift and dragging them along or off the toolbar.

Help for the plugin and for custom buttons is available from the plugin's menu.

## Building

Requires Visual Studio with the *Desktop development with C++* workload, which supplies the
compiler, the resource compiler and the Windows SDK.

```
build.bat          rem 64-bit, the default
build.bat Win32    rem 32-bit
```

The DLL is written to `bin\x64\CustomizeToolbar.dll`. The C runtime is linked statically, so the
DLL does not need the Visual C++ redistributable. To install it, close Notepad++ and copy the DLL
over `%ProgramFiles%\Notepad++\plugins\CustomizeToolbar\CustomizeToolbar.dll`.

The upstream source release ships no resource script, no `resource.h` and no project file, so it
cannot be built as published. Those files were written for this repository and are not part of the
original release.

## Changes since 5.3

**5.4** — Fixed hidden toolbar buttons reappearing after a restart, caused by Notepad++
translating plugin menu items after button identity was already hashed. See the
[commit history](https://github.com/CennoxX/CustomizeToolbar/commits/main) for details.

## Licence

GNU General Public License, version 2 or later. See [LICENSE.txt](LICENSE.txt).
