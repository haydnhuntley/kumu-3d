// This is a glass holder for a 300mm diameter piece, with space for a
// silicone heating pad underneath it.  It secures to 2020 extrusions.
//
// With 5mm glass, it should work with M5x15 screws.
// I get my 300mm glass (and 250mm 12v or 24v silicone heaters)
// from RobotDigg.com
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

	if (debug)
	{
		// Show the M5x15 screw.
		translate([0, 0, 7])
		rotate([180, 0, 0])
%		cylinder(r=5/2, h=15);

		// Show how far the screw needs to extend.
		rotate([180, 0, 0])
#		cylinder(r=5/2, h=5+spacerHeight);
	}

	// Make a hole for the M5x15 bolt.
	translate([0, 0, -smidge/2])
	cylinder(r=m5LooseRadius, h=height+smidge);

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