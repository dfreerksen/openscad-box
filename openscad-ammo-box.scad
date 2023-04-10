/*
Author: David Freerksen, dfreerksen@gmail.com
Date: 03/25/2023
*/

// Include box
use <openscad-rod-box.scad>

/* [Bullet Properties] */

// Number of holes
bulletCount = 20; // [5:100]

// Number of holes in each column
bulletColumns = 4; // [2:12]

// Diameter of bullet (base diameter, not rim diameter). Get this from Wikipedia
bulletDiameter = 9.93;

// Bullet overall length. Get this from Wikipedia
bulletHeight = 29.69;

// Bullet case length. Get this from Wikipedia
bulletCaseHeight = 19.15;

// Additional clearance for bullet diameter. The smaller the number, the tighter the fit
bulletClearance = 0.06; // [0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08]

// Gap between holes
bulletGap = 1.6;

/* [Box Properties] */

// Shell thickness
shellThickness = 3; // [3:9]

// Radius of the fillets (corners)
filletRadius = 4; // [4:20]

// Width of the ribs
ribThickness = 10; // [6:15]

// Rod thickness
rodThickness = 3; // [2:5]

// Gap clearance for joints
gapClearance = 0.3; // [0.1, 0.2, 0.3, 0.4]

module __Customizer_Limit__ () {}

// Number of fragments to draw an arc
$fn = 64;

// Bullet calculations
columnCount = floor(bulletCount/bulletColumns);
rowCount = floor(bulletCount/columnCount);
internalLength = (rowCount*bulletDiameter)+((rowCount-1)*bulletGap);
internalWidth = (columnCount*bulletDiameter)+((columnCount-1)*bulletGap);
internalLidHeight = (bulletHeight-bulletCaseHeight);
internalBaseHeightCalculated = (bulletHeight+gapClearance-internalLidHeight);
internalBaseHeight = (internalLidHeight > internalBaseHeightCalculated) ? internalLidHeight : internalBaseHeightCalculated;

// Hole calculations
holeDiameter = (bulletDiameter+bulletClearance);
holeHeight = (bulletHeight+gapClearance-internalLidHeight);

// Box calculations
internalLidFillHeight = 0;
internalBaseFillHeightCalculated = holeHeight;
internalBaseFillHeight = (internalLidHeight > internalBaseFillHeightCalculated) ? internalLidHeight : internalBaseFillHeightCalculated;

// EXAMPLE
// bottom
color([0.5, 0.5, 1])
translate([0, 0, 0])
difference() {
    // Box
    openRodBox(length=internalLength, width=internalWidth, height=internalBaseHeight, fill=internalBaseFillHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, top=false);

    // Holes
    union() {
        for (c = [1:columnCount])
        {
            let (columnPosition = ((-internalWidth/2)-holeDiameter+(holeDiameter/2)+(holeDiameter*c)-bulletGap+(bulletGap*c))) {
                for (r = [1:rowCount])
                {
                    let (rowPosition = ((-internalLength/2)-holeDiameter+(holeDiameter/2)+(holeDiameter*r)-bulletGap+(bulletGap*r))) {
                        translate([rowPosition, columnPosition, shellThickness+0.01])
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
openRodBox(length=internalLength, width=internalWidth, height=internalLidHeight, fill=internalLidFillHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, top=true);
