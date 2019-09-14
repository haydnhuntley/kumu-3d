// Outside Carriage piece for 2020 aluminum extrusions and ~24mm diameter
// wheels riding on the diagonals, with GT2 belt tightener.  This works
// nicely with the ball studs and carbon fiber, magnetic, zero-backlash
// printer arms which I have for sale.
//
// This provides extra stiffening for the carriages.
//
// Haydn Huntley
// haydn.huntley@gmail.com


$fn = 360/4;

include <configuration.scad>;
include <roundedBox.scad>;


// All measurements in mm.
eccentricSpacerRadius = (7.1 + 0.3)/2;
xAxleSpacing          = extrusionWidth * sqrt(2) + 19.1 - 0.35;
yAxleSpacing          = 30.0;
xBody                 = max(xAxleSpacing + 2 * 7, ballJointSeparation + 2 * 5);
yBody                 = yAxleSpacing + 2 * 7;
zBody                 = 5.0;
//yBallStudOffset       = yAxleSpacing/2;
//xInsideBeltOffset     = 5;

wheelWidth                     = 11.0;
gapBetweenCarriageAndExtrusion =  2;
gapBetweenBeltAndExtrusion     = 17;
aluminumSpacerRadius           = 10.0/2;
aluminumSpacerHeight           = 0.25 * mmPerInch;
spacerHeight = extrusionWidth * sin(45) + gapBetweenCarriageAndExtrusion - wheelWidth/2 - aluminumSpacerHeight - 1.0;


module outsideCarriage()
{
	difference()
	{
		union()
		{
			// The round-cornered rectangle body.
			translate([0, 0, zBody/2])
			roundedBox([xBody, yBody, zBody], 5, true);
		}

		// Place a hole in the center to lighten it.
		translate([0, 0, zBody/2])
		roundedBox([xBody-4*7, yBody-3*7, zBody+smidge], 5, true);

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
	}
}


module m5x50(h=0)
{
	cylinder(r=m5Radius, h=h);
}


module spacer()
{
	difference()
	{
		cylinder(r=aluminumSpacerRadius, h=spacerHeight);

		translate([0, 0, -smidge/2])
		cylinder(r=m5LooseRadius, h=spacerHeight+smidge);
	}
}


outsideCarriage();

for (x = [-1.5, -0.5, 0.5, 1.5])
	translate([x*12, 30, 0])
	spacer();