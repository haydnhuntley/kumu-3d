// Smoothieboard holder.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Louis Dionne
// louis.dionne@gmail.com

$fn=360/6;

include <configuration.scad>;
include <roundedBox.scad>;

// All measurements in mm.
debug               = false;
xSize               = 129.6;
ySize				=  105;
zSize				=   3;
zPcBoard		    =   1.5;
pillarHeight		=   7 - zPcBoard;
edgeWidth           =  15;
outsideEdge         =   5;

// AZSMZ holes.
upperLeft  = [      2.5, ySize-3];
upperRight = [xSize-28, ySize-3];
lowerLeft  = [     9, 8.5];
lowerRight = [xSize-28, 3.5];


module smoothieboardPlate()
{
	difference()
	{
		if (debug)
			translate([0, 0, pillarHeight])
			%cube([xSize, ySize, zPcBoard]);
	
		union()
		{
			// Make the body.
			translate([xSize/2, ySize/2, zSize/2])
			roundedBox([xSize+outsideEdge,
						ySize+outsideEdge,
						zSize], 5, true);

			// Add two tabs for M5x8 screws to attach to the aluminum
			// extrusions.
			translate([xSize/2, extrusionWidth/2-2.5, zSize/2])
			roundedBox([xSize+2*extrusionWidth,
						extrusionWidth,
						zSize],
					   5, true);
						
			// Add four pillars to elevate the PCB slightly.
			addPillar(upperLeft);
			addPillar(upperRight);
			addPillar(lowerLeft);
			addPillar(lowerRight);
		}

		// Make two M5x8 screw holes in the two tabs.
		translate([-extrusionWidth/2, extrusionWidth/2-2.5, 0])
		m5x8();
		translate([xSize+extrusionWidth/2, extrusionWidth/2-2.5, 0])
		m5x8();

		// Remove a cutout in the center.
		translate([xSize/2, ySize/2, zSize/2])
		translate([0, 5, 0])
		roundedBox([xSize-edgeWidth,
					ySize-edgeWidth - 5,
					zSize+smidge],
				   5, true);
				   
		// Make four M3x6 screw holes in the four pillars.
		m3x6(upperLeft);
		m3x6(upperRight);
		m3x6(lowerLeft);
		m3x6(lowerRight);
	}
}

module addPillar(pos)
{
	translate([pos[0], pos[1], 0])
	cylinder(r=m3LooseHeadRadius, h=pillarHeight);
}


module m3x6(pos)
{
	// These holes need to be slightly tight.
	translate([pos[0], pos[1], -smidge/2])
	cylinder(r1=m3Radius, r2=m3LooseRadius, h=pillarHeight+smidge);
}


module m5x8()
{
	// These holes should be loose.
	translate([0, 0, -smidge/2])
	cylinder(r=m5LooseRadius, h=pillarHeight+smidge);
}


smoothieboardPlate();
