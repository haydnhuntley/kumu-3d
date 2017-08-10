// 9mm (wide) belt locks.
//
// Haydn Huntley
// haydn.huntley@gmail.com


$fn = 360/4;

include <configuration.scad>;
include <roundedBox.scad>;


// All measurements in mm.
xInsideBeltOffset     = 5;
actualBeltWidth       = 9;
beltWidth             = actualBeltWidth + 1.0;
singleBeltThickness   = 1.5;
doubleBeltThickness   = 2.5+0.8;
beltLockHeight        = 4;
m3BeltLockOffset      = 4.65;
rBeltLock             = 4.4;


module upperBeltLock()
{
	difference()
	{
		union()
		{
			// Two circles joined by the area connecting them.
			for (x = [1, -1])
				translate([x*m3BeltLockOffset, 0, 0])
				cylinder(r=rBeltLock, h=beltLockHeight);

			// Plus an oval to widen amd strengthen the middle.
			scale([2.0, 1.5, 1])
			cylinder(r=rBeltLock, h=beltLockHeight);
		}
	
		// A hole to capture the doubled GT2 belt.
		translate([0, 0, beltLockHeight/2])
		cube([doubleBeltThickness, beltWidth, beltLockHeight+smidge], true);
	
		// Two holes for capturing M3 nuts.
		for (x = [1, -1])
			translate([x*m3BeltLockOffset, 0, -smidge/2])
			{
				cylinder(r1=m3LooseRadius+0.2,
						 r2=m3LooseRadius,
						 h=beltLockHeight+smidge);

				// M3 nut traps.
				translate([0, 0, beltLockHeight-m3NutHeight/2])
				rotate([0, 0, 30])
				cylinder(r=m3NutRadius, h=m3NutHeight+smidge, $fn=6);
			}
	}
}


module lowerBeltLock()
{
	difference()
	{
		// Two circles joined by the area connecting them.
		union()
		{
			for (x = [1, -1])
				translate([x*m3BeltLockOffset, 0, 0])
				cylinder(r=rBeltLock, h=beltLockHeight);

			// Plus an oval to widen amd strengthen the middle.
			scale([2.0, 1.5, 1])
			cylinder(r=rBeltLock, h=beltLockHeight);
		}
	
		// A hole to capture the doubled GT2 belt.
		translate([0, 0, beltLockHeight/2])
		cube([doubleBeltThickness, beltWidth, beltLockHeight+smidge], true);
	
		// Two slightly tapering holes for the M3x35 SHCS.
		for (x = [1, -1])
			translate([x*m3BeltLockOffset, 0, -smidge/2])
			cylinder(r1=m3LooseRadius+0.2,
					 r2=m3LooseRadius,
					 h=beltLockHeight+smidge);
	}
}


translate([0, 8, 0])
upperBeltLock();

translate([0, -8, 0])
lowerBeltLock();
