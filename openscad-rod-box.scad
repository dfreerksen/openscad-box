/*
Author: David Freerksen, dfreerksen@gmail.com
Date: 03/24/2023
*/

/* USAGE
use <openscad-box.scad>

openRodBox(....);

Parameters
    length    > Inside length of the box
    width     > Inside width of the box
    height    > Inside height,
    shell     > Shell thickness
    fillet    > Radius of the fillets (corners)
    rib       > Width of the ribs
    clearance > Gap clearance for joints
    top       > Is this the top of the box
*/

/* [Box Properties] */

// Inside length of the box
insideLength = 65; // [50:220]

// Inside width of the box
insideWidth = 100; // [50:220]

// Inside lid height
insideLidHeight = 25; // [50:220]

// Inside base height
insideBaseHeight = 45; // [30:220]

// Inside lid fill height
insideLidFillHeight = 0; // [0:220]

// Inside base fill height
insideBaseFillHeight = 0; // [0:220]

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

/* [Display] */

// Show example
showBoxExample = true;

// Show a combined opened example
showBoxExampleCombinedOpen = false;

// Show a combined closed example
showBoxExampleCombinedClosed = false;

// EXAMPLE
if (showBoxExample) {
    // bottom
    color([0.5, 0.5, 1])
    translate([0, 0, 0])
    openRodBox(length=insideLength, width=insideWidth, height=insideBaseHeight, fill=insideBaseFillHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, rod=rodThickness, clearance=gapClearance, top=false);

    // top
    color([1, 0.5, 0.5])
    translate([0, (insideWidth+(filletRadius*4)+(shellThickness*4)), 0])
    openRodBox(length=insideLength, width=insideWidth, height=insideLidHeight, fill=insideLidFillHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, rod=rodThickness, top=true);
}

if (showBoxExampleCombinedOpen) {
    // bottom
    color([0.5, 1, 0.5])
    translate([0, (-insideWidth-(filletRadius*4)-(shellThickness*4)), 0])
    openRodBox(length=insideLength, width=insideWidth, height=insideBaseHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, rod=rodThickness, top=false);

    // top
    color([1, 0.5, 1])
    translate([(-(insideLength/2)-insideLidHeight-shellThickness-(filletRadius*3)+(gapClearance*5)), (-insideWidth-(filletRadius*4)-(shellThickness*4)), (insideBaseHeight+(insideLength/2)+shellThickness+(filletRadius*3)-(gapClearance*5))])
    rotate([0, 270, 180])
    openRodBox(length=insideLength, width=insideWidth, height=insideLidHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, rod=rodThickness, top=true);
}

if (showBoxExampleCombinedClosed) {
    // bottom
    color([0.5, 1, 1])
    translate([(insideWidth+(filletRadius*4)-(shellThickness*4)), 0, 0])
    openRodBox(length=insideLength, width=insideWidth, height=insideBaseHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, rod=rodThickness, top=false);

    // top
    color([1, 1, 0.5])
    translate([(insideWidth+(filletRadius*4)-(shellThickness*4)), 0, (insideBaseHeight+insideLidHeight+(shellThickness*2))])
    rotate([0, 180, 180])
    openRodBox(length=insideLength, width=insideWidth, height=insideLidHeight, shell=shellThickness, fillet=filletRadius, rib=ribThickness, clearance=gapClearance, rod=rodThickness, top=true);
}

module __Customizer_Limit__ () {}

// Number of fragments to draw an arc
$fn = 64;

