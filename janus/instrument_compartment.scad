/*
MIT License

Copyright (c) 1019 Jose D. Saura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/



// More info about instrument compartments:
//  http://www.perfectflite.com/Downloads/StratoLoggerCF%20manual.pdf (vent hole sizes)

use <couplers.scad>

module instrument_compartment(instrument_box_height, body_id, vent_hole_od)
{
    wall_thickness = body_id * 0.05;
    w1 = body_id/2 + wall_thickness;
    w2 = body_id/2;
    
    
    
    difference() {
        cylinder(instrument_box_height, w1, w1);
        translate([0,0,-0.01])
        cylinder(instrument_box_height+0.1, w2, w2);
        
        // vent hole
        translate([0,0,instrument_box_height/2])
        rotate([0,90,0])
            #cylinder(w2*2, vent_hole_od/2, vent_hole_od/2);
        
    }
    
    // threaded coupler bottom
    coupler_height = body_id/4.0;
    color("purple", 0.75)
    translate([0,0,2])
    female_coupler(body_id, coupler_height);

    // threaded coupler top
    color("purple", 0.75)
    translate([0,0,instrument_box_height-1])
    rotate([0,180,0])
    female_coupler(body_id, coupler_height);
    
}

module instrument_compartment_cap(od)
{
    // coupler
    coupler_height = od*0.2;
    wall_thickness = 0.1 * od;
    w1 = od/2;
    difference() {
        cylinder(coupler_height, w1, w1);
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+1, w2, w2);
    }
    cylinder(wall_thickness, w1, w1);
    
}

instrument_compartment(70,50, 0.1, $fn=100);