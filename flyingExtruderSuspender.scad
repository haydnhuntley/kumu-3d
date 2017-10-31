// Flying extruder suspender.
// This works with Shane's extruder (which works quite well) and many others.
//
// Requires:
// Qty: Description
//  2: M3x16 SHCS for pinching motor.
//  2: M3 nuts for pinching motor.
//  1: M3x10 SHCS for suspending motor.
//  1: M3 nylock nut for suspending motor.
//  3: 190mm long pieces of 1/4" (6mm) inside diameter 3/8" (9mm) outside
//     diameter rubber tubing for suspending from carriages.  If you're using
//     this on a different sized printer, then the rubber tubing should be a
//     little bit more than half the length of the horizontal extrusions.
//  3: M3 nylock nuts for attaching to the M3x35 SHCS on the carriages.
//  6: small zip ties for securing rubber tubing.
//  1: Key-Bak "Super48" heavy duty retractable key holder, 48" Kevlar cord,
//     8-10 oz retraction force (which seems to be plenty).  Here is the Amazon
//     link:  https://www.amazon.com/KEY-BAK-Retractable-Stainless-Polycarbonate-Oversized/dp/B0088MQ9JS
//  4: small zip ties, two to attach the Key-Bak to the frame, one to act as a
//     as a filament guide near the top, and one to attach the Key-Bak to
//	   motorWyeSuspender (with a little bit of string).
//
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com


$fn = 360/8;

include <configuration.scad>;
include <roundedBox.scad>;
include <motor.scad>;

zMotorRing         = 10.0;
motorRingThickness =  3.0;
rubberTubingID     = 0.25*mmPerInch + 5*smidge;
	

module motorRing()
{
	xyScale            = (nema17Width+2*motorRingThickness) / nema17Width;
	motorWingSize      = 10.7-m3NutRadius;
	motorWingThickness = 4*motorRingThickness;
	
	difference()
	{
		union()
		{
			// The basic shape of the ring, motorRingThickness thick.
			scale([xyScale, xyScale, 1])
			motorRingHelper();

			// Add the wings for the M3 bolts to secure it.
			translate([0, 0, zMotorRing/2])
			rotate([90, 0, 0])
			roundedBox([nema17Width*xyScale+2*motorWingSize,
						zMotorRing,
						motorWingThickness], zMotorRing/2, true);

			// Add extra material to thicken the top where the
			// M3 bolt to suspend it will be.
			translate([0, nema17Width*xyScale/2, zMotorRing/2])
			rotate([-90, 0, 0])
			cylinder(d1=zMotorRing,
					 d2=2*m3LooseRadius,
					 h=motorRingThickness,
					 $fn=24);
		}

		// Remove a hole in the middle for the NEMA17 motor.
		translate([0, 0, -smidge/2])
		scale([1, 1, 1.01])
		motorRingHelper();

		// Cut it into two pieces.
		translate([0, 0, zMotorRing/2])
		cube([nema17Width*xyScale+2*motorWingSize+smidge,
			  motorRingThickness,
			  zMotorRing+smidge], true);

		// Holes for two M3x16 bolts with nuts to tighten it.
		for (x = [1, -1])
			translate([x*(nema17Width*xyScale+motorWingSize-1)/2,
					   0,
					   zMotorRing/2])
			rotate([90, 0, 0])
			{
				cylinder(r=m3LooseRadius,
						 h=motorWingThickness+smidge,
						 center=true,
						 $fn=24);
				// Make room for an M3 nut trap.
				translate([0, 0, 5])
				rotate([0, 0, 30])
				cylinder(r1=m3TightNutRadius,
						 r2=m3LooseNutRadius,
						 h=m3NutHeight,
						 center=true,
						 $fn=6);
			}

					 

		// A hole for an M3x10 bolt and nut to suspend it from.
		translate([0, nema17Width/2, zMotorRing/2])
		rotate([-90, 0, 0])
		translate([0, 0, -smidge/2])
		{
			cylinder(r=m3LooseRadius, h=2*motorRingThickness+smidge, $fn=24);
			cylinder(r=m3LooseHeadRadius, h=m3HeadHeight+2*smidge, $fn=24);
		}
	}
}


module motorWyeSuspender()
{
	difference()
	{
		union()
		{
			// The common body of the "wye".
			cylinder(d=zMotorRing, h=rubberTubingID);

			// The three arms to attach it to the 0.25" ID rubber tubing.
			for (a = [1:3])
				rotate([0, 0, a*120])
				translate([0, 0, rubberTubingID/2])
				rotate([-90, 0, 0])
				cylinder(d=rubberTubingID, h=15);
		}

		// Hole for the M3 bolt to attach it to the motorRing.
		translate([0, 0, -smidge/2])
		cylinder(r=m3LooseRadius, h=rubberTubingID+smidge, $fn=24);

		// Pocket for the M3 nut to secure it to the motor.
		translate([0, 0, rubberTubingID-m3NutHeight])
		cylinder(r1=m3TightNutRadius,
				 r2=m3LooseNutRadius,
				 h=m3NutHeight+smidge, $fn=6);
	}
}


module motorRingHelper()
{
	intersection()
	{
		rotate([0, -90, 0])
		nema17Motor();

		translate([0, 0, zMotorRing/2])
		cube([nema17Width, nema17Width, zMotorRing], true);
	}
}


module tubingAdapter()
{
	h = 14.0 - m3NylockNutHeight;
	
	difference()
	{
		cylinder(d=rubberTubingID, h=h);

		translate([0, 0, -smidge/2])
		cylinder(r=m3LooseRadius, h=h+smidge);
	}
}


motorRing();

// Flip the wye upside down for printing.
motorWyeSuspender();

// Include 3 adaptors for mating the M3x35 SHCS on the carriages to the
// 0.25" ID rubber tubing.
for (a = [0:2])
	rotate([0, 0, a*120])
	translate([0, -15, 0])
	tubingAdapter();