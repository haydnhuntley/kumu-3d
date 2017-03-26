// This is a glass holder for a 300mm diameter piece, with space for a
// silicone heating pad underneath it.  It secures to 2020 extrusions.
//
// With 5mm glass, it should work with M3x12 screws.
// I get my 300mm glass (and 250mm 12v silicone heaters) from RobotDigg.com
// Three of these pieces are used with a 300mm diameter round glass in my
// design.
//
// Haydn Huntley
// haydn.huntley@gmail.com


$fn = 360/2;

include <configuration.scad>;

debug = false;
glassRadius  = 300/2;
glassHeight  = 5.0;
spacerHeight = 3.0;

// All measurements in mm.
extraHeight  = 2.00;
height       = glassHeight+extraHeight;
overhang     = 3.00;
minWallWidth = 4*nozzleWidth;

// For printing, flip it over.
rotate([180, 0, 0])
translate([0, 0, -height])
difference()
{
	// The body.
	cylinder(r=extrusionWidth/2, h=height);

	// Carve out space for the glass.
	translate([glassRadius+m5ButtonHeadRadius/2+minWallWidth, 0, -smidge/2])
	cylinder(r=glassRadius, h=glassHeight+smidge);

	// Make the overhang smaller.
	translate([glassRadius+m5ButtonHeadRadius/2+minWallWidth, 0, -smidge/2])
	cylinder(r=glassRadius-overhang, h=height+smidge);

	// Make a hole for the M5x12 bolt's head.
	translate([0, 0, 5])
	cylinder(r=m5ButtonHeadRadius, h=height);

	if (debug)
	{
		// Show the M5x12 screw.
		translate([0, 0, 4])
		rotate([180, 0, 0])
%		cylinder(r=5/2, h=12);

		// Show how far the screw needs to extend.
		rotate([180, 0, 0])
#		cylinder(r=5/2, h=5+spacerHeight);
	}

	// Make a hole for the M3x12 bolt.
	translate([0, 0, -smidge/2])
	cylinder(r=m5LooseRadius, h=height);

	// Make the top of the M3x12 bolt's hole slightly domed.
	domeHeight = m5ButtonHeadRadius-m5LooseRadius;
	translate([0, 0, 5-domeHeight+smidge/2])
	cylinder(r1=m5LooseRadius, r2=m5ButtonHeadRadius, h=domeHeight);

	// For cutaway view.
	if (debug)
		translate([0, 0, -smidge])
		cube([20, 20, 20]);
}


// The spacer to leave room for the silicone heater.
translate([extrusionWidth, 0, 0])
difference()
{
	// The body.
	cylinder(r=extrusionWidth/2, h=spacerHeight);

	// Make a hole for the M5x12 screw.
	translate([0, 0, -smidge/2])
	cylinder(r=m5LooseRadius, h=spacerHeight+smidge);
}