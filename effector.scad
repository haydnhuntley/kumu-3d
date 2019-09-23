// Effector for Kumu-3D printer.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

// Note: assumes a layer height of 0.1mm.

$fn = 360/4;

include <configuration.scad>;

// All measurements in mm.
insideBaseRadius        = 46.0 / 2;
centerBaseHeight        = 2.0;
baseHeight              = 6;
totalMountHeight        = 9.7;
mountHeight             = 6.0;  // The height of the mount for an E3D.

mountHeightExt			= totalMountHeight - mountHeight;  // The height of the next part of the mount.
minMountHoleRadius      = (12.15+0.5) / 2;
maxMountHoleRadius      = (16.15+0.2) / 2;
maxMountHoleLooseRadius = (maxMountHoleRadius + 0.5);
maxMountHoleOffset      = (minMountHoleRadius + maxMountHoleRadius) / 2;
edgeRadius              = baseHeight/2;
sides                   = 3;
ballStudBaseOffset		= 43.0 / 2;
sideLength              = ballJointSeparation + 3 * edgeRadius;
secureScrewX			= 15.0;
secureScrewY			= 4.0;
secureScrewZ			= (totalMountHeight-2)/2+centerBaseHeight;
keyX					= 38.0;
keyY					=  3.0;
lightRingOutsideDiameter= 60;
lightRingInsideDiameter = 51;
lightRingAverageRadius  = (lightRingOutsideDiameter+lightRingInsideDiameter)/4;
fanThickness            = 15.3+2*smidge;
fanLugThickness			=  3.25;
fanLugRadiusInner		=  5.2/2;
fanLugRadiusOuter		=  7.0/2;
fanLugOffset		    = 35.0;
attachmentRadius        = 19;


module m3x8BallStud()
{
	len = 8.0;

	// The screw shaft.
	translate([0, 0, 2-0.6*m3NylockNutHeight])
	cylinder(r=m3LooseRadius, h=len+3, $fn=16);
	
	// The nylock nut trap.
	translate([0, 0, -1.4])
	rotate([0, 0, 30])
	cylinder(r1=m3NutRadius-1*smidge,
			 r2=m3NutRadius-3*smidge,
			 h=2+m3NylockNutHeight, $fn=6);
}


module m3x8Base()
{
	translate([0, 0, -3])
	cylinder(r1=(10+2)/2, r2=10/2, h=13.3);
}


module fanAttachment(positiveShape=true)
{
	if (positiveShape)
	{
		// The part to be added to the body.
		difference()
		{
			// Fan attachment to body.
			hull()
			{
				cylinder(r=fanLugRadiusOuter, h=fanThickness+2*fanLugThickness,
					     center=true);
				translate([0, -9, 0])
				cylinder(r=fanLugRadiusInner, h=fanThickness+2*fanLugThickness,
					     center=true);
			}
			hull()
			{
				// Gap for fan to fit in.
				cylinder(r=fanLugRadiusOuter+5*smidge, h=fanThickness,
						 center=true);
				translate([0, -9, 0])
				cylinder(r=fanLugRadiusInner+5*smidge, h=fanThickness,
						 center=true);
			}
			// Screw hole.
			translate([-abs(fanLugRadiusInner-fanLugRadiusOuter)/2, 0, 0])
			cylinder(r=m3LooseRadius, h=fanThickness+2*fanLugThickness+smidge,
				     center=true);
		}
	}
	else
	{
		// The part to be subtracted from the body.
		// Gap for fan to fit in.
		translate([-abs(fanLugRadiusInner-fanLugRadiusOuter)/2, 0, 0])
		cylinder(r=fanLugRadiusOuter+5*smidge, h=fanThickness, center=true);
	}
}


