// This upper frame works with 2020 extrusions.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

// 30% infill is sufficient.

// 8.6mm for idler
// 7mm cone

$fn = 360/24;

include <configuration.scad>;
include <motor.scad>;
include <vertex.scad>;
include <Orbitron_Medium.scad>


// All measurements in mm.
debug  = false;
height = extrusionWidth;
crossPieceOffset       = -43;


// Draw the vertical extrusion.
if (debug)
   rotate([0, 0, 45])
   translate([-extrusionWidth/2, -extrusionWidth/2, -smidge/2])
   %cube([extrusionWidth, extrusionWidth, height+smidge]);

// Draw the horizontal extrusions.
if (debug)
	for (a = [1, -1])
		translate([a*20, -5, 0])
		rotate([0, 0, a*30])
		translate([-extrusionWidth/2, -2-4*extrusionWidth, 0])
		%cube([extrusionWidth, 4*extrusionWidth, extrusionWidth]);


module upperFrame()
{
	difference()
	{
		union()
		{
			vertex(height);

			intersection()
			{
				translate([-50, -100, 0])
				cube([100, 100, height]);

				// Use two conic sections to hold the idler bearing.
				union()
				{
					// The part of the cone which is away from the crosspiece.
					translate([0, -19.9, height/2])
					rotate([90, 0, 0])
					cylinder(r1=27.2/2, r2=7/2, h=10.1, $fn=90);

					// The part of the cone which attaches to the crosspiece.
					translate([0,
							   crossPieceOffset+dampenerOffset-1.6,
							   height/2])
					rotate([90, 0, 0])
					cylinder(r1=7/2, r2=19.4/2, h=6.2, $fn=90);
				}
			}
		}
		
		// Remove four M5x10 holes to attach the four horizontal extrusions.
		for (x = [1, -1])
			for (d = [35, 70])
				translate([x*fnX(d), -fnY(d), height/2])
				rotate([90, 0, x*120])
				translate([0, 0, -2])
				cylinder(r=m5LooseRadius, h=7, $fn=24);

		// Remove two M5x12 holes to attach the vertical extrusion.
		for (x = [1, -1])
			for (a = [0, 1])
				rotate([0, 0, 45+a*90])
				translate([extrusionWidth/2, 0, height/2])
				rotate([0, 90, 0])
				{
					cylinder(r=m5LooseRadius, h=7, $fn=24);
					translate([0, 0, 7-smidge])
					cylinder(r1=m5LowProfileHeadRadius,
							 r2=1.5+m5LowProfileHeadRadius,
							 h=7, $fn=24);
				}

		// Remove a hole for an M3x25 for the idler shaft.
		translate([0, crossPieceOffset-7, height/2])
		rotate([90, 0, 0])
		rotate([180, 0, 0])
		cylinder(r1=m3LooseRadius, r2=m3Radius-0.2, h=35+1, $fn=36);
	}
}


upperFrame();

// Draw the motor, offset by the dampener.
//translate([0, crossPieceOffset-30-dampenerOffset, (height-43)/2+43/2])
//rotate([0, 0, 90])
//%nema17Motor();

// Draw the idler bearing.
translate([0, crossPieceOffset+13, height/2])
%rotate([90, 0, 0])
{
	h = 8.6;
	cylinder(r=12/2, h=1);
	cylinder(r=10/2, h=h);
	translate([0, 0, h-1])
	cylinder(r=12/2, h=1);
}
