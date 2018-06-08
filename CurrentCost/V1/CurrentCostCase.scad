echo("Current Cost");

pcbHeight = 35;
pcbWidth = 72;
// How thick (deep) the PCB is (typically 1.6mm)
pcbThickness = 1.6;

pcbPaddingYAxis = 2;
pcbPaddingXAxis = 1; 

// Support positions on the PCBs, relatec to the PCB corner.
// does not include bezel/wall thinckness offsets
pcbSupportPositions = []; // [[4,36,0],[96,4,0]];
pcbSupportPadPositions = [[14,17.0,0],[67.25,4.3,0],[67.25,30.6,0]];
//pcbSupportPinPositions = [[4,4,0],[96,36,0],[4,36,0],[96,4,0]];
pcbSupportPinPositions = [];
pcbSupportHeight = 8;


// How much above the USB A connector inlet to add the the base case height.
additionalBaseDepth = 12; // With Photon in headers.
//additionalBaseDepth = 12; // Without Photon mounted in headers.

// Y start position and how far along
// Compute the X start and end based on case size
// Compute the Z start position base and size based on
// the support heights, base height, top height and cutout height required.
endCutoutYStartPosition = 10;
endCutoutHeight = 20;
// Overall Z height - shared between base and top
endCutoutZHeight = 8; 
includeEndCutout = false;

textPosition = [30,21,-3];
textText = "Photon";
includeText = false;
includeArialCutouts = false;

// battery....
showBattery = false;
includeBatteryCompartment = false;

// This will vary based on the ThingyStick
coverDepth = 5; 
//coverDepth = 6;  // Photon directly on the PCB.
echo("coverDepth (Z)" , coverDepth);

include <../../ThingyStickCase.scad>;

module PcbHoleModel(x,y) {
    translate([x,y,-5]) {
        cylinder(d=3, h=10);
    }
}

module PcbModel() {
    // Different PCB!!!
     translate([2.5+4,2.5,6]) {
        cube([100,50,1.6]);
        PcbHoleModel(4,4);
        PcbHoleModel(96,36);
        PcbHoleModel(4,36);
        PcbHoleModel(96,4);
        
        translate([38.7, 0, 1.6]) {
            // 18.5mm high with headers.
            // 7mm without
            cube([23, 54, 18.5]);
        }
        
        // Top of the PCB
        translate([45, -10, 1.6 + 12.6]) {
            // USB B
            cube([10, 20, 4]);
        }
    }
}

/*
module usbPlugCutout() {
    
// This will be too low.

    
// TODO: Verify this. (12mm in Eagle).
usbPlugWidth = 14;
    
zOffset = -curveRadius + baseInnerThickness;
    
    // Offset for PCB origin
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, zOffset]) {
        // Offset Y for middle of the PCB minus 1/2 of the size of the 
        // USB plug. Assumes plug allignes with the bottom of the PCB.
        // +/- 1mm on USB plug height
        translate([-10 - (wallThickness + pcbPaddingXAxis),(pcbHeight/2) - (usbPlugWidth/2), pcbSupportHeight - 1]) {
            #cube([10 + wallThickness + pcbPaddingXAxis,usbPlugWidth,6+0.1]);
        }
    }
}

*/

module extraCutouts() {
    translate([width-3,(height-16)/2, pcbSupportHeight]) {
        #cube([5,16,14]);
    }
    
    usbPlugCutout();
}

//%PcbModel();
buildCase();