// Main module
module openRodBox(length, width, height, fill=0, shell=3, fillet=4, rib=10, clearance=0.3, rod=3, top=false) {
    union() {
        difference() {
            union() {
                translate([-(length/2), -(width/2), 0])
                union() {
                    // lower
                    minkowski() {
                        cube([length, width, (height-(shell*2))]);
                        cylinder(r1=fillet, r2=(fillet+shell), h=shell, center=false);
                    }

                    // lip
                    translate([0, 0, (height-shell)])
                    minkowski() {
                        cube([length, width, shell]);
                        cylinder(r1=(fillet+shell), r2=(fillet+(shell*2)), h=shell, center=false);
                    }
                }

                // Length ribs
                oneRibY(length, width, height, fillet, shell, rib);
                mirror([1,0,0])
                oneRibY(length, width, height, fillet, shell, rib);

                // Width ribs
                oneRibX(length, width, height, fillet, shell, rib);
                mirror([0,1,0])
                oneRibX(length, width, height, fillet, shell, rib);

                // Top rabbet
                if (top==true) {
                    topRabbet(length, width, height, fillet, shell);
                }
            }

            // Inside cut out
            translate([-(length/2), -(width/2), ((shell/2)+shell)])
            minkowski() {
              cube([length, width, (height-shell+0.1)]);
              cylinder(r=fillet, h=shell, center=true);
            }

            // Bottom rabbet cutout
            if (top==false) {
                bottomRabbet(length, width, height, fillet, shell);
            }

            // Bottom hinge cutout
            if (top==false) {
                // Inside cutout
                translate([(-(length/2)-(shell*3)-(shell/2)), 0, (height+shell)])
                rotate([90, 90, 0])
                cylinder(d=(shell*2), h=(width+(fillet*2)+rib), center=true);

                // Outside cutout
                bottomHingeCutout(length, width, height, fillet, shell, clearance, rib, rod);
                mirror([0, 1, 0])
                bottomHingeCutout(length, width, height, fillet, shell, clearance, rib, rod);
            }

            // Top hinge cutout
            if (top==true) {
                // Outside cutout
                translate([(-(length/2)-(shell*3)-(shell/2)), 0, (height+shell)])
                rotate([90, 90, 0])
                cylinder(d=((shell*2)), h=(width+(fillet*2)+rib), center=true);

                // Inside cutout
                translate([(-(length/2)-(shell*3)-(shell/2)), 0, (height+shell)])
                rotate([90, 90, 0])
                cylinder(d=((shell*2)+(clearance*2)), h=(width+(fillet*2)-rib-(shell*8)+(clearance*2)), center=true);
            }

            // TODO: Turn this into a variable. Default false to not cut it out
            // Bottom lid snap cutout
            // if (top==false) {
            //     translate([((length/2)+shell+fillet+(shell*0.5)), 0, (height-(shell*2))])
            //     cube([shell, (width+(fillet*2)-rib-(shell*8)), (shell*4)], center=true);
            // }
        }

        // Bottom hinge
        if (top==false) {
            difference() {
                translate([(-(length/2)-(shell*3)-(shell/2)), 0, (height+shell)])
                rotate([90, 90, 0])
                cylinder(d=(shell*2), h=(width+(fillet*2)-rib-(shell*8)), center=true);

                translate([(-(length/2)-(shell*3)-(shell/2)), 0, (height+shell)])
                rotate([90, 90, 0])
                cylinder(d=rod+clearance, h=(width+(fillet*2)-rib-(shell*8)+clearance), center=true);
            }
        }

        // Top hinge
        if (top==true) {
            topHingeSide(length, width, height, fillet, shell, clearance, rib, rod);
            mirror([0, 1, 0])
            topHingeSide(length, width, height, fillet, shell, clearance, rib, rod);
        }

        // Top lid snap
        if (top==true) {
            difference() {
                union() {
                    translate([((length/2)+shell+fillet+(shell*1.5)), 0, (height+shell)])
                    cube([shell, (width+(fillet*2)-rib-(shell*8)-clearance), (shell*6)], center=true);

                    translate([((length/2)+shell+fillet+(shell*0.5)), 0, (height-shell)])
                    cube([shell, (width+(fillet*2)-rib-(shell*8)), (shell*4)], center=true);

                    translate([((length/2)+shell+fillet+(shell*1.1)), 0, (height+shell+(shell*1.5)+(clearance*2))])
                    rotate([90, 90, 0])
                    cylinder(d=shell, h=(width+(fillet*2)-rib-(shell*8)), center=true);
                }

                translate([((length/2)+(shell*2)), 0, (height-(shell*4))])
                rotate([0, 45, 0])
                cube([(shell*2), width, (shell*10)], center=true);

                translate([((length/2)+(shell*2)), ((width-(fillet*2)-rib-(shell*8)+rib)/2), (height+(shell*5))])
                rotate([45, 0, 0])
                cube([(shell*10), (shell*3), (shell*10)], center=true);

                translate([((length/2)+(shell*2)), -((width-(fillet*2)-rib-(shell*8)+rib)/2), (height+(shell*5))])
                rotate([-45, 0, 0])
                cube([(shell*10), (shell*3), (shell*10)], center=true);

                translate([((length/2)+(shell*2)+shell+(shell/2)), 0, (height+(shell*5.8))])
                rotate([0, 45, 0])
                cube([(shell*3), width, (shell*10)], center=true);
            }
        }

