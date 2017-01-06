$fn=100;  

// Size of the outer (bezel/padding/blah) that surounds the PCB
// NB: This is both length and width padding.
//bezelSize = 3;
pcbPaddingYAxis = 3;
pcbPaddingXAxis = 1; // 1mm from the wall.

// Thickness of the wall.
wallThickness = 1.5;

useRoundedTopAndBottom = true;

////////////////////////////////////////////////////////////////////////
// Uniqie for each PCB.
////////////////////////////////////////////////////////////////////////
// PCB size we are trying to fit.
/*
// -----------------------
// Wide Photon Prototype.
// -----------------------
pcbHeight = 40;
pcbWidth = 100;
// How thick (deep) the PCB is (typically 1.6mm)
pcbThickness = 1.6;

// Support positions on the PCBs, relatec to the PCB corner.
// does not include bezel/wall thinckness offsets
pcbSupportPositions = []; // [[4,36,0],[96,4,0]];
pcbSupportHeight = 8;

pcbSupportPinPositions = [[4,4,0],[96,36,0],[4,36,0],[96,4,0]];
pcbSupportHeight = 8;

// How much above the USB A connector inlet to add the the base case height.
// Typical is 0mm.
additionalBaseDepth = 0;

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

*/

/*
// -----------------------
// Quat N-Channel FETS 
// -----------------------
pcbHeight = 40;
pcbWidth = 100;
// How thick (deep) the PCB is (typically 1.6mm)
pcbThickness = 1.6;

// Support positions on the PCBs, relatec to the PCB corner.
// does not include bezel/wall thinckness offsets
pcbSupportPositions = []; // [[4,36,0],[96,4,0]];
//pcbSupportHeight = 8;

pcbSupportPinPositions = [[14.5,20,0],[95,4,0],[95,36,0]];
// support height from z=0, not the inside of the case.
pcbSupportHeight = 4;

// How much above the USB A connector inlet to add the the base case height.
// Typical is 0mm.
additionalBaseDepth = 0;

// This configuration directly expose the full width
// of the 5 way connector.
// 10-30 on Y scale.

// Y start position and how far along
// Compute the X start and end based on case size
// Compute the Z start position base and size based on
// the support heights, base height, top height and cutout height required.
endCutoutYStartPosition = 10;
endCutoutHeight = 20;
// Overall Z height - shared between base and top
endCutoutZHeight = 8; 
includeEndCutout = true;

textPosition = [30,21,-3];
textText = "N FET";
*/

// -----------------------
// Electron Prototype
// -----------------------
pcbHeight = 44;
pcbWidth = 100;
// How thick (deep) the PCB is (typically 1.6mm)
pcbThickness = 1.6;

// Support positions on the PCBs, relatec to the PCB corner.
// does not include bezel/wall thinckness offsets
pcbSupportPositions = [[96,4,0],[96,40,0]];
//pcbSupportHeight = 8;

pcbSupportPinPositions = [[14.5,22,0]];
// support height from z=0, not the inside of the case.
pcbSupportHeight = 3;

// How much above the USB A connector inlet to add the the base case height.
// Typical is 0mm.
additionalBaseDepth = 0;

// This configuration directly expose the full width
// of the 5 way connector.
// 10-30 on Y scale.

// Y start position and how far along
// Compute the X start and end based on case size
// Compute the Z start position base and size based on
// the support heights, base height, top height and cutout height required.
endCutoutYStartPosition = 8;
endCutoutHeight = 28;
// Overall Z height - shared between base and top
endCutoutZHeight = 6; 
includeEndCutout = false;
textPosition = [30,21,-3];
textText = "Electron";


////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Variables for user configuration of the build.
////////////////////////////////////////////////////////////////////////

