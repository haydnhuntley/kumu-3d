// This KeyBak lifter works with
// It is designed to rest on the top of a Kossel-style Delta printer.
// It assumes that the top of the printer is made from 20x20mm aluminum
// extrusion.
// An M5x8 button socket head screw holds each side of the holder in place,
// and an M3x10 to M3x20 SHCS attaches the crossbar to it.
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
debug       = false;
xSize       = extrusionWidth;
ySize       = extrusionWidth * 1.5;
topDiameter = 13;
height      = 46;
baseHeight  = 3.0;
keyWidth    = 6.5;
keyDepth    = 2.4;
keyLength   = 0.25 * ySize;


module keyBakLifter()
{
	difference()
	{
		union()
		{
			hull()
			{
				// The circular top.
				translate([0, 0, height-smidge])
				cylinder(d=topDiameter, h=smidge);
		
				// The rectangular base.
				translate([-xSize/2, -ySize/2, 0])
				cube([xSize, ySize, smidge]);
			}
			
			// Add two trapezoids as keys on the bottom.
			color("blue")
			for (y = [1, -1])
			translate([0, y*ySize*0.30, 0])
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

		// Tapering hole for an M3x10 to M3x20 screw to attach the crossbar
		// supporting the KeyBak.
		translate([0, 0, height-20-smidge/2])
		cylinder(r1=m3Radius-4*smidge, r2=m3TightRadius+2*smidge, h=20+smidge);

		// Hole for M5x8 button head screw to attach it to the top of the
		// frame.
		translate([0, 0, -smidge/2])
		cylinder(r=m5LooseRadius, h=baseHeight+smidge);

		// Angled hole for accessing and inserting the M5x8.
		hull()
		{
			translate([16, 0, 46])
			scale([1.2, 1, 1])
			cylinder(r=m5ButtonHeadRadius, h=smidge);
			
			translate([0, 0, baseHeight+m5HeadHeight])
			scale([1.2, 1, 1])
			cylinder(r=m5ButtonHeadRadius, h=smidge);
		}
		translate([0, 0, baseHeight])
		scale([1.2, 1, 1])
		cylinder(r=m5ButtonHeadRadius, h=m5HeadHeight+smidge);
	}
}


if (debug)
{
	keyBakLifter();
}
else
{
	// Rotate for printing, and do two of them.
	translate([-height/2, -(ySize/2-3), xSize/2])
	rotate([0, 90+atan((xSize-topDiameter)/(2*height)), 0])
	keyBakLifter();
	
	translate([height/2, ySize/2-3, xSize/2])
	rotate([0, 90+atan((xSize-topDiameter)/(2*height)), 180])
	keyBakLifter();
}
