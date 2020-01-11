/*
MIT License

Copyright (c) 2019 Jose D. Saura

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
use <hcylinder.scad>
use <autofn.scad>

module extension_tube(compartment_height, rocket_od, body_id, motor_tube_id, coupler_height)
{
    
    //echo("ET:", compartment_height, rocket_od, body_id, motor_tube_id, coupler_height);
    w1 = rocket_od/2.;
    w2 = body_id/2.;

    hcylinder(compartment_height, w1, w2);
    
    // threaded coupler bottom
    //coupler_height = body_id/4;
    color("purple", 0.75)
    translate([0,0,1])
    female_coupler(body_id, coupler_height);

    // threaded coupler top
    color("purple", 0.75)
    translate([0,0,compartment_height-1])
    rotate([0,180,0])
    female_coupler(body_id, coupler_height);
    
    // cord attachment
    holder_height = body_id * 0.5;
    translate([0,0,+1*coupler_height]) //compartment_height/2
    {
        difference() {
            // fill the space 
            cylinder(holder_height,body_id/2.,body_id/2., $fn=fn(rocket_od));
            
            // hole for motor tube
            color("cyan")
            cylinder(holder_height+1,motor_tube_id/2., motor_tube_id/2., $fn=fn(rocket_od)); // @ +.15
            
            // taper bottom
            translate([0,0,-0.01])
                cylinder(holder_height*.55,body_id/2.,motor_tube_id/2., $fn=fn(rocket_od));

            // taper top
            translate([0,0,holder_height*.75])
                cylinder(holder_height*.25+0.01,motor_tube_id/2., body_id/2., $fn=fn(rocket_od));

            
            // holes for cord
            hole_id = body_id >= 30 ? body_id >= 80 ? 2.5 : 1.6 : 0.8;
            hole_offset = hole_id * 2 + 0.01*body_id;
            translate([body_id/2-hole_offset, 0,-0.01])
                cylinder(100,hole_id,hole_id);
            translate([-body_id/2+hole_offset, 0,-0.01])
                cylinder(100,hole_id,hole_id);
            translate([0, body_id/2-hole_offset,-0.01])
                cylinder(100,hole_id,hole_id);
            translate([0, -body_id/2+hole_offset,-0.01])
                cylinder(100,hole_id,hole_id);

            
        }
    }
    
    translate([0,0,coupler_height + holder_height])
    color("white")
        ridges(body_id,200-2*coupler_height - holder_height, step=8);

}

module ridges(body_id,h , step=4)
{
    r1 = body_id/2.;
    for (n=[0:step:h]) {
        ridge_size = 1.0;
        translate([0,0,n])
        rotate_extrude(angle=360, $fn=fn(r1)) {
            translate([r1-ridge_size/2.,0,0])
            circle(r=ridge_size);
        }
    }

}

module escapement_ring(body_id)
{
    r1 = body_id/2.;
    r2 = r1 * 0.80;
    h = 20;
    //echo("t",r1-r2);
    difference() {
        hcylinder(h, r1, r2);
        
        //ridges
        ridges(body_id, h);
        
        // holes for shock cord
        hole_r = 1.8;
        for (a=[0:90:360-1])
        rotate([0,0,a])
            translate([(r1+r2)/2, 0,-0.01])
                cylinder(100,r=hole_r, $fn=fn(hole_r));
        
        // expansion 
        gap = 3.14 * 2; // shrink circ. by 2mm when ring is squeezed
        rotate([0,0,45])
        translate([(r1+r2)/2, 0,h/2])
        cube([100,gap,h+1], center=true);
        
        
        // holes for tool
        for (a=[35:20:56])
        rotate([0,0,a])
            translate([(r1+r2)/2, 0,-0.01])
                cylinder(100,r=2.2, $fn=fn(hole_r));

        
    }
    
    
    
}

difference() 
{


union() {
    extension_tube(compartment_height=200, rocket_od=100.069,body_id=92.657, motor_tube_id=58.11, coupler_height=29, $fn=100);

    translate([0,0,145+0.5])
        color("blue", 0.8)
        escapement_ring(92.657);
}

    translate([0,-60,0])
        cube([60,60, 300]);

}

translate([0,0,-15.6])
male_coupler_threaded(od=92.657-0.2, coupler_height=38);




