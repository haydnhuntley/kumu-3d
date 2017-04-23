// AZSMZ holder.

$fn=360/12;

include <configuration.scad>;
include <roundedBox.scad>;

// All measurements in mm.
debug               = false;
xSize               = 103.75;
ySize               =  68.0;
zSize               =   3;
zPcBoard            =   1.5;
yPcBoardOffset		=  10;
pillarHeight        =   7 - zPcBoard;
yTabOffset			=   2.5;
edgeWidth           =  15;
outsideEdge         =   5;
radius              =   5;
sdOffset			=  39;
sdWidth             =  14;
sdOpeningWidth      =  50;

// AZSMZ holes.
upperLeft  = [      3.5, ySize-3.25];
upperRight = [xSize-3.5, ySize-3.25];
lowerLeft  = [     12.8, 3.75];
lowerRight = [xSize-3.5, 3.75];


module azsmzPlate()
{
    difference()
    {
        if (debug)
        {
			// Show the AZSMZ board.
            translate([0, yPcBoardOffset, pillarHeight])
            %cube([xSize, ySize, zPcBoard]);

            translate([sdOffset, yPcBoardOffset-5, pillarHeight])
            %cube([sdWidth, 5, zPcBoard]);
        }
    
        union()
        {
            // Make the body.
            translate([xSize/2, yPcBoardOffset+ySize/2, zSize/2])
            roundedBox([xSize+outsideEdge,
                        ySize+outsideEdge,
                        zSize],
                       radius, true);

            // Add extra material for filleting the corners between the tabs
            // and body.
            // Left:
            translate([-radius-outsideEdge/2, extrusionWidth-yTabOffset, 0])
			cube([radius, radius, zSize+smidge]);
			// Right:
            translate([xSize+radius-outsideEdge/2,
					   extrusionWidth-yTabOffset,
					   0])
			cube([radius, radius, zSize+smidge]);
			
            // Add two tabs for M5x8 screws to attach to the aluminum
            // extrusions.
            translate([xSize/2, extrusionWidth/2-yTabOffset, zSize/2])
            roundedBox([xSize+2*extrusionWidth,
                        extrusionWidth,
                        zSize],
                       radius, true);
                        
            // Add four pillars to elevate the AZSMZ slightly.
            addPillar(upperLeft);
            addPillar(upperRight);
            addPillar(lowerLeft);
            addPillar(lowerRight);
        }

        // Make two M5x8 screw holes in the two tabs.
        translate([-extrusionWidth/2, extrusionWidth/2-yTabOffset, 0])
        m5x8();
        translate([xSize+extrusionWidth/2, extrusionWidth/2-yTabOffset, 0])
        m5x8();

        // Remove a cutout in the center.
        translate([xSize/2, yPcBoardOffset+ySize/2, zSize/2])
        roundedBox([xSize-edgeWidth,
                    ySize-edgeWidth,
                    zSize+smidge],
                   radius, true);

        // Remove a cutout to make it easier to remove the SD card.
        translate([sdOffset+sdWidth/2, 0, zSize/2])
        roundedBox([sdOpeningWidth, 20, zSize+smidge], radius, true);

        // Round the left inside corner by the cutout for the SD card.
        difference()
        {
			translate([sdOffset+sdWidth/2-radius-sdOpeningWidth/2,
					   -yTabOffset-smidge/2,
					   -smidge/2])
			cube([radius+smidge, radius+smidge, zSize+smidge]);

			translate([sdOffset+sdWidth/2-radius-sdOpeningWidth/2,
					   yTabOffset,
					   0])
			cylinder(r=radius, h=zSize+2*smidge);
        }
                   
        // Round the right inside corner by the cutout for the SD card.
        difference()
        {
			translate([sdOffset+sdWidth/2+sdOpeningWidth/2-smidge/2,
					   -yTabOffset-smidge/2,
					   -smidge/2])
			cube([radius+smidge, radius+smidge, zSize+smidge]);

			translate([sdOffset+sdWidth/2+radius+sdOpeningWidth/2,
					   yTabOffset,
					   0])
			cylinder(r=radius, h=zSize+2*smidge);
        }

        // Round the outside corners between the tabs and body.
        // Left:
        translate([-radius-outsideEdge/2,
				  radius+extrusionWidth-yTabOffset,
				  -smidge/2])
		cylinder(r=radius, h=zSize+2*smidge);
		// Right:
        translate([xSize+2*radius-outsideEdge/2,
			       radius+extrusionWidth-yTabOffset,
				   -smidge/2])
		cylinder(r=radius, h=zSize+2*smidge);
			
        // Make four M3x6 screw holes in the four pillars.
        m3x6(upperLeft);
        m3x6(upperRight);
        m3x6(lowerLeft);
        m3x6(lowerRight);
    }
}

module addPillar(pos)
{
    translate([pos[0], pos[1]+yPcBoardOffset, 0])
    cylinder(r=m3LooseHeadRadius, h=pillarHeight);
}


module m3x6(pos)
{
    // These holes need to be slightly tight.
    translate([pos[0], pos[1]+yPcBoardOffset, -smidge/2])
    cylinder(r1=m3Radius-smidge, r2=m3LooseRadius, h=pillarHeight+smidge);
}


module m5x8()
{
    // These holes should be loose.
    translate([0, 0, -smidge/2])
    cylinder(r=m5LooseRadius, h=pillarHeight+smidge);
}


azsmzPlate();