// How big to make the holes for the screws in the PCB supports.
// 
screwHoldSize = 4.0;  // 4mm for threaded inserts for machine screws
//screwHoldSize = 2.0;  // 2mm for self tappers
//
// If the USB A Plug is fitted to the board, cutout
// space for it to go through the case.
includeUsbPlugCutout = true;
//
// If the PCB has a second connector (e.g. relay)
// if this should be cutout.
includeConnectorCutout = true; // 3pin/5pin/Thermocouple end connectors etc.
//
// If a hole should be cutout for the Photons USB micro B socket to 
// allow power connection.
includePhotonUsbSocketCutout = false;
////////////////////////////////////////////////////////////////////////

usbConnectorHeight = 5;

// How think the bottom wall of the base is.
baseInnerThickness = 1.5;

// Overall size
// Y Size
height = pcbHeight + (2*pcbPaddingYAxis) + (2*wallThickness);
echo("Height (Y)" , height);

// X axis size.
width = pcbWidth + (2*pcbPaddingXAxis) + (2*wallThickness);
echo("Width (X)" , width);

// How deep the base box is.
// This excludes the very bottom wall.
baseDepth = (pcbSupportHeight + usbConnectorHeight) + additionalBaseDepth;
//baseDepth = 8;
echo("baseDepth (Z)" , baseDepth);

// This will vary based on the ThingyStick
coverDepth = 17; // Socketed Photon (min 15mm with photon in socket).
//coverDepth = 6;  // Photon directly on the PCB.
echo("coverDepth (Z)" , coverDepth);

// Build options.
showBase = false;
showCover = true;

curveRadius = 4; // was 4

// -----------------------------------------
// -----------------------------------------
module GenericBase(xDistance, yDistance, zHeight, zAdjust) {
	    
    // NB: base drops below 0 line by the curve radius so we need to compensate for that
	translate([curveRadius,curveRadius, zAdjust]) {
		minkowski()
		{
			// 3D Minkowski sum all dimensions will be the sum of the two object's dimensions
			cube([xDistance-(curveRadius*2), yDistance-(curveRadius*2), (zHeight /2)]);
			cylinder(r=curveRadius,h= (zHeight/2) + curveRadius);
		}
	}
}

module RoundedBase(xDistance, yDistance, zHeight) {
    
    // Lower part with all rounded edges.
    // Case will sit below 0 line by curveRadius mm
    
    translate([curveRadius,curveRadius,0]) {
        difference() {        
            union() {    
                minkowski()
                {
                    // 3D Minkowski sum all dimensions will be the sum of the two object's dimensions
                    cube([xDistance-(curveRadius*2), yDistance-(curveRadius*2), curveRadius]);
                    //cylinder(r=radius,h=zHeight/2);
                    sphere(r=curveRadius);
                }
            }
            union() {
                 //sphere(r=curveRadius);

                // Cut off above the bottom (or top) 2/3s of the rounded cube to leave only the 
                // curved part and very edge.
                // This really only matters where the height < (3 x curveRadius)
                translate([-curveRadius,-curveRadius,  0]) {
                    cube([xDistance + 0.01, yDistance +0.01, curveRadius*2]);
                }
            } 
        }
	} 

    echo("zHeight",zHeight);    
wallHeight = (zHeight - curveRadius)/2;
    echo("wallHeight",wallHeight);    
    
    // Upper part with rounded coners and flat top/bottom.
	translate([curveRadius,curveRadius,0]) {
		minkowski()
		{
			// 3D Minkowski sum all dimensions will be the sum of the two object's dimensions
			cube([xDistance-(curveRadius*2), yDistance-(curveRadius*2), wallHeight]);
			cylinder(r=curveRadius, h= wallHeight);
		}
	}
}


module RoundedTop(xDistance, yDistance, zHeight) {
    
