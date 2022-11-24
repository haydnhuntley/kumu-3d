// This spool holder uses a piece of 1/2" copper pipe for the axle.
// It is designed to rest on the top of a Kossel-style Delta printer.
// It assumes that the top of the printer is made from 20x20mm aluminum
// extrusion.
// An M5x8 button socket head screw holds each side of the spool holder in
// place.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

$fn = 360/4;

include <configuration.scad>;

// All measurements in mm.
debug              = false;
baseHeight         = 3.0;
minWallWidth       = 2.0;
size               = 2.5 * copperPipeRadius;
extraHeight        = 42;
keyWidth           = 6.5;
keyDepth           = 2.4;
keyLength          = 0.6 * size;
lCopperPipeRadius  = copperPipeRadius + 0.25;


module spoolHolder(angle)
{
	signAngle = sign(angle);
	// The following is centered in 2D at the origin.
	difference()
	{
		union()
		{
			intersection()
			{
				// Intersect a cone with a rectangle for the body.
				scale([1, 1.25, 1])
				cylinder(r1=size,
						 r2=(1+lCopperPipeRadius+baseHeight)/1.25,
						 h=size+extraHeight);
			
				translate([-extrusionWidth/2, -size, 0])
				cube([extrusionWidth, 2*size, size-minWallWidth+extraHeight]);
			}
			
			// Add two trapezoids as keys on the bottom.
			color("blue")
			for (y = [1, -1])
			translate([0, y*size/2, 0])
			{
				size = keyWidth * cos(45);
				intersection()
				{
					rotate([0, 45, 0])
					cube([size, keyLength, size], true);

					cube([keyWidth, keyLength, keyDepth], true);
				}
			}
		}

		// Remove the copper tube.
		color("red")
		translate([6, signAngle * 3, 0])
		rotate([0, 0, angle])
		translate([0, 0,
		          lCopperPipeRadius+m5ButtonHeadHeight+baseHeight+extraHeight])
		rotate([0, 90, 0])
		union()
		{
			// A cylinder, plus a square above it, for it to slide out of.
			cylinder(r=lCopperPipeRadius, h=extrusionWidth+2, center=true);
			
			translate([-2*lCopperPipeRadius, -lCopperPipeRadius,
					  -(extrusionWidth+2)/2])
			cube([2*lCopperPipeRadius, 2*lCopperPipeRadius, extrusionWidth+2]);
		}

		// Remove the screw hole.
		color("green")
		translate([0, 0, -smidge])
		scale([1.2, 1, 1])
		cylinder(r=m5LooseRadius+smidge, h=baseHeight+1);
 
		// Remove the screw head and access to it.
		color("green")
		hull()
		{
			translate([0, 0, baseHeight])
			scale([1.2, 1, 1])
			cylinder(r=m5ButtonHeadRadius, h=smidge);
			
			translate([-20, 0, baseHeight+20+extraHeight])
			scale([1.2, 1, 1])
			cylinder(r=m5ButtonHeadRadius, h=smidge);
		}
	}
}


if (debug)
{
	// Right side up for designing.
	spoolHolder(30);
}
else
{
	// Flip them on their sides and separate for printing.
	rotate([0, -90, 0])
	translate([extrusionWidth/2, 0, 0])
	spoolHolder(30);

	translate([0, 2*extrusionWidth-1, 0])
	rotate([180, -90, 0])
	translate([extrusionWidth/2, 0, -(size+extraHeight-minWallWidth)])
	spoolHolder(-30);
}
