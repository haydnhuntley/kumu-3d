// This works with a piece of 1/2" copper pipe, to provide more friction free
// bearings for the spool.
//
// Uses 2 flanged 623ZZ bearings.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

$fn = 360;

include <configuration.scad>;

// All measurements in mm.
ringXY            = 6;
ringZ             = 10;
realBearingDiameter = 11.5;
bearingRadius     = (realBearingDiameter+1)/2;
bearingZ          = 4.0+0.5;
radialOffset      = -0.5;


// To simulate an Octave spool's 32mm inside diameter hole.
//#color("blue")
//translate([0, 6.0, 0])
//cylinder(r=32/2, h=0.1);


module flangedBearing623zz()
{
	// Hole for the 623zz bearing.
	translate([0, copperPipeRadius+bearingRadius+radialOffset, ringZ-bearingZ])
	{
		// To show where the bearing will go.
		%cylinder(d=realBearingDiameter, h=bearingZ);
		
		difference()
		{
			cylinder(r=bearingRadius, h=bearingZ+smidge);
			cylinder(r=m3Radius+1, h=0.4);
		}
	}

	// Hole for the M3x10 screw to hold the bearing.
	translate([0, copperPipeRadius+bearingRadius+radialOffset, -smidge/2])
	cylinder(r=m3Radius, h=ringZ+bearingZ+smidge);
}


angle = 35;

// Draw a ring.
difference()
{
	union()
	{
		intersection()
		{
			cylinder(r=copperPipeRadius+ringXY, h=ringZ);

			// Trim the bottom off, so that a 32mm diameter spool hole will
			// barely fit over it.
			translate([0, 9.5, 0])
			cylinder(r=(32-0)/2, h=ringZ);
		}

		for (i = [1, -1])
			rotate([0, 0, i*angle])		
			translate([0, copperPipeRadius+bearingRadius+radialOffset, 0])
			cylinder(r=4, h=ringZ);
	}

	// Remove the center of the ring for the copper pipe tube.
	translate([0, 0, -smidge/2])
	cylinder(r=copperPipeRadius, h=ringZ+smidge);

	// Two 623zz flanged bearings to support the spool.
	for (i = [1, -1])
		rotate([0, 0, i*angle])
		flangedBearing623zz();

	// Make a gap in the bottom of the ring.
	translate([0, -copperPipeRadius-ringXY/2, ringZ/2])
	cube([8, ringXY+2+smidge, ringZ+smidge], center=true);
}
