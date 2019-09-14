// Carriage for 2020 aluminum extrusions and four ~24mm diameter wheels riding
// on the diagonals, with GT2 belt tightener.  This works nicely with the
// ball studs and carbon fiber, magnetic, zero-backlash printer arms which
// I have for sale, and with my flying extruder.
//
// They are on my website at:  http://www.MagBallArms.com
// 
// Here is a link to the wheel, eccentric spacers and round spacers at
// RobotDigg.com:
//   http://www.robotdigg.com/product/521/Delrin-or-SUS-Via-S-Bearing
//   http://www.robotdigg.com/product/626/Openbuilds-decentration-post
//
// Alternatively you can get them from OpenBuidsPartsStore.com:
//   http://openbuildspartstore.com/delrin-v-wheel-kit/
//   http://openbuildspartstore.com/eccentric-spacer/  (choose 1/4")
//
// Per carriage, you'll need:
// 4  of the above V- or W-wheels.
// 4  of the above 1/4" eccentric spacers.
// 4  M5x50 bolts.
// 4  M5 nylock nuts to secure the four axles.
// 2  3/8" ball studs.
// 2  M3 nylock nuts to secure the ball studs.
// 2  M3x35 SHCS for the tightener.
// 2  M3 nuts for the tightener.
// 1  M3x35 SHCS for the vertical post for the upper G2 belt attachment.
// 1  M3 nylock nut to secure the vertical post.
//
// Haydn Huntley
// haydn.huntley@gmail.com


$fn = 360/4;

include <configuration.scad>;
include <roundedBox.scad>;


// All measurements in mm.
eccentricSpacerRadius = (7.1 + 0.3)/2;
eccentricSpacerHeight = 0.25 * mmPerInch;
xAxleSpacing          = extrusionWidth * sqrt(2) + 19.1 - 0.35;
yAxleSpacing          = 30.0;
xBody                 = max(xAxleSpacing + 2 * 7, ballJointSeparation + 2 * 5);
yBody                 = yAxleSpacing + 2 * 7;
yBodyExtra            = 15.0;
zBody                 = 10.0;
yBallStudOffset       = yAxleSpacing/2 + yBodyExtra;
xInsideBeltOffset     = 5;
actualBeltWidth       = 9;
beltWidth             = actualBeltWidth + 1.0;
singleBeltThickness   = 1.5;
doubleBeltThickness   = 2.5+0.8;
beltLockHeight        = 2*m3NutHeight;
m3BeltLockOffset      = 4.5;
rBeltLock             = 4.6;
debug = true;

wheelWidth                     = 11.0;
gapBetweenCarriageAndExtrusion =  2;
gapBetweenBeltAndExtrusion     = 17;
spacerRadius                   = 10.0/2;
tallSpacerHeight = extrusionWidth * sin(45) + gapBetweenCarriageAndExtrusion - wheelWidth/2 - 1.0;
shortSpacerHeight = tallSpacerHeight - eccentricSpacerHeight;


module carriage()
{
	// Draw the belts.
	// The is a gap of 17mm between the belts and the aluminum extrusions.
	// There should be a gap of 2mm between the carriage and extrusions.
	if (debug)
		for (x = [1, -1])
			translate([x*(singleBeltThickness/2+5),
					   0,
					   6/2 + gapBetweenBeltAndExtrusion
					       - gapBetweenCarriageAndExtrusion])
			%cube([singleBeltThickness, 100, actualBeltWidth], true);
		
	difference()
	{
		union()
		{
			// The round-cornered rectangle body.
			translate([0, 0.5*yBodyExtra/2, zBody/2])
			roundedBox([xBody, yBody+0.5*yBodyExtra, zBody], 5, true);

			// Bases for the ball studs.
			for (x = [1, -1])
				translate([x*ballJointSeparation/2, yBallStudOffset, 0])
				hull()
				{
					translate([0, 0, zBody])
					rotate([45, 0, 0])
					translate([0, 5, 2])
					translate([0, 0, 9])
					cylinder(r=10/2, h=1);

					translate([0, 0, (zBody+8)/2])
					roundedBox([10, 15, zBody+8], 5, true);
				}
		}

		// Place a hole in the center to lighten it.
		translate([0, -7/2, zBody/2])
		roundedBox([xBody-4*7, yBody-3*7, zBody+smidge], 5, true);

		// Gracefully remove material between the round-cornered rectangle
		// and the ball studs.
		translate([0, yBody/2+20/2, zBody/2])
		roundedBox([min(xBody-2*10, ballJointSeparation-10),
					20,
					zBody+smidge], 5, true);

		// Four holes for the M5x50 bolts for the axles for the rollers.
		// Upper right.
		translate([xAxleSpacing/2, yAxleSpacing/2, -smidge/2])
		m5x50(zBody+smidge);

		// Lower right.
		translate([xAxleSpacing/2, -yAxleSpacing/2, -smidge/2])
		m5x50(zBody+smidge);

		// Upper left, with room for the eccentric spacer.
		translate([-xAxleSpacing/2, yAxleSpacing/2, -smidge/2])
		{
			m5x50(zBody+smidge);
			cylinder(r=eccentricSpacerRadius, h=zBody+smidge);
		}

		// Lower left, with room for the eccentric spacer.
		translate([-xAxleSpacing/2, -yAxleSpacing/2, -smidge/2])
		{
			m5x50(zBody+smidge);
			cylinder(r=eccentricSpacerRadius, h=zBody+smidge);
		}

		// Two holes for the ball studs with nut traps.
		for (x = [1, -1])
			translate([x*ballJointSeparation/2, yBallStudOffset, zBody])
			rotate([45, 0, 0])
			translate([0, 5, 2])
			{
				ballStud();
				if (debug)
					%ballStud();
			}

		// A hole for the M3x20 vertical post, for the belt attachment.
		translate([xInsideBeltOffset+singleBeltThickness/2,
				   yAxleSpacing/2,
				   -smidge/2])
		{
			m3x20(20);
			if (debug)
				%m3x20(20);
		}
	}
}


