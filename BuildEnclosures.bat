@echo off
REM Requires openscad folder in path.

@echo Building Wide Photon Case.
REM Wide Photon Case
"C:\Program Files\OpenSCAD\openscad.com" -o Photon\Wide\V1\WidePhotonCase.stl -D showCover=false;showBase=true ThingyStickCase.scad
"C:\Program Files\OpenSCAD\openscad.com" -o Photon\Wide\V1\WidePhotonCaseCover.stl -D showCover=true;showBase=false ThingyStickCase.scad

@echo Done.
