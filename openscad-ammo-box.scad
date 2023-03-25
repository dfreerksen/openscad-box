/*
Author: David Freerksen, dfreerksen@gmail.com
Date: 03/25/2023
*/

include <openscad-box.scad>

/* [System] */

// Number of fragments to draw an arc
$fn = 64;

/* [Bullet Properties] */

// Number of holes
bulletCount = 30; // [5:5:100]

// Number of holes in each column
bulletColumns = 5; // [2:10]

// Diameter of case (base diameter, not rim diameter)
bulletDiameter = 9.58; // [5:5:100]

// Bullet length
bulletHeight = 57.40; // [0.01:0.3]

// Additional clearance for bullet diameter. The smaller the number, the tighter the fit
bulletClearance = 0.05; // [0.01:0.01:0.3]

// Height of case to be sticking out from hole
bulletHeightExtended = 12 ; // [2:20]

// Gap between holes
bulletGap = 2; // [1:5]

/* [Box Properties] */

// Shell thickness
shellThickness = 3; // [3:9]

// Radius of the fillets (corners)
filletRadius = 4; // [4:20]

// Width of the ribs
ribThickness = 10; // [6:15]

// Gap clearance for joints
gapClearance = 0.3; // [0.1, 0.2, 0.3, 0.4]

module __Customizer_Limit__ () {}

// Box example overrides
showBoxExample = false;
showBoxExampleCombinedOpen = false;
showBoxExampleCombinedClosed = false;

// Bullet calculations
columnCount = floor(bulletCount/bulletColumns);
rowCount = floor(bulletCount/columnCount);
internalLength = (rowCount*bulletDiameter)+((rowCount-1)*bulletGap);
internalWidth = (columnCount*bulletDiameter)+((columnCount-1)*bulletGap);
internalLidHeight = bulletHeightExtended;
internalBaseHeightCalculated = (bulletHeight + gapClearance - bulletHeightExtended);
internalBaseHeight = (bulletHeightExtended > internalBaseHeightCalculated) ? bulletHeightExtended : internalBaseHeightCalculated;

// Hole calculations
holeDiameter = (bulletDiameter+bulletClearance);
holeHeight = (bulletHeight + gapClearance - bulletHeightExtended);

// Box calculations
internalLidFillHeight = 0;
internalBaseFillHeightCalculated = holeHeight;
internalBaseFillHeight = (bulletHeightExtended > internalBaseFillHeightCalculated) ? bulletHeightExtended : internalBaseFillHeightCalculated;

// EXAMPLE
// bottom
color([0.5, 0.5, 1])
translate([0, 0, 0])
difference() {
    // Box
    openBox(length=internalLength, width=internalWidth, height=internalBaseHeight, fill=internalBaseFillHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, top=false);

    // Holes
    union() {
        for (c = [1:columnCount])
        {
            let (columnPosition = ((-internalWidth/2)-holeDiameter+(holeDiameter/2)+(holeDiameter*c)-bulletGap+(bulletGap*c))) {
                for (r = [1:rowCount])
                {
                    let (rowPosition = ((-internalLength/2)-holeDiameter+(holeDiameter/2)+(holeDiameter*r)-bulletGap+(bulletGap*r))) {
                        // translate([rowPosition, columnPosition, (holeHeight+shellThickness+bulletClearance+1)])
                        translate([rowPosition, columnPosition, (internalBaseHeight-holeHeight+(holeHeight/2))])
                        cylinder(d=holeDiameter, h=holeHeight, center=false);
                    }
                }
            }
        }
    }
}

// top
color([1, 0.5, 1])
translate([0, (internalWidth+(filletRadius*4)+(shellThickness*4)), 0])
openBox(length=internalLength, width=internalWidth, height=internalLidHeight, fill=internalLidFillHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, top=true);
