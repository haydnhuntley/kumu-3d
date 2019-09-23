// Z-probe for the Kumu-3D effector with an E3D-style hotend.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

$fn=360/4;

include <configuration.scad>

// All measurements in mm.
attachmentRadius = 19;
height           = 53;


module zProbe()
{
	difference()
	{
		union()
		{
			// Make a circular section.
			difference()
			{
				// Make the outer cylinder
				cylinder(r=attachmentRadius+1.5, h=height);

				// Remove the inside of the cylinder.
				translate([0, 0, -smidge/2])
				cylinder(r=attachmentRadius-1.5, h=height+smidge);

				// Remove the right hand quarter.
				translate([0, 0, -smidge/2])
				rotate([0, 0, -30])
				cube([50, 50, height+smidge]);

				// Remove the left hand quarter.
				translate([0, 0, -smidge/2])
				rotate([0, 0, 120])
				cube([50, 50, height+smidge]);

				// Remove the bottom half.
				translate([-50/2, -50, -smidge/2])
				cube([50, 50, height+smidge]);
			}

			// Add the rounded end caps onto the circular section.
			for (a = [-1, 1])
				rotate([0, 0, a*30])
				translate([0, attachmentRadius, 0])
				{
					cylinder(r=3, h=height);
					
					translate([0, 0, height-20])
					cylinder(r1=3, r2=5, h=20);
				}
		}

		// Make two slightly tapered holes for M3x20 attachment screws.
		for (a = [-1, 1])
			rotate([0, 0, a*30])
			translate([0, attachmentRadius, height-20+smidge/2])
			cylinder(r1=m3Radius-smidge,
					 r2=m3LooseRadius-2*smidge,
					 h=20+smidge);

        if (0)  // Turn off the nut traps.
		// Make two nut traps.
		for (a = [-1, 1])
			rotate([0, 0, a*30])
			translate([0, attachmentRadius, height-3])
			union()
			{
				rotate([0, 0, a*-30])
				translate([0, -5, 0])
				cube([sin(60)*m3LooseNutRadius*2,
				      2*5,
				      m3NutHeight+3*smidge], true);

				cylinder(r=m3LooseNutRadius, 
						 h=m3NutHeight+3*smidge,
						 center=true, $fn=6);

				// Vaulted roof above nut.
				translate([0, 0, -m3NutHeight-smidge])
				cylinder(r1=m3LooseRadius, r2=m3LooseNutRadius,
						 h=m3NutHeight,
						 center=true, $fn=6);
			}

		// Remove an oval in the center.
		translate([0, 10, 0.55*height])
		rotate([-90, 0, 0])
		scale([1, 3.0, 1])
		cylinder(r=6.5, h=20);
		
		// Make space for attaching the switch at the bottom.
		switch();
	}
}


module switch()
{
	xSwitch = 20.0+2;
	ySwitch =  6.5;
	zSwitch = 10.7;
	zOffset = -3;

	// The switch body.
	translate([0, attachmentRadius, 0])
	translate([0, ySwitch/2, zSwitch/2+zOffset])
	cube([xSwitch, ySwitch, zSwitch], center=true);

	// The two M2.5 mounting holes.
	for (x = [-1, 1])
		translate([x*(7.2+2.5)/2, attachmentRadius, zOffset+8])
		rotate([90, 0, 0])
		cylinder(r=2.5/2, h=10, center=true);
}


//%switch();

translate([0, 0, height/2])
rotate([180, 0, 0])
translate([0, -attachmentRadius, -height/2])
zProbe();
