@echo off

@echo Building Big latching relay Case

# pcbWidth=100 (snug fit with connector out the back)
# additionalBaseDepth=9 - aligh with top of terminal block - needed when includeUsbPlugCutout
# coverDepth=10
"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-A-Plug-Case.stl -D showCover=false;showBase=true;includeUsbPlugCutout=true;includePhotonUsbSocketCutout=false;pcbWidth=100;additionalBaseDepth=9;cableExit=false;coverDepth=10; BigLatchingRelay-Electron-V2-1-Case.scad
"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-A-Plug-Lid.stl -D showCover=true;showBase=false;includeUsbPlugCutout=true;includePhotonUsbSocketCutout=false;pcbWidth=100;additionalBaseDepth=9;cableExit=false;coverDepth=10; BigLatchingRelay-Electron-V2-1-Case.scad

# pcbWidth=100 (snug fit with connector out the back)
# additionalBaseDepth=14 - extra height for photon Usb plug/socket
# includeUsbPlugCutout = false 
# includePhotonUsbSocketCutout = true
"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-B-Socket-Case.stl -D showCover=false;showBase=true;includeUsbPlugCutout=false;includePhotonUsbSocketCutout=true;pcbWidth=100;additionalBaseDepth=14;cableExit=false;coverDepth=5; BigLatchingRelay-Electron-V2-1-Case.scad
"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-B-Socket-Lid.stl -D showCover=true;showBase=false;includeUsbPlugCutout=false;includePhotonUsbSocketCutout=true;pcbWidth=100;additionalBaseDepth=14;cableExit=false;coverDepth=5; BigLatchingRelay-Electron-V2-1-Case.scad





# extra case length (x axis) for cable.
# pcbWidth=130 

"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-A-Plug-CableExit-Case.stl -D showCover=false;showBase=true;includeUsbPlugCutout=true;includePhotonUsbSocketCutout=false;pcbWidth=130;additionalBaseDepth=9;cableExit=true; BigLatchingRelay-Electron-V2-1-Case.scad
"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-A-Plug-CableExit-Lid.stl -D showCover=true;showBase=false;includeUsbPlugCutout=true;includePhotonUsbSocketCutout=false;pcbWidth=130;additionalBaseDepth=9;cableExit=true; BigLatchingRelay-Electron-V2-1-Case.scad

"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-B-Socket-CableExit-Case.stl -D showCover=false;showBase=true;includeUsbPlugCutout=false;includePhotonUsbSocketCutout=true;pcbWidth=130;additionalBaseDepth=14;cableExit=true; BigLatchingRelay-Electron-V2-1-Case.scad
"C:\Program Files\OpenSCAD\openscad.com" -o BigLatchingRelay-Electron-V2-1-B-Socket-CableExit-Lid.stl -D showCover=true;showBase=false;includeUsbPlugCutout=false;includePhotonUsbSocketCutout=true;pcbWidth=130;additionalBaseDepth=14;cableExit=true; BigLatchingRelay-Electron-V2-1-Case.scad

@echo Done.
