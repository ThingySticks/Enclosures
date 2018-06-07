$fn=100;  

// Size of the outer (bezel/padding/blah) that surounds the PCB
// NB: This is both length and width padding.
//bezelSize = 3;

// Override in case
//pcbPaddingYAxis = 3;
//pcbPaddingXAxis = 1; // 1mm from the wall.

// Thickness of the wall.
wallThickness = 1.5;

useRoundedTopAndBottom = false;

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
                // Compensate for the rounding missing
                translate([0,0,-curveRadius]) {
                    GenericBase(width, height, baseDepth-curveRadius);
                }
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

module pcbSupportPad(position, height) {
    color("green") {
        // Lift off the Z axis floor a little to stop the 
        // edges sticking out where the mount is on a curved conrer.
        translate(position) {
            difference() {
                union() {
                    cylinder(d=8, h=height);
                }
                union() {
                    translate([0,0,2.1]) {
                        cylinder(d=4.2, h=height-2);    
                    }
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
        
        // Add PCB supports with holes for screws through the base.
        for(pcbSupportPosition = pcbSupportPositions) {
            pcbSupportScrewHole(pcbSupportPosition, pcbSupportHeight);
        }
        
        // Add PCB supports with pins to help alignment (and save on screws).
        for(pcbSupportPinPosition = pcbSupportPinPositions) {
            pcbSupportPin(pcbSupportPinPosition, pcbSupportHeight);
        }
        
        // Add PCB supports with holes for screws through the base.
        for(pcbSupportPadPosition = pcbSupportPadPositions) {
            pcbSupportPad(pcbSupportPadPosition, pcbSupportHeight);
        }
    }
}

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



module baseEndCutout() {
   
    // remove pcbSupportHeight?
    zStart = pcbSupportHeight + pcbThickness + endCutoutZAdjust;
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
        linear_extrude(height = 1.5) {
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

// Make a compartment around the 
module makeBatteryCompartment() {
    
batteryCompartmentSize = [76,44,12];
    
pin = pcbSupportPinPositions[0];
batteryStartX = pin[0] 
    ;
batteryStartY = (height/2) - (batteryCompartmentSize[1]/2);
    
    
    difference() {
        union() {
            translate([batteryStartX-2, batteryStartY, wallThickness]) {
                color("red") {
                    cube(batteryCompartmentSize);
                }
            }
        }
        union() {
            showBatteryModel();
        }
    }
}

module showBatteryModel() {
// batterySize = [53,35,12.1]; - good fit. 
batterySize = [56,37,12.1];
// Assume the 1st pin is for the middle "under" photon/electron pin.
pin = pcbSupportPinPositions[0];

batteryStartX = pin[0] + 10;
batteryStartY = (height/2) - (batterySize[1]/2);
    
    
    color("grey") {
        translate([batteryStartX, batteryStartY,wallThickness]) {
            // battery
            cube(batterySize);
        
            // TODO: From battery to wall.
            // Wide height the same as battery to give a better cutout.
            translate([0,-5,5]) {
                // wires...
                cube([4,10,batterySize[2]-5]);
            }
        }
    }
}

module battery() {
    if (showBattery) {
        showBatteryModel();
    }
    
    if (includeBatteryCompartment) {
        makeBatteryCompartment();
    }
}

// -----------------------------------------
// -----------------------------------------
module Base() {
    	
	innerWallOffset = 4;
    
    echo("X Offset", wallThickness + pcbPaddingXAxis);
    echo("Y Offset", wallThickness + pcbPaddingYAxis);

	difference() {
		union() 
		{
			// Outer base wall
			OuterWall();
            addSupports();
            
            if (includeText) {
                addText();
            }
            
            if (useRoundedTopAndBottom) {
                battery();
            } else {
                translate([0,0,-curveRadius]) {
                    battery();
                } 
            }
            //marker();
		}		
		union() 
		{
			//PcbCutout(); 
            
            // Add this to case specific extraCutouts...
            //if (includeUsbPlugCutout) {
            //    usbPlugCutout();
            //}

            if (includeEndCutout) {
                baseEndCutout();
            }
                        
            addCountersinks();
            
            // Implement in case specific file...
            extraCutouts();
		}
	}
}

// =========================================================================================
// COVER
// =========================================================================================

module arialCutouts() {
    // Position 53mm from front edge.
    // Add in both sides.
    
    // Move out by wallThickness.
    
    translate([54, 4.5, 6]) {
        
        // rotate to it's pointing to the other wall.
        rotate([90,0,0]) {
            #cylinder(d=2, h=wallThickness * 3);
        }
        translate([-1, -4.5, -6]) {
            #cube([2,wallThickness *3,6]);
            
        }
    }
    
    translate([53, height-wallThickness+2, 6]) {
        
        // rotate to it's pointing to the other wall.
        rotate([90,0,0]) {
            #cylinder(d=2, h=wallThickness * 3);
        }
        translate([-1, -4.5, -6]) {
            #cube([2,wallThickness *3,6]);
            
        }
    }
}

// Main body for cover.
module CoverOuterWall() {

innerCutoutOffset = wallThickness;
    
	difference() {
		union() {

            translate([0,0,curveRadius]) {
                GenericBase(width, height, coverDepth-curveRadius);
            }
            
            // 0.2mm tollerance for push fit.
            translate([wallThickness+0.1, wallThickness+0.1,0]) {
                GenericBase(width - (wallThickness * 2) - 0.2, 
                                height - (wallThickness *2) - 0.2, 
                                (coverDepth - baseInnerThickness),
                                0);
            }
		}
		union() {
			// Cut out the bulk of the inside of the box.
			// Outerwall padding = 5
			// Move in 5, down 5 and up 2 to provide an 
			// outline of 5x5 with 2 base.
			translate([innerCutoutOffset+1.25, innerCutoutOffset+1.25,-0.1]) {
				GenericBase(width - (innerCutoutOffset * 2)-2.5, 
									height - (innerCutoutOffset *2)-2.5, 
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

module pcbScrewMountPeg(position,height) {
           
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

// Where the wall begins.    
zZero = -curveRadius; //(coverDepth - curveRadius);
    
// How much to add to the pegs to protrude into the base.
extendZBy = baseDepth - pcbSupportHeight - pcbThickness; 
echo ("extendZBy", extendZBy);
    
// Peg needs to go the full length of the case
// -0.5 hack to stop Cura printing detailed bits first instead of flat
pegHeight = coverDepth -baseInnerThickness + extendZBy; // + baseInnerThickness;// <- puts the peg into the wall.
echo ("pegHeight", pegHeight);
   

// The start Z position of the peg. This needs to be corrected for the 
// peg height so that it touches the inner surface of the wall.
pegZStart = curveRadius - extendZBy; // -0.5;
    
    // Offset the position for the case parameters.
    // Needs to come down into the base by xxx - pcbThickness.
    translate([wallThickness + pcbPaddingXAxis, wallThickness + pcbPaddingYAxis, pegZStart]) {
        
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
            pcbScrewMountPeg(pcbSupportPinPosition, pegHeight);
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
            //addPcbSupportPegs();
		}
		union() {
            //
            if (includePhotonUsbSocketCutout) {
                // TODO: Cutout USB Micro B hole for lead to connect to Photon
            }
            
            if (includeEndCutout) {
                coverEndCutout();
            }
            
            if (includeArialCutouts) {
                arialCutouts();
            }
		}
	}
}

module buildCase() {

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
}