module effectorOutside()
{
	difference()
	{
		union()
		{
			// The body.
			rotate_extrude(convexity=10)
			translate([lightRingAverageRadius, 0, 0])
			circle(r=2.5+(lightRingOutsideDiameter+10*smidge -
					  (lightRingInsideDiameter-10*smidge))/4);

			// Add a base for each M3x8 ball stud to sit on.
			for (i = [0:sides])
			{
				angle = i * 360/sides;
				rotate([0, 0, angle])
				{
					translate([ballJointSeparation/2, 0, 0])
					translate([0, ballStudBaseOffset, 0])
					rotate([-30, 0, 0])
					m3x8Base();

					translate([-ballJointSeparation/2, 0, 0])
					translate([0, ballStudBaseOffset, 0])
					rotate([-30, 0, 0])
					m3x8Base();
				}
			}

			// Add a fan attachment in the middle of each side.
			for (i = [0:sides])
			{
				angle = i * 360/sides;
				rotate([0, 0, angle])
				translate([0, fanLugOffset,
							  min(fanLugRadiusInner, fanLugRadiusOuter)])
				rotate([0, 90, 0])
				fanAttachment(true);
			}
		}

		// Cut-away.
//		cube([100, 100, 100]);

		// Remove everything below the base.
		translate([0, 0, -10])
		cylinder(r=2*lightRingAverageRadius, h=10);

		// Center hole.
		translate([0, 0, -smidge/2])
		cylinder(r=insideBaseRadius,
				 h=baseHeight+smidge);

		// M3 holes for attaching ball studs.
		for (i = [0:sides])
		{
			angle = i * 360/sides;
			rotate([0, 0, angle])
			{
				translate([ballJointSeparation/2, 0, 0])
				translate([0, ballStudBaseOffset, 0])
				rotate([-30, 0, 0])
				m3x8BallStud();

				translate([-ballJointSeparation/2, 0, 0])
				translate([0, ballStudBaseOffset, 0])
				rotate([-30, 0, 0])
				m3x8BallStud();
			}
		}

		// Hollow out fan attachments in the middle of each side.
		for (i = [0:sides])
		{
			angle = i * 360/sides;
			rotate([0, 0, angle])
			translate([0, fanLugOffset, 
					   min(fanLugRadiusInner, fanLugRadiusOuter)])
			rotate([0, 90, 0])
			fanAttachment(false);
		}

		// For adding an LED light ring underneath.
		scale([1, 1, 1.3])
		rotate_extrude(convexity=10)
		translate([lightRingAverageRadius, 0, 0])
		circle(r=(lightRingOutsideDiameter+10*smidge -
				  (lightRingInsideDiameter-10*smidge))/4);

		// For the leads to the LED light ring.
		for (i = [-1, 1])
			rotate([0, 0, 90+i*9])
			translate([lightRingOutsideDiameter/2, 0, 1])
			rotate([0, -25, 0])
			cylinder(r=1.5/2+4*smidge, h=2*baseHeight+2, $fn=16);
	}
}


