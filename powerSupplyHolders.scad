// These power supply holders work with 2020 extrusions and typical
// rectangular 300-360 watt power supplies.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

$fn = 360/12;

include <configuration.scad>;
include <roundedBox.scad>;

// All measurements in mm.
psHoleOffset = extrusionWidth/4;
xBody        = extrusionWidth;
zBody	 	 = 3.5;


module powerSupplyHolder(yBody)
{
	translate([0, 0, zBody/2])
	difference()
	{
		// Make the body.
		translate([0, yBody/2, 0])
		roundedBox([xBody, yBody, zBody], 5, true);

		// Remove a hole for mounting
		m5x8Hole(0, extrusionWidth/2);
	
		// Remove a slot for mounting.
		hull()
		{
			m3x6Hole(0, yBody-extrusionWidth/2);
			m3x6Hole(0, extrusionWidth+psHoleOffset);
		}
	}
}


module m5x8Hole(x, y)
{
	translate([x, y, 0])
	cylinder(r=m5LooseRadius, h=zBody+smidge, center=true);
}


module m3x6Hole(x, y)
{
	translate([x, y, 0])
	cylinder(r=m3LooseRadius, h=zBody+smidge, center=true);
}


// The short ones for the front.
translate([-2.2*extrusionWidth, 1.5 * extrusionWidth, 0])
powerSupplyHolder(2.5 * extrusionWidth);

translate([-1.1 * extrusionWidth, 0, 0])
powerSupplyHolder(2.5 * extrusionWidth);

// The long one for the back.
powerSupplyHolder(110);

translate([-1.1 * extrusionWidth, 3 * extrusionWidth, 0])
powerSupplyHolder(2.5 * extrusionWidth);

