// This implements the basic shape for the vertex.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com


include <configuration.scad>;
extraClearance         =   0.3;
grooveRadius           =   0.7;
crossPieceOffset       = -43;


function fnX(d, offset=0) = d * sin(30) - offset;
function fnY(d, offset=0) = d * cos(30) - offset;


module vertex(height=60)
{
	// This draws the core shape used at the three corners with the given
	// height.

	difference()
	{
		hull()
		{
			// The circular section at the vertex.
			translate([0, -12, 0])
			scale([1, 1, 1])
			cylinder(r=30.8, h=height, $fn=360/2);

			// The triangular section for the arms.
			for (a = [1, -1])
				translate([a*20, -5, 0])
				rotate([0, 0, a*30])
				translate([-extrusionWidth/2, -3.5*extrusionWidth, 0])
				cube([extrusionWidth, 3.5*extrusionWidth, height]);
		}

		// Remove space for the vertical 2020 extrusion.
		rotate([0, 0, 45])
		translate([-(extrusionWidth+extraClearance)/2,
				   -(extrusionWidth+extraClearance)/2, -smidge/2])
		cube([extrusionWidth+extraClearance,
			  extrusionWidth+extraClearance, height+smidge]);
		
		// Remove four vertical grooves to make the inside corners sharp.
		for (a = [1:4])
			rotate([0, 0, 45+a*90])
			translate([extrusionWidth/2, extrusionWidth/2, -smidge/2])
			cylinder(r=grooveRadius, h=height+smidge, $fn=8);
		
		// Remove space for the horizontal 2020 extrusions.
		for (a = [1, -1])
			translate([a*20, -5, 0])
			rotate([0, 0, a*30])
			translate([-(extrusionWidth+smidge)/2,
					   -2-2-4*extrusionWidth-smidge/2,
					   -smidge/2])
			cube([extrusionWidth+smidge,
				  2+4*extrusionWidth+smidge,
				  height+smidge]);
		
		// Remove interior space for the pulleys.
		hull()
			for (x = [1, -1])
				for (d = [23, 40])
					translate([x*fnX(d, 5), -fnY(d, -5), -smidge/2])
					cylinder(r=5, h=height+smidge, $fn=24);

		// Remove exterior space for the motor.
		hull()
			for (x = [1, -1])
				for (d = [57, 100])
					translate([x*fnX(d, 5), -fnY(d, -5), -smidge/2])
					cylinder(r=5, h=height+smidge, $fn=24);

		// Remove two vertical grooves to make the inside corners sharp.
		for (a = [1, -1])
			translate([a*20, -5, 0])
			rotate([0, 0, a*30])
			translate([-a*extrusionWidth/2, -2, -smidge/2])
			cylinder(r=grooveRadius, h=height+smidge, $fn=8);
	}

	// Add pads at the ends of the arms.
	color("green")
	for (x = [1, -1])
		translate([x*fnX(82, -2), -fnY(82), 0])
		cylinder(r=10, h=0.4, $fn=24);
}
