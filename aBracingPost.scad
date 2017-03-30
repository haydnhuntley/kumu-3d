// Posts for 1/2" angle aluminum for stiffening a printer which uses 2020
// extrusions..  I recommend using A-bracing.
// 
// Haydn Huntley
// haydn.huntley@gmail.com


$fn = 360/6;


include <configuration.scad>;
include <roundedBox.scad>;


// All measurements in mm.
debug		= false;
xBase       = extrusionWidth;
yBase       = 2 * extrusionWidth;
zBase		= 3.0;
postRadius  = 11.5/2;


module diagonalBracingPost()
{
	difference()
	{
		union()
		{
			// The post.
			cylinder(r=postRadius, h=2*postRadius+zBase);

			// The base for the post.
			translate([0, 0, zBase/2])
			roundedBox([xBase, yBase, zBase], 5, true);
		}
		
		// Remove a tapering hole for an M3x10 to M3x16 screw in the post.
		translate([0, 0, -smidge/2])
		cylinder(r2=m3LooseRadius-smidge,
				 r1=m3Radius-smidge,
				 h=2*postRadius+zBase+smidge);

		// Remove the two M5x8 holes in the base.
		for (y = [1, -1])
		{
			translate([0, y*2/3*yBase/2, -smidge/2])
			{
				cylinder(r=m5LooseRadius, h=zBase+smidge);
				// Show the M5x8 screw heads.
				if (debug)
					%translate([0, 0, zBase+smidge/2])
					cylinder(r=m5ButtonHeadRadius, h=m5ButtonHeadHeight);
			}
		}
	}
}


diagonalBracingPost();
