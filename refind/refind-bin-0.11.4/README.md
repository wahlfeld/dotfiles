1. Download the rEFInd boot manager and unzip it. Drag the unzipped folder onto your desktop

2. Boot into Recovery Mode by holding down ⌘ + R while turning on your Mac

3. Once in Recovery Mode, open Disk Utility. Choose your macOS partition and click Mount in the toolbar to mount it.

4. Quit Disk Utility and open Terminal

5. cd into the directory where you unzipped rEFInd, which will probably be something like /Volumes/Macintosh\ HD/Users/jane/Desktop/refind*, if your macOS username was jane

6. Install rEFInd ($ ./refind-install)

7. You should now see the rEFInd menu, which options to boot Windows and macOS