module m5x50(h=0)
{
	cylinder(r=m5Radius, h=h);
}


module m3x20(h=0)
{
	// The head of the M3 SHCS.
	cylinder(r=m3LooseHeadRadius, h=m3HeadHeight+1);

	// A domed vault above the head in order to print the overhang better.
	translate([0, 0, m3HeadHeight+1-smidge/2])
	cylinder(r1=m3LooseHeadRadius,
			 r2=m3LooseRadius,
			 h=m3LooseHeadRadius-m3LooseRadius);

	// The SHCS's threaded shaft.
	translate([0, 0, m3HeadHeight+1])
	cylinder(r=m3LooseRadius, h=h);
}


module ballStud()
{
	// The M3x10 threaded part.	
	cylinder(r=m3LooseRadius, h=10+smidge);
	
	// The nut to hold it.
	translate([0, 0, -m3NutHeight*5])
	rotate([0, 0, 30])
	cylinder(r1=m3NutRadius+0.1, r2=m3NutRadius-0.2, h=m3NutHeight*7, $fn=6);
	
	// The M10 hexagonal base.
	hull()
	{
		translate([0, 0, 10+3])
		cylinder(r=5/2, h=1, $fn=6);
		translate([0, 0, 10])
		cylinder(r=11.3/2, h=1, $fn=6);
	}
	
	// The ball at the top.
	translate([0, 0, 22.2-3/8*mmPerInch/2])
	sphere(r=3/8*mmPerInch/2, $fn=24);
}


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
				cylinder(r=m3LooseRadius,
						 h=beltLockHeight+smidge);

				// M3 nut traps.
				translate([0, 0, beltLockHeight-m3NutHeight])
				rotate([0, 0, 30])
				cylinder(r1=m3TightNutRadius-1.5*smidge,
						 r2=m3NutRadius-smidge,
						 h=m3NutHeight+smidge,
						 $fn=6);
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
	
		// Two holes for the M3x35 SHCS.
		for (x = [1, -1])
			translate([x*m3BeltLockOffset, 0, -smidge/2])
			cylinder(r=m3LooseRadius, h=beltLockHeight+smidge);
	}
}


module upperBeltLock6mm()
{
    actualBeltWidth = 6;
    
	difference()
	{
		union()
		{
			// Two circles joined by the area connecting them.
			for (x = [1, -1])
				translate([x*m3BeltLockOffset, 0, 0])
				cylinder(r=rBeltLock, h=beltLockHeight);

			// Plus an oval to widen amd strengthen the middle.
			scale([2.0, 1.25, 1])
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
				translate([0, 0, beltLockHeight-m3NutHeight])
				rotate([0, 0, 30])
				cylinder(r1=m3TightNutRadius-smidge,
						 r2=m3NutRadius,
						 h=m3NutHeight+smidge,
						 $fn=6);
			}
	}
}


module lowerBeltLock6mm()
{
    actualBeltWidth = 6;
    
	difference()
	{
		// Two circles joined by the area connecting them.
		union()
		{
			for (x = [1, -1])
				translate([x*m3BeltLockOffset, 0, 0])
				cylinder(r=rBeltLock, h=beltLockHeight);

			// Plus an oval to widen amd strengthen the middle.
			scale([2.0, 1.25, 1])
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



module shortSpacer()
{
	difference()
	{
		cylinder(r=spacerRadius, h=shortSpacerHeight);

		translate([0, 0, -smidge/2])
		cylinder(r=m5LooseRadius, h=shortSpacerHeight+smidge);
	}
}


module tallSpacer()
{
	difference()
	{
		cylinder(r=spacerRadius, h=tallSpacerHeight);

		translate([0, 0, -smidge/2])
		cylinder(r=m5LooseRadius, h=tallSpacerHeight+smidge);
	}
}


carriage();

color("green")
translate([-8, -3, 0])
rotate([0, 0, 90])
upperBeltLock();

color("red")
translate([8, -3, 0])
rotate([0, 0, 90])
lowerBeltLock();

for (x = [1:2])
	for (y = [0:1])
		color("blue")
		translate([x*-12+5, -(yBody/2+8+y*12), 0])
		shortSpacer();
		
for (x = [1:2])
	for (y = [0:1])
		color("purple")
		translate([x*12-5, -(yBody/2+8+y*12), 0])
		tallSpacer();
