echo("BigLatchingRelay-Electron-V2.1");

pcbHeight = 31.31;

// For preutruding connector.
pcbWidth = 100;

// For cable exit.
//pcbWidth = 130;

// If to use a round hole for a cable exit.
// false uses a rectangular hole for terminal block
cableExit = false;
cableCutoutDiameter = 8;

// How thick (deep) the PCB is (typically 1.6mm)
pcbThickness = 1.6;

// Symetrical Y padding.
// Increase PCB width of additional padding at read
pcbPaddingYAxis = 4;
pcbPaddingXAxis = 1; 

// Support positions on the PCBs, relatec to the PCB corner.
// does not include bezel/wall thinckness offsets
pcbSupportPositions = []; // [[4,36,0],[96,4,0]];
pcbSupportPadPositions = [[64.55,4.0,0],[64.55,27.31,0]];
//pcbSupportPinPositions = [[4,4,0],[96,36,0],[4,36,0],[96,4,0]];
pcbSupportPinPositions = [[14,15.9,0]];
pcbSupportHeight = 7;


// How much above the USB A connector inlet to add the the base case height.
// 9mm - aligh with top of terminal block
// 14mm - align with top of relay/photon
// need 9mm / open terminal block option when using USB A Plug.
additionalBaseDepth = 14; // With Photon in headers
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
textText = "";
includeText = false;
includeArialCutouts = false;

// battery....
showBattery = false;
includeBatteryCompartment = false;

// This will vary based on the ThingyStick
// 10mm when base is 9mm padded due to relay/photon height
coverDepth = 5; 
//coverDepth = 6;  // Photon directly on the PCB.
echo("coverDepth (Z)" , coverDepth);


include <../../../../ThingyStickCase.scad>;

module PcbHoleModel(x,y) {
    translate([x,y,-5]) {
        cylinder(d=3, h=10);
    }
}

module PcbModel() {
    zOffset = -curveRadius + baseInnerThickness;
    
    // Offset the position for the case parameters.
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, zOffset+pcbSupportHeight]) {
        
        
            cube([99.04,31.31,1.6]);
        
            // USB A Plug
            translate([-16, 9.5, 0]) {
                cube([16, 12, 4.4]);
            }     
             
             
            PcbHoleModel(13.96,15.88);
            PcbHoleModel(64.55,4.06);
            PcbHoleModel(64.55,27.3);
            
            // Photon
            translate([6, 5, 1.6]) {
                cube([38, 20, 16]);
                
                // Photon USB B.
                translate([-16, 5, 10.7]) {
                    // USB B
                    cube([18, 12, 6]);
                }
            }
            
            // Relay
            translate([58.56, 9.5, 1.6]) {
                // 18.5mm high with headers.
                // 7mm without
                cube([29, 12, 16]);
            }
            
            // Terminal block
            translate([90.9, 7.5, 1.6]) {
                // 18.5mm high with headers.
                // 7mm without
                cube([12, 16, 8]);
            }
            
            
            
       
    }
}

module terminalBlockCutout() {
    if (!cableExit) {
        translate([width-3,(height-17)/2, 0]) {
            cube([5,17,10]);
        }
    }
}

module cableExitCutout() {
    if (cableExit) {
        translate([width-3,height/2, 5]) {
            rotate([0,90,0]) {
                #cylinder(d=cableCutoutDiameter, h=20);
            }
        }
    }
}

module extraCutouts() {
    translate([0,0,pcbSupportHeight]) {
        terminalBlockCutout();
        cableExitCutout();
    }
    
    
}

module extraLidCutouts() {
    
}

%PcbModel();
buildCase();