    union() {       
        // Lower part with all rounded edges.
        translate([curveRadius,curveRadius,zHeight-curveRadius]) {
            difference() {
                union() {
                    minkowski()
                    {
                        // 3D Minkowski sum all dimensions will be the sum of the two object's dimensions
                        cube([xDistance-(curveRadius*2), yDistance-(curveRadius*2), curveRadius]);
                        // This does every edge of the cube.
                        sphere(r=curveRadius);
                    }
                }
                
                union() {
                    // Cut off above the bottom (or top) 2/3s of the rounded cube to leave only the 
                    // curved part and very edge.
                    // This really only matters where the height < (3 x curveRadius)
                    translate([-curveRadius,-curveRadius, - (curveRadius)]) {
                        cube([xDistance + 0.01, yDistance +0.01, curveRadius*2]);
                    }
                } 
            }
        }  
        
//wallHeight+baseInnerThickness +  == very top.
    echo("cover zHeight",zHeight);    
wallHeight = (coverDepth - curveRadius);
    echo("cover wallHeight",wallHeight);   
        
        
        
        // coverDepth

        // Upper part with rounded coners and flat top/bottom.
        translate([curveRadius,curveRadius, curveRadius]) {
           // #cube([xDistance-(curveRadius*2), yDistance-(curveRadius*2), wallHeight + curveRadius]);
            minkowski()
            {
                // 3D Minkowski sum all dimensions will be the sum of the two object's dimensions
                cube([xDistance-(curveRadius*2), yDistance-(curveRadius*2), wallHeight/2]);
                cylinder(r=curveRadius,h= wallHeight/2);
            }
        }
    }
}

// -----------------------------------------
// Main body for base case.
// -----------------------------------------
module OuterWall() {

innerCutoutOffset = wallThickness;
    
echo("baseDepth",baseDepth);
    
	difference() {
		union() {
            if (useRoundedTopAndBottom) {
                // rounded base doesn't print well on Ultimaker.
                RoundedBase(width, height, baseDepth);
            } else {
                GenericBase(width, height, baseDepth);
            }
		}
		union() {
			// Cut out the bulk of the inside of the box.
			// Outerwall padding = 5
			// Move in 5, down 5 and up 2 to provide an 
			// outline of 5x5 with 2 base.
            // Make it much bigger in Z axis to ensure clearing
			translate([innerCutoutOffset, innerCutoutOffset, baseInnerThickness]) {
				GenericBase(width - (innerCutoutOffset * 2), 
									height - (innerCutoutOffset *2), 
									(baseDepth - baseInnerThickness) +10,
                                    -curveRadius);
			}
		}
	}
}

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

// Hole for screw to go through from the base to the top.
module pcbSupportScrewHole(position, height) {
       
    // Offset the position for it's PCB position
    /*
    translate(position) {
        cylinder(d=6, h=height);
        cylinder(d=2.9, h=height + (pcbThickness*2));    
    }
    */
    
    color("blue") {
        // Lift off the Z axis floor a little to stop the 
        // edges sticking out where the mount is on a curved conrer.
        translate(position) {
            difference() {
                
                cylinder(d=8, h= (height));
                cylinder(d=3.6, h= (height) + (pcbThickness*2) + baseInnerThickness);    
            }
        }
    }
}

module pcbSupportPin(position, height) {
       
    // Offset the position for it's PCB position
    translate(position) {
        cylinder(d=6, h=height);
        cylinder(d=2.9, h=height + (pcbThickness*2));    
    }
}

module countersink(position) {
       
    // Offset the position for it's PCB position
    translate(position) {
        translate([0,0,- (baseInnerThickness )]) {
            // the actual countersink
            cylinder(d1=7, d2=3.6, h=baseInnerThickness+0.1);    
            // Make a hole through the base wall.
            cylinder(d=3.6, h=baseInnerThickness+0.1);    
        }
    }
}

module addCountersinks() {
    zOffset = -2.5; // -2 to get them on the very floor
    echo("baseInnerThickness",baseInnerThickness);
    
    // Offset the position for the case parameters.
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, zOffset]) {
                
        // Add PCB supports with pins to help alignment (and save on screws).
        for(pcbSupportPinPosition = pcbSupportPositions) {
            countersink(pcbSupportPinPosition, pcbSupportHeight+ 2.5);
        }
    }
}

module addSupports() {
    
    // Offset to be ON the top of the base floor
    // otherwise Cura doesn't provide a strong support
    zOffset = -curveRadius + baseInnerThickness;
    echo("baseInnerThickness",baseInnerThickness);
    
