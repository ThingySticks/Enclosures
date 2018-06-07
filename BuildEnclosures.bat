@echo off
REM Requires openscad folder in path.

@echo Building Wide Photon Case.
REM Wide Photon Case
"C:\Program Files\OpenSCAD\openscad.com" -o Photon\Wide\V1\WidePhotonCase.stl -D showCover=false;showBase=true;case=0 ThingyStickCase.scad
"C:\Program Files\OpenSCAD\openscad.com" -o Photon\Wide\V1\WidePhotonCaseCover.stl -D showCover=true;showBase=false;case=0 ThingyStickCase.scad


@echo Building Electron Case
Electron\Long\V1\BuildEnclosures.bat
"C:\Program Files\OpenSCAD\openscad.com" -o Electron\Long\V1\Electron-Base-Square.stl -D showCover=false;showBase=true;includeUsbPlugCutout=true;includePhotonUsbSocketCutout=false;case=10 Electron\Long\V1\LongElectronCase.scad
"C:\Program Files\OpenSCAD\openscad.com" -o Electron\Long\V1\Electron-Base-Square-NoUsbA.stl -D showCover=false;showBase=true;includeUsbPlugCutout=false;includePhotonUsbSocketCutout=true;case=10 Electron\Long\V1\LongElectronCase.scad

@echo Done.
