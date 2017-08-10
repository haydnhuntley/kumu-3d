// This upper frame works with 2020 extrusions and 9mm wide belts (instead of
// the usuall 6mm wide ones).
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

// 30% hexagonal infill with a 0.5mm nozzle is plenty strong enough.

$fn = 360/24;

include <configuration.scad>;
include <motor.scad>;
include <vertex.scad>;


// All measurements in mm.
debug  = false;
height = extrusionWidth;
crossPieceOffset       = -43;
// The standard 6mm belts use a pair of 623ZZ flanged bearings, separated by
// a 3mm washer, which has a total width of 8.6mm.
// For 9mm wide belts, use a pair of 623ZZ flanged bearings, separated by a
// normal (unflanged) 623ZZ bearing, which has a total width of 12.0mm.
// The 3.4mm below is the increase from 8.6mm to 12.0mm.
extraBeltWidth = 3.4;


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
					translate([0, -18.9, height/2])
					rotate([90, 0, 0])
					cylinder(r1=27.2/2,
							 r2=7/2,
							 h=11.1-extraBeltWidth/2,
							 $fn=90);

					// The part of the cone which attaches to the crosspiece.
					translate([0,
							   crossPieceOffset+dampenerOffset-1.6-smidge-
							     extraBeltWidth/2,
							   height/2])
					rotate([90, 0, 0])
					cylinder(r1=7/2,
							 r2=19.4/2,
							 h=6.2-extraBeltWidth/2,
							 $fn=90);
				}
			}
		}
		
		// Remove four M5x10 holes to attach the four horizontal extrusions.
		for (x = [1, -1])
			for (d = [35, 70])
				translate([x*fnX(d), -fnY(d), height/2])
				rotate([90, 0, x*120])
				translate([0, 0, -0.2])
				cylinder(r=m5LooseRadius, h=5, $fn=24);

		// Remove two M5x10 holes to attach the vertical extrusion.
		for (x = [1, -1])
			for (a = [0, 1])
				rotate([0, 0, 45+a*90])
				translate([extrusionWidth/2, 0, height/2])
				rotate([0, 90, 0])
				{
					cylinder(r=m5LooseRadius, h=5, $fn=24);
					translate([0, 0, 5-smidge])
					cylinder(r1=m5LowProfileHeadRadius,
							 r2=1.5+m5LowProfileHeadRadius,
							 h=9, $fn=24);
				}

		// Remove a hole for an M3x25 for the idler shaft.
		translate([0, crossPieceOffset-7, height/2])
		rotate([90, 0, 0])
		rotate([180, 0, 0])
		cylinder(r1=m3LooseRadius, r2=m3Radius-0.2, h=35+1, $fn=36);
	}

	// Add a piece to hold a microswitch.
	difference()
	{
		intersection()
		{
			translate([0, -10/2-5, 14/2+height])
			cube([20, 14, 14], true);
			
			translate([0, -23, height])
			scale([0.50, 1, 1])
			cylinder(r=20, h=14, $fn=72);
		}
	
		// Show where the microswitch will go.
		translate([0, -6.3/2-17, 10.6/2+height+6])
		%cube([20, 6.3, 10.6], true);

		// Carve out tapered holes for the microswitch's M2.5x12 screws.
		for (x = [1, -1])
			translate([x*9.5/2, -17-6.3, height+6+3])
			rotate([-90, 0, 0])
			cylinder(r1=(2.5+0.4)/2, r2=2.5/2, h=12+4, $fn=12);

		// Carve space for the vertical extrusion.
		translate([0, 0, extrusionWidth])
		rotate([0, 0, 45])
		cube([extrusionWidth+extraClearance,
			  extrusionWidth+extraClearance,
			  2*extrusionWidth],
			  true);
		
		// Remove a vertical groove to make the inside corner sharp.
		rotate([0, 0, 45+180])
		translate([extrusionWidth/2, extrusionWidth/2, -smidge/2])
		cylinder(r=grooveRadius, h=2*extrusionWidth, $fn=8);
	}
}


difference()
{
	upperFrame();
	
	// Make wiring tunnels for the microswitch.
	for (x = [1, -1])
	{
		rotate([25, 0, 0])
		translate([x*8, -7.5, -1])
		cylinder(r=4/2, h=height+15, $fn=12);
	}
}

// Draw the motor, offset by the dampener.
//translate([0, crossPieceOffset-30-dampenerOffset, (height-43)/2+43/2])
//rotate([0, 0, 90])
//%nema17Motor();

// Draw the idler bearing, which is composed of two 623ZZ flanged bearings with
// a 623ZZ normal (unflanged) bearing separating them.  Together they are
// 12.0mm in width.
translate([0, crossPieceOffset+13+extraBeltWidth/2, height/2])
%rotate([90, 0, 0])
{
	h = 12.0;
	cylinder(r=12/2, h=1);
	cylinder(r=10/2, h=h);
	translate([0, 0, h-1])
	cylinder(r=12/2, h=1);
}

// Show where the carriage will go.
if (debug)
{
	translate([0, -22, 62])
	%cube([50, 10, 50], true);
}