    // Offset the position for the case parameters.
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, zOffset]) {
        
        // Add PCB supports with holes for screws
        for(pcbSupportPosition = pcbSupportPositions) {
            pcbSupportScrewHole(pcbSupportPosition, pcbSupportHeight);
        }
        
        // Add PCB supports with pins to help alignment (and save on screws).
        for(pcbSupportPinPosition = pcbSupportPinPositions) {
            pcbSupportPin(pcbSupportPinPosition, pcbSupportHeight);
        }
    }
}

module usbPlugCutout() {
    
// TODO: Verify this.
usbPlugWidth = 13;
    
zOffset = -curveRadius + baseInnerThickness;
    
    // Offset for PCB origin
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, zOffset]) {
        // Offset Y for middle of the PCB minus 1/2 of the size of the 
        // USB plug. Assumes plug allignes with the bottom of the PCB.
        translate([-10 - (wallThickness + pcbPaddingXAxis),(pcbHeight/2) - (usbPlugWidth/2) ,pcbSupportHeight]) {
            cube([10 + wallThickness + pcbPaddingXAxis,usbPlugWidth,5+0.1]);
        }
    }
}

module baseEndCutout() {
   
    zStart = pcbSupportHeight + pcbThickness;
    echo(zStart);
    
    // Move to the end of the case just before the wall starts.
    // cut out the thinkness of the wall + a little extra
    translate([width - (wallThickness + 0.1), endCutoutYStartPosition + pcbPaddingYAxis + wallThickness, zStart]) {
        // Z height shouldn't matter with the base as it should always
        // go above the top of it (otherwise we need supports/bridging)
        #cube([wallThickness + 0.2, endCutoutHeight, endCutoutZHeight]);
    }
}

// Add some text to the base.
module addText() {
    translate(textPosition) {
        linear_extrude(height = 1) {
            text(textText);
        }
    }
}

module marker() {
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, 0]) {
        translate([wallThickness + pcbPaddingXAxis + 100 ,wallThickness + pcbPaddingYAxis+40,0]) {
            cylinder(d=1,h=20);
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
            addText();
            //marker();
		}		
		union() 
		{
			//PcbCutout(); 
            if (includeUsbPlugCutout) {
                usbPlugCutout();
            }
            if (includeEndCutout) {
                baseEndCutout();
            }
            
            addCountersinks();
		}
	}
}

// =========================================================================================
// COVER
// =========================================================================================

// Main body for cover.
module CoverOuterWall() {

innerCutoutOffset = wallThickness;
    
	difference() {
		union() {
			RoundedTop(width, height, coverDepth);
		}
		union() {
			// Cut out the bulk of the inside of the box.
			// Outerwall padding = 5
			// Move in 5, down 5 and up 2 to provide an 
			// outline of 5x5 with 2 base.
			translate([innerCutoutOffset, innerCutoutOffset,]) {
				GenericBase(width - (innerCutoutOffset * 2), 
									height - (innerCutoutOffset *2), 
									(coverDepth - baseInnerThickness),
                                    0);
			}
		}
	}
}

module pcbSupportPeg(position,height) {
           
    // Offset the position for it's PCB position
    translate(position) {
        difference() {
            union() {
                cylinder(d=8, h=height);
            }
            union() {
                // 3mm + a little tolerance
                #cylinder(d1=3.5, d2=3.2, h=(height - 2), $fn=50);    
            }
        }
        
    }
}

module pcbScrewMountPen(position,height) {
           
    // Offset the position for it's PCB position
    color("blue") {
        translate(position) {
            difference() {
                union() {
                    cylinder(d=8, h=height);
                }
                union() {
                    // 3mm + a little tolerance
                    #cylinder(d=screwHoldSize, h=(height - 2));    
                }
            }
        }
    }
}

// Used in the cover to for the screws from the base to connect into.
module addPcbSupportPegs() {
    
zOffset =  baseDepth - pcbSupportHeight - pcbThickness; 
    
