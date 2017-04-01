// A NEMA17 sized motor.
//
// DO NOT SLICE THIS.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com


include <configuration.scad>;


nema17Width            = 43;
nema17Length           = 48;
nema17Diameter		   = 50;
nema17ShaftDiameter    =  5;
nema17ShaftLength      = 25;
nema17ShoulderDiameter =  22;
nema17ShoulderHeight   =   2;
nema17ScrewSpacing     =  31.3;
dampenerOffset         =   6;


module nema17Motor()
{
	// Drawn with the shaft pointing toward the positive X-axis.
	
	// The motor's shaft.
	translate([nema17Length/2, 0, 0])
	rotate([0, 90, 0])
	cylinder(r=nema17ShaftDiameter/2, h=nema17ShaftLength, $fn=24);

	// The motor's shoulder.
	translate([nema17Length/2, 0, 0])
	rotate([0, 90, 0])
	cylinder(r=nema17ShoulderDiameter/2, h=nema17ShoulderHeight, $fn=24);
	
	// The rectangular body of the motor with rounded corners.
	intersection()
	{
		cube([nema17Length, nema17Width, nema17Width], true);

		rotate([0, 90, 0])
		cylinder(r=nema17Diameter/2, h=nema17Length, center=true, $fn=24);
	}
}
