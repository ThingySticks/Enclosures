
// Size of the outer (bezel/padding/blah) that surounds the PCB
// NB: This is both length and width padding.
//bezelSize = 3;
pcbPaddingYAxis = 2;
pcbPaddingXAxis = 1; // 1mm from the wall.

// Thickness of the wall.
wallThickness = 1.5;

////////////////////////////////////////////////////////////////////////
// Uniqie for each PCB.
////////////////////////////////////////////////////////////////////////
// PCB size we are trying to fit.
pcbHeight = 40;
pcbWidth = 100;
// How thick (deep) the PCB is (typically 1.6mm)
pcbThickness = 1.6;

// Support positions on the PCBs, relatec to the PCB corner.
// does not include bezel/wall thinckness offsets
pcbSupportPositions = [[4,36,0],[96,4,0]];
pcbSupportHeight = 8;

pcbSupportPinPositions = [[4,4,0],[96,36,0]];
pcbSupportHeight = 8;

// How much above the USB A connector inlet to add the the base case height.
// Typical is 0mm.
additionalBaseDepth = 0;

////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Variables for user configuration of the build.
////////////////////////////////////////////////////////////////////////

// How big to make the holes for the screws in the PCB supports.
// 
//screwHoldSize = 4.0;  // 4mm for threaded inserts
screwHoldSize = 2.0;  // 2mm for self tappers
//
// If the USB A Plug is fitted to the board, cutout
// space for it to go through the case.
includeUsbPlugCutout = true;
// If the PCB has a second connector (e.g. relay)
// if this should be cutout.
includeConnectorCutout = true; // 3pin/5pin/Thermocouple end connectors etc.
// If a hole should be cutout for the Photons USB micro B socket to 
// allow power connection.
includePhotonUsbSocketCutout = false;
////////////////////////////////////////////////////////////////////////

usbConnectorHeight = 5;

// How think the bottom of the base is.
baseInnerThickness = 2;

// Overall size
// Y Size
height = pcbHeight + (2*pcbPaddingYAxis) + (2*wallThickness);
// X axis size.
width = pcbWidth + (2*pcbPaddingXAxis) + (2*wallThickness);

baseDepth = (pcbSupportHeight + usbConnectorHeight) + additionalBaseDepth;
coverDepth = 15;

// Build options.
showBase = true;
showCover = false;


// -----------------------------------------
// -----------------------------------------
module GenericBase(xDistance, yDistance, zHeight) {
	// roundedBox([xDistance, yDistance, zHeight], 2, true);

	// Create a rectangluar base to work from that
	// is xDistance by yDistance and zHeight height.

	// This is effectivly a cube with rounded corners

	// extend the base out by ... from holes by using minkowski
	// which gives rounded corners to the board in the process
	// matching the Gadgeteer design
	
	$fn=50;
	radius = 4; //bezelSize;

	translate([radius,radius,0]) {
		minkowski()
		{
			// 3D Minkowski sum all dimensions will be the sum of the two object's dimensions
			cube([xDistance-(radius*2), yDistance-(radius*2), zHeight /2]);
			cylinder(r=radius,h=zHeight/2);
		}
	}
}

// -----------------------------------------
// Outer wall
// Creates a base cube then hollows it out to create 
// a wall.
// -----------------------------------------
module OuterWall() {

innerCutoutOffset = wallThickness;
    
	difference() {
		union() {
			GenericBase(width, height, baseDepth);
		}
		union() {
			// Cut out the bulk of the inside of the box.
			// Outerwall padding = 5
			// Move in 5, down 5 and up 2 to provide an 
			// outline of 5x5 with 2 base.
			translate([innerCutoutOffset, innerCutoutOffset, baseInnerThickness]) {
				GenericBase(width - (innerCutoutOffset * 2), 
									height - (innerCutoutOffset *2), 
									(baseDepth - baseInnerThickness) + 0.1);
			}
		}
	}
}

// -----------------------------------------
// -----------------------------------------
//module PcbCutout() {
	// Move to a slight offset to allow for an outer bezel.
	// and position so the top of the pcb is at the top of the base box.
//	translate([bezelSize, bezelSize, depth - (pcbThickness - 0.1)]) {
//		GenericBase(pcbWidth, pcbHeight, pcbThickness);
//	}
//}

module pcbSupport(position, height) {
        
    // Offset the position for it's PCB position
    translate(position) {
        difference() {
            union() {            
                cylinder(d=6, h=height, $fn=50);
            }
            union() {
                translate(0,0,baseInnerThickness) {
                    cylinder(d=screwHoldSize, h=height, $fn=50);
                }
            }
        }
    }
}

module pcbSupportPin(position, height) {
       
    // Offset the position for it's PCB position
    translate(position) {
        cylinder(d=6, h=height, $fn=50);
        cylinder(d1=3.0,d2=2.2, h=height + 3, $fn=50);    
    }
}

module addSupports() {
    // Offset the position for the case parameters.
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, 0]) {
        
        // Add PCB supports with holes for screws
        for(pcbSupportPosition = pcbSupportPositions) {
            pcbSupport(pcbSupportPosition, pcbSupportHeight);
        }
        
        // Add PCB supports with pins to help alignment (and save on screws).
        for(pcbSupportPinPosition = pcbSupportPinPositions) {
            pcbSupportPin(pcbSupportPinPosition, pcbSupportHeight);
        }
    }
}

module usbPlugCutout() {
    // Offset for PCB origin
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, 0]) {
        // Offset Y for middle of the PCB minus 1/2 of the size of the 
        // USB plug. Assumes plug allignes with the bottom of the PCB.
        translate([-10 - (wallThickness + pcbPaddingXAxis),(pcbHeight/2) -7 ,pcbSupportHeight]) {
            #cube([10 + wallThickness + pcbPaddingXAxis,14,5+0.1]);
        }
    }
}

module marker() {
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, 0]) {
        translate([wallThickness + pcbPaddingXAxis + 100 ,wallThickness + pcbPaddingYAxis+40,0]) {
            #cylinder(d=1,h=20);
        }
    }
}

// -----------------------------------------
// -----------------------------------------
module Base() {
	
	innerWallOffset = 4;

	difference() {
		union() 
		{
			// Outer base wall
			OuterWall();
            addSupports();
            //marker();
		}		
		union() 
		{
			//PcbCutout(); 
            if (includeUsbPlugCutout) {
                usbPlugCutout();
            }
		}
	}
}

// -----------------------------------------
// -----------------------------------------
module Cover() {
    
    coverWallThickness = 2;
    coverDepth = depth;
    
    difference() {
		union() {
			GenericBase(width + coverWallThickness*2, height + coverWallThickness*2, coverDepth);
		}
		union() {
			// Hollow out the 
			//translate([innerCutoutOffset, innerCutoutOffset, baseInnerThickness]) {
            translate([2+0.2,2+0.2,0]) {
				#GenericBase(width-(+0.4), height-(+0.4), coverDepth);
			}
		}
	}
}

if (showBase) {
    Base();
}

if (showCover) {
    // Offset the cover
    translate([0,0,100]) {
        Cover();
    }
}