    // Offset the position for the case parameters.
    // Needs to come down into the base by xxx - pcbThickness.
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, -zOffset]) {
        
        // Only the center pin under the photon uses pins now
        // ald theirs no point in having the top peg for it
        // as this will hit the photon or electron.
        // Add PCB supports with pins to help alignment (and save on screws).
        for(pcbSupportPinPosition = pcbSupportPinPositions) {
            // Peg needs to go the full length of the case
            // -0.5 hack to stop Cura printing detailed bits first instead of flat
            //pcbSupportPeg(pcbSupportPinPosition, coverDepth + zOffset - 0.5);
        }
        
        // Add screw nut mounts (where base has a screw hole protruding through
        // Add PCB supports with pins to help alignment (and save on screws).
        for(pcbSupportPinPosition = pcbSupportPositions) {
            // Peg needs to go the full length of the case
            // -0.5 hack to stop Cura printing detailed bits first instead of flat
            pcbScrewMountPen(pcbSupportPinPosition, coverDepth + zOffset - 0.5);
        }
    }
}

// Add some runners to the inside of the walls 
// to (friction) latch the case together.
module addLatchingRunners() {

// This is where the wall begins (open side).
zZero = -curveRadius; //(coverDepth - curveRadius);
    
// How far in from the x axis edge.
runnerEdgeOffset = 15;
// Y Axis depth.    
runnerDepth = 1.5; 
    
// How far into the base.
// runner Overlap into the base .
runnerOverlap = 3;
   
    // Set the z position so the runners start at the "inner floor" of the cover.
    translate([0,0,- (zZero + runnerOverlap)]) {
    
        // Near side
        translate([runnerEdgeOffset, wallThickness, 0]) {
            // -0.5 hack to stop Cura printing detailed bits first instead of flat
            //cube([width - (runnerEdgeOffset * 2),runnerDepth,coverDepth + zOffset-0.5]);
            
            // runner height = coverDepth - baseInnerThickness -> gives the wall height from inside.
            // Add on the extra required to sit inside the base...
            cube([width - (runnerEdgeOffset * 2),runnerDepth,coverDepth - baseInnerThickness + runnerOverlap]);
        }
            
        // Far side.
        translate([runnerEdgeOffset, height - wallThickness- runnerDepth, 0]) {
            cube([width - (runnerEdgeOffset * 2),runnerDepth,coverDepth - baseInnerThickness + runnerOverlap]);
        }
    }
}

module coverEndCutout() {
    // todo...
    
    // Compute how much of the end cutout was cut into the base.
    zStart = pcbSupportHeight + pcbThickness;
    zHeightInBase = baseDepth - zStart;
    // What ever wasn't cut into the base needs to go into the cover.
    zHeightInCover = endCutoutZHeight - zHeightInBase;
    echo(zHeight);
    
    // coverDepth
    
    // Move to the end of the case just before the wall starts.
    // cut out the thinkness of the wall + a little extra
    translate([width - (wallThickness + 0.1), endCutoutYStartPosition + pcbPaddingYAxis + wallThickness, 0]) {
        // Z height shouldn't matter with the base as it should always
        // go above the top of it (otherwise we need supports/bridging)
        #cube([wallThickness + 0.2, endCutoutHeight, zHeightInCover]);
    }
}

// -----------------------------------------
// -----------------------------------------
module Cover() {
   
    difference() {
		union() {
			CoverOuterWall();
            // Add snaps to align top and hold it into place.
            addPcbSupportPegs();
            addLatchingRunners();
		}
		union() {
            //
            if (includePhotonUsbSocketCutout) {
                // TODO: Cutout USB Micro B hole for lead to connect to Photon
            }
            
            if (includeEndCutout) {
                coverEndCutout();
            }
		}
	}
}

if (showBase) {
    Base();
}

if (showCover) {
    // Offset the cover
    //translate([0,0,100]) {
    translate([0,0,baseDepth+4]) {
        Cover();
    }
}