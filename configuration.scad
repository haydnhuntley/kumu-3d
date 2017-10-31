// Configuration file for the Kumu-3D printer.
//
// DO NOT SLICE THIS.
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

// All measurements in mm.
smidge            = 0.1;
mmPerInch         = 25.4;
m3Radius          = (3.0 + 0.2) / 2;
m3LooseRadius     = m3Radius + 0.2;
m3HeadHeight      = 3.0 + 0.2;
m3HeadRadius      = (5.4 + 0.2) / 2;
m3LooseHeadRadius = m3HeadRadius + 0.2;
m3NutRadius       = (6.25 + 0.75) / 2;
m3LooseNutRadius  = (m3NutRadius + 0.1);
m3TightNutRadius  = (m3NutRadius - 0.1);
m3NutHeight		  = 2.4;
m3NylockNutHeight = 4.0;
m3LooseNutHeight  = 2.4+0.2;
nozzleWidth		  = 0.5;
extrusionWidth    = 20.0;
copperPipeRadius  = 16.0/2 - smidge;
m5Radius          = (5.0 + 0.2) / 2;
m5LooseRadius     = m5Radius + 0.2;
m5HeadHeight      = 5.6;		// For M5 SHCS
m5LooseHeadRadius = 8.6 / 2;	// For M5 SHCS
m5ButtonHeadRadius     = (9.5 + 0.3) / 2;  // For M5 button head
m5ButtonHeadHeight     = 2.5 + 0.5;
m5LowProfileHeadRadius = (9.5 + 0.3) / 2;  // For M5 low profile
m5LowProfileHeadHeight = 1.5 + 0.5;
m5x8Height        = 8;        // For M5x8
m5LooseNutRadius  = (8.9 + 0.4) / 2;
m5NutHeight       = (4.9 + 0.3);
m4LooseNutRadius  = (8.0 + 0.3) / 2;
m4NutHeight       = (3.2 + 0.3);

lowerFrameHeight = 3 * extrusionWidth + 12;
