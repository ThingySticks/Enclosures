echo("Wide Feather ProtoType");

// Different feather boards might be longer.
// PCB is 50mm.
// PCB size needs to be correct for USB A middle point.
pcbHeight = 60;
pcbWidth = 100;
// How thick (deep) the PCB is (typically 1.6mm)
pcbThickness = 1.6;

pcbPaddingYAxis = 1;
pcbPaddingXAxis = 5; // 1mm from the wall.

// Support positions on the PCBs, relatec to the PCB corner.
// does not include bezel/wall thinckness offsets
pcbSupportPositions = [];
pcbSupportPadPositions = [[4,4,0],[96,46,0],[4,46,0],[96,4,0]];
//pcbSupportPinPositions = [[4,4,0],[96,46,0],[4,46,0],[96,4,0]];
pcbSupportPinPositions = [];
pcbSupportHeight = 17;

// How much above the USB A connector inlet to add the the base case height.
additionalBaseDepth = 10;

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
textText = "Feather";
includeText = false;
includeArialCutouts = false;

// battery....
showBattery = false;
includeBatteryCompartment = false;

// This will vary based on the ThingyStick
coverDepth = 5; 
//coverDepth = 6;  // Photon directly on the PCB.
echo("coverDepth (Z)" , coverDepth);

include <../ThingyStickCase.scad>;

module PcbHoleModel(x,y) {
    translate([x,y,-5]) {
        cylinder(d=3, h=10);
    }
}

// Note USB A plug is on RHS, but to make case easier
// use PCB upside-down
module PcbModel() {
    translate([2.5+4,2.5,15]) {
        cube([100,50,1.6]);
        PcbHoleModel(4,4);
        PcbHoleModel(96,46);
        PcbHoleModel(4,46);
        PcbHoleModel(96,4);
        
        translate([38.7, 0, -14]) {
            // 18.5mm high with headers.
            // 7mm without
            cube([23, 54, 14]);
        }
        
        
        translate([45, -10, -12]) {
            // USB B
            cube([10, 20, 4]);
        }
    }
}

module extraCutouts() {
    
    if (includeUsbPlugCutout) {
              //  usbPlugCutout();
    }
    
    translate([46+4,-10, 1]) {
        #cube([13,15,8]);
    }
}

%PcbModel();
buildCase();