// This lower frame works with 2020 extrusions.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

// 30% infill is sufficient, weighs ~140g.


$fn = 360/24;

include <configuration.scad>;
include <motor.scad>;
include <vertex.scad>;
include <Orbitron_Medium.scad>


// All measurements in mm.
debug = false;
height = lowerFrameHeight;


// Draw the vertical extrusion.
if (debug)
   rotate([0, 0, 45])
   translate([-extrusionWidth/2, -extrusionWidth/2, -smidge/2])
   %cube([extrusionWidth, extrusionWidth, height+smidge]);

// Draw the horizontal extrusions.
if (debug)
	for (a = [1, -1])
		for (z = [0, 2*extrusionWidth])
			translate([a*20, -5, z])
			rotate([0, 0, a*30])
			translate([-extrusionWidth/2, -2-4*extrusionWidth, 0])
			%cube([extrusionWidth, 4*extrusionWidth, extrusionWidth]);


module lowerFrame()
{
	difference()
	{
		vertex(height);
		
		// Remove eight M5x10 holes to attach the four horizontal extrusions.
		for (z = [extrusionWidth/2, height-extrusionWidth/2])
			for (x = [1, -1])
				for (d = [35, 70])
					translate([x*fnX(d), -fnY(d), z])
					rotate([90, 0, x*120])
					translate([0, 0, -0.2])
					cylinder(r=m5LooseRadius, h=5, $fn=24);

		// Remove four M5x10 holes to attach the vertical extrusion.
		for (z = [extrusionWidth/2, height-extrusionWidth/2])
			for (x = [1, -1])
				for (a = [0, 1])
					rotate([0, 0, 45+a*90])
					translate([extrusionWidth/2, 0, z])
					rotate([0, 90, 0])
					{
						cylinder(r=m5LooseRadius, h=5, $fn=24);
						translate([0, 0, 5-smidge])
						cylinder(r1=m5LowProfileHeadRadius,
								 r2=1.5+m5LowProfileHeadRadius,
								 h=9, $fn=24);
					}

		// Remove a circular hole for the pulley and motor shaft.
		translate([0, crossPieceOffset, height/2])
		rotate([90, 0, 0])
		cylinder(r=1+nema17ShoulderDiameter/2, h=7, $fn=36);
		
		// Remove four M3x8 holes to attach the motor.
		translate([0, crossPieceOffset, height/2])
		for (a = [0:3])
			rotate([0, a*90, 0])
			rotate([90, 0, 0])
			translate([nema17ScrewSpacing/2, nema17ScrewSpacing/2, 0])
			{
				// M3x8 shaft
				cylinder(r=m3LooseRadius, h=7, $fn=24);
				// M3x8 head
				translate([0, 0, -1.55])
				cylinder(r=m3LooseHeadRadius, h=m3HeadHeight, $fn=24);

				// Tunnels for reaching the M3x8 screws.
				angle1 = 11;
				if (a == 0 || a == 2)
				{
					rotate([180+angle1, 0, 0])
					cylinder(r=4/2, h=70, $fn=12);
				}
				if (a == 1 || a == 3)
				{
					rotate([180, -angle1, 0])
					cylinder(r=4/2, h=70, $fn=12);
				}
			}

		// Incise the logo.
		// steps - the amount of detail, the higher the more detailed.
		// center - whether the output is centered or not
		// extra - extra distance between characters
		// height - height of extrusion, 0 for 2d
		translate([0, -10.5, 0])
		rotate([0, 0, 60])
		translate([0, 29, 30.5+5.5])
		rotate([0, 270, 270])
		scale([0.21, 0.21, 1])
		translate([0, -20, 0])
		Orbitron_Medium("Kumu-3D", steps=1, center=true, extra=2, height=3);
	}
}


lowerFrame();

// Draw the motor, offset by the dampener.
translate([0, crossPieceOffset-30-dampenerOffset, (height-43)/2+43/2])
rotate([0, 0, 90])
%nema17Motor();