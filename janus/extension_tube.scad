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


//
// Design for a body tube extension with shock cord attachment 
// Designed for this cord:
// https://www.amazon.com/gp/product/B00OVI9XE6/ref=ppx_yo_dt_b_search_asin_image?ie=UTF8&psc=1

// Thread two independent short cords through the internal holes (2 holes per cord)
// then attach those two cords to the main cord. This gives some redundancy in case
// part of teh support breaks.

// A single thread was stress tested at 50x the weight of the rocket. Two cords should
// provide enough support. (PETG, 20% infill)
//

use <couplers.scad>


module extension_tube(compartment_height, body_id, motor_tube_id)
{
    
    wall_thickness = body_id * 0.05;
    w1 = body_id/2 + wall_thickness;
    w2 = body_id/2;
    
    difference() {
        cylinder(compartment_height, w1, w1);
        translate([0,0,-0.01])
        cylinder(compartment_height+0.1, w2, w2);

    }
    // threaded coupler bottom
    coupler_height = body_id/4;
    color("purple", 0.75)
    translate([0,0,1])
    female_coupler(body_id-0.5, coupler_height);

    // threaded coupler top
    color("purple", 0.75)
    translate([0,0,compartment_height-1])
    rotate([0,180,0])
    female_coupler(body_id-0.5, coupler_height);
    
    // cord attachment
    holder_height = body_id;
    translate([0,0,+2*coupler_height]) //compartment_height/2
    {
        difference() {
            // fill the space 
            cylinder(holder_height,body_id/2.,body_id/2.);
            
            // hole for motor tube
            cylinder(holder_height+1,motor_tube_id/2, motor_tube_id/2);
            
            // taper so we don neet to use supports
            translate([0,0,-0.01])
                cylinder(holder_height*.75,body_id/2.,motor_tube_id/2);
            
            // holes for cord
            hole_id = 1.5;
            translate([body_id/2-3.0, 0,-0.01])
                cylinder(100,hole_id,hole_id);
            translate([-body_id/2+3, 0,-0.01])
                cylinder(100,hole_id,hole_id);
            translate([0, body_id/2-3,-0.01])
                cylinder(100,hole_id,hole_id);
            translate([0, -body_id/2+3,-0.01])
                cylinder(100,hole_id,hole_id);

            
        }
    }
    
}


extension_tube(compartment_height=200, body_id=50, motor_tube_id=30, $fn=100);
