// Fuse/plug holder.
//
// This is my favorite lit switch, it includes the fuse and is the least
// expensive:
//
// http://www.robotdigg.com/product/744/AC-rocker-switch-power-inlet-socket-w/-fuse
//
//
// It also works with this lit switch from Amazon:
//
// http://www.amazon.com/uxcell%C2%AE-IEC320-Inlet-Switch-Socket/dp/B00N41D5Z4
//
// uxcell 2 Pcs IEC320 C14 Inlet Green Lamp Switch Power Socket AC 250V
//
//
// Or this one:
//
// http://www.amazon.com/gp/product/B00ME5YAPK/ref=oh_aui_detailpage_o03_s01
//
// URBEST Inlet Module Plug Fuse Switch Male Power Socket 10A 250V 3 Pin
// IEC320 C14
//
//
// Note: the above two switches do *not* include the fuse!
//
// Here are the fuses:
//
// http://www.amazon.com/PODOY-Qty-Fast-Blow-GMA10A-GMA10/dp/B004HLYUE0
//
// PODOY 5 Qty. GMA 10A Fast-Blow Fuse 10 Amp 250v GMA10A, GMA10


$fn=360/12;

include <configuration.scad>
include <roundedBox.scad>;


// All measurements in mm.
xBody				   = 70;
yBody				   = lowerFrameHeight;
zBody				   =  3;
zTube				   = 30;
xOpening               = 47+2;
yOpening               = 27+1;
mountingHoleSeparation = 40;


module fusePlugHolder()
{
	translate([0, 0, zBody/2])
	difference()
	{
		union()
		{
			// Make the body.
			roundedBox([xBody,
						yBody,
						zBody], 5, true);

			translate([0, 0, zTube/2])
			roundedBox([xOpening+3,
						yOpening+3,
						zBody+zTube], 4, true);
		}

		// Remove the center, where the fuse/plug holder slides in.
		translate([0, 0, zTube/2])
		roundedBox([xOpening,
					yOpening,
					zBody+zTube+smidge], 3, true);

		// Remove two holes to use for mounting the fuse/plug holder.
		makeTightHole(0,  mountingHoleSeparation/2);
		makeTightHole(0, -mountingHoleSeparation/2);

		// Remove four M5x8 holes for mounting
		m5x8Slot( xBody/2-extrusionWidth/2,  yBody/2 - extrusionWidth/2);
		m5x8Slot(-xBody/2+extrusionWidth/2,  yBody/2 - extrusionWidth/2);
		m5x8Slot( xBody/2-extrusionWidth/2, -yBody/2 + extrusionWidth/2);
		m5x8Slot(-xBody/2+extrusionWidth/2, -yBody/2 + extrusionWidth/2);
	}
}


module m5x8Slot(x, y)
{
	offset = 1.0;
	hull()
	{
		translate([x, y, 0])
		cylinder(r=m5LooseRadius, h=zBody+smidge, center=true);
		if (y < 0)
			translate([x, y+offset, 0])
			cylinder(r=m5LooseRadius, h=zBody+smidge, center=true);
		if (y > 0)
			translate([x, y-offset, 0])
			cylinder(r=m5LooseRadius, h=zBody+smidge, center=true);
	}
}


module makeTightHole(x, y)
{
	translate([x, y, 0])
	cylinder(r=m3Radius-smidge, h=zBody+smidge, center=true);
}


fusePlugHolder();