        // Inside fill
        let (maxFillHeight = (fill > height) ? height : fill)
        {
            if (maxFillHeight > 0) {
                union() {
                    // Internal box
                    minkowski() {
                        translate([-(length/2), -(width/2), ((shell*2)-(shell/2))])
                        cube([length, width, maxFillHeight-shell]);
                        cylinder(d=(fillet*2), h=shell, center=true);
                    }

                    // Internal box filler
                    translate([-(length/2), -(width/2), shell])
                    cube([length, width, maxFillHeight]);
                }
            }
        }
    }
}

// Bottom hinge cutout
module bottomHingeCutout(length, width, height, fillet, shell, clearance, rib, rod) {
    translate([(-(length/2)-(shell*3)-(shell/2)), -(width/2), (height+shell)])
    rotate([90, 90, 0])
    // cylinder(d=((shell*2)+(clearance*2)), h=((rib*2)+(fillet*2)-(shell/2)-clearance), center=true);

    cylinder(d=((shell*2)+(clearance*2)), h=((width/2+(fillet*2)-rib-(shell*8))+(clearance*7)), center=true);
}

// Top hinge
module topHingeSide(length, width, height, fillet, shell, clearance, rib, rod) {
    difference() {
        translate([(-(length/2)-(shell*3)-(shell/2)), ((width/2)-(fillet/2)-(shell*2)+(clearance*0.5)), (height+shell)])
        rotate([90, 90, 0])
        cylinder(d=(shell*2), h=(rib-clearance), center=true);

        translate([(-(length/2)-(shell*3)-(shell/2)), ((width/2)-(fillet/2)-(shell*2)+(clearance*0.5)), (height+shell)])
        rotate([90, 90, 0])
        cylinder(d=rod, h=(rib+clearance), center=true);
    }
}

// Bottom rabbet
module bottomRabbet(length, width, height, fillet, shell) {
    translate([-(length/2), -(width/2), (height+shell-1)])
    difference() {
        minkowski() {
            cube([length, width, ((shell/3)*2)]);
            cylinder(r1=(fillet+(shell*1.1)), r2=(fillet+(shell*1.5)), h=(shell/3), center=true);
        }

        minkowski() {
            cube([length, width, 0.001]);
            cylinder(r1=(fillet+(shell*0.9)), r2=(fillet+(shell*0.5)), h=(shell/3), center=true);
        }

        minkowski() {
            cube([length, width, ((shell/2)+0.001)]);
            cylinder(r=(fillet+(shell*0.5)), h=(shell/2), center=true);
        }
    }
}

// Top rabbet
module topRabbet(length, width, height, fillet, shell) {
    translate([-(length/2), -(width/2), (height+shell+0.001)])
    difference() {
        minkowski() {
            cube([length, width, 0.001]);
            cylinder(r1=(fillet+(shell*1.5)), r2=(fillet+(shell*1.1)), h=(shell/2), center=true);
        }

        minkowski() {
            translate([0, 0, -0.001])
            cube([length, width, 0.105]);
            cylinder(r1=(fillet+(shell*0.5)), r2=(fillet+(shell*0.9)), h=(shell/2), center=true);
        }
    }
}

// Length ribs
module oneRibY(length, width, height, fillet, shell, rib) {
    intersection() {
        translate([-(length/2), -(width/2), 0])
        minkowski() {
          cube([length, width, (height-shell)]);
          cylinder(r1=(fillet+shell), r2=(fillet+(shell*2)), h=shell);
        }

        translate([((length/2)-(fillet*2)), 0, (fillet*2)+1])
        cube([rib, (width*2), (height*2)], center=true);
    }
}

// Width ribs
module oneRibX(length, width, height, fillet, shell, rib) {
    intersection() {
        translate([-(length/2), -(width/2), 0])
        minkowski() {
            cube([length, width, (height-shell)]);
            cylinder(r1=(fillet+shell), r2=(fillet+(shell*2)), h=shell);
        }

        translate([0, ((width/2)-(fillet*2)), (fillet*2)+1])
        cube([(length*2), rib, (height*2)], center=true);
    }
}