module effectorInside()
{
	difference()
	{
		union()
		{
			// Center area.
			cylinder(r=insideBaseRadius, h=centerBaseHeight);

			// Raised area to hold the hot end's mount.
			difference()
			{
				cylinder(r=maxMountHoleRadius+3, h=totalMountHeight);
				cylinder(r=minMountHoleRadius,   h=totalMountHeight);
				translate([0, 0, mountHeight])
				cylinder(r=maxMountHoleRadius, h=mountHeightExt+smidge);
			}

			// Wings for securing screws.
			translate([-keyX/2, 2.5-smidge-keyY/2, 0])
			cube([keyX, keyY, totalMountHeight]);
		}
	
		// Oblong hole for the mount.
		hull()
		{
			translate([0, 0, -smidge/2])
			cylinder(r=minMountHoleRadius, h=mountHeight+smidge);

			translate([0, maxMountHoleOffset+8, -smidge/2])
			cylinder(r=minMountHoleRadius, h=mountHeight+smidge);
		}

		// Oblong hole for the top of the groove mount.
		translate([0, 0, mountHeight])
		hull()
		{
			translate([0, 0, -smidge/2])
			cylinder(r=maxMountHoleRadius, h=mountHeightExt+smidge);

			translate([0, maxMountHoleOffset, -smidge/2])
			cylinder(r=maxMountHoleRadius, h=mountHeightExt+smidge);
		}

		// Hole for inserting the mount.
		translate([0, 2+maxMountHoleOffset, -smidge/2])
		cylinder(r=maxMountHoleLooseRadius, h=mountHeight+smidge);

		// Two holes for securing the mount key.
		translate([secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, 10+smidge, center=true, $fn=16);

		translate([-secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, h=10+smidge, center=true, $fn=16);

		// Six M3 holes for attaching a probe, etc.
		for (i = [0:6])
			rotate([0, 0, 30+i*60])
			translate([attachmentRadius, 0, -smidge/2])
			cylinder(r=m3LooseRadius, h=mountHeight+smidge);
	}	
}


module mountKey()
{
	h = totalMountHeight - centerBaseHeight;
	offset = 3 * smidge;
	
	difference()
	{
		union()
		{
			// The wings on the side of the mount key for securing it.
			translate([-keyX/2, keyY+offset, centerBaseHeight])
			cube([keyX, keyY, h]);

			// The cylindrical body.
			translate([0, 0, centerBaseHeight])
			cylinder(r=maxMountHoleRadius+3, h=h);
		}

		// The box which clips off the flat edge against the mount.
		translate([-keyX/2,
		           keyY-2*maxMountHoleRadius+offset,
		           centerBaseHeight-smidge/2])
		cube([keyX, 2*maxMountHoleRadius, h+smidge]);

		// Hole for the mount.
		translate([0, 0, -smidge/2])
		cylinder(r=minMountHoleRadius, h=mountHeight+smidge);

		// Hole for the top of the groove mount.			
		translate([0, 0, mountHeight-smidge/2])
		cylinder(r=maxMountHoleRadius, h=mountHeightExt+smidge);

		// Two holes for securing the mount key.
		translate([secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, 10+smidge, center=true, $fn=16);

		translate([-secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, 10+smidge, center=true, $fn=16);
	}
}


module fanArm()
{
/*
	// The M3x20 bolt which will attach the fan.
	translate([0, -m3LooseRadius/2-1, fanLugRadiusOuter])
	rotate([90, 0, 0])
	%cylinder(r=m3LooseRadius, h=20);
/*
	// The hole through the fan.
	translate([0, -6.5, fanLugRadiusOuter])
	rotate([90, 0, 0])
	%cylinder(r=5, h=fanThickness);
*/	
	difference()
	{
		// The body.
		hull()
		{
			translate([0, 0, fanLugRadiusOuter])
			rotate([0, 90, 0])
			cylinder(r=fanLugRadiusOuter,
					 h=fanThickness-5*smidge, center=true);

			translate([0, -5, fanLugRadiusOuter])
			rotate([90, 0, 0])
			scale([1.2, 1, 1])
			cylinder(r=fanLugRadiusOuter, h=20-fanThickness);
		}

		// A hole for the M3x25 bolt to hold it to the effector.
		translate([0, 0, fanLugRadiusOuter])
		rotate([0, 90, 0])
		cylinder(r=m3LooseRadius, h=fanThickness+smidge, center=true);

		// A hole for the M3x20 bolt which will attach the fan.
		translate([0, -m3LooseRadius/2-1, fanLugRadiusOuter])
		rotate([90, 0, 0])
		translate([0, 0, -1])
		cylinder(r=m3LooseRadius, h=21);

		// A hole to capture an M3 nut, for the M3x20 fan bolt.
		translate([0, -(m3LooseRadius+4), (2*fanLugRadiusOuter+smidge)/2])
		cube([5.5+3*smidge,
			  m3NutHeight+3*smidge,
			  2*fanLugRadiusOuter+smidge],
			 center=true);
	}
}


// Draw the effector.
union()
{
	effectorOutside();

	difference()
	{
		effectorInside();

		// The box which clips off the flat edge against the mount key.
		// The extra smidge in the -Y direction helps hold it tight.
		translate([-keyX/2,
		           keyY-smidge,
		           centerBaseHeight])
		cube([keyX,
		      maxMountHoleRadius,
		      totalMountHeight - centerBaseHeight+smidge]);
	}

	%mountKey();

	translate([0, 55, -centerBaseHeight])
	mountKey();
}


// Add the fan arms.
for (i = [0:3])
	rotate([0, 0, 60+i*120])
	translate([0, -43, 0])
	fanArm();
