// E3D Wedge for any printer.
// This helps lock in place the E3D's push-to-fit connector, which is
// supposed to secures the PTFE tubing.
//
// Haydn Huntley
// haydn.huntley@gmail.com

// Note: assumes a layer height of 0.1mm, or better yet 0.05mm.

$fn = 360/4;
smidge = 0.1;
radius = 4.85/2;
actualHeight = 1.4;
height = 2.2;
xSize = 10;
ySize = 12;

intersection()
{
	color("blue")
	translate([0, ySize/8, 0])
	cylinder(r=5, h=actualHeight);

	difference()
	{
		// The wedge shape.
		hull()
		{
			translate([-xSize/2, ySize*0.55, 0])
			cube([xSize, smidge, height]);
		
			translate([-xSize/2, -ySize*0.6, 0])
			cube([xSize, smidge, height/4]);
		}

		// The hole in the center.
		translate([0, ySize/8, -smidge/2])
		cylinder(r=radius+smidge, h=height+smidge);

		// The slot.
		hull()
		{
			translate([0, ySize/8, -smidge/2])
			cylinder(r=radius-2*smidge, h=height+smidge);

			translate([0, -ySize/2, -smidge/2])
			cylinder(r=radius-2*smidge, h=height+smidge);
		}
	}
}