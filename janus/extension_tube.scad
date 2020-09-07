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
use <cord_attachment.scad>
include <constants.scad>

module extension_tube(compartment_height, rocket_od, body_id, motor_tube_id, coupler_height, escapement=true)
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

    
    translate([0,0,+1*coupler_height]) //compartment_height/2
        cord_attachment(rocket_od, body_id, motor_tube_id);
    
    if (escapement) {
        // ridges in the inside of the tube to allow disipating 
        // shock cord energy 
        holder_height = body_id * 0.5;
        translate([0,0,coupler_height + holder_height])
        color("white")
            ridges(body_id,compartment_height-2*coupler_height - holder_height, step=8);
    }
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

/* 
Still in beta. The idea for this ring is to help disipate the shock cord energy 
and avoid a zipper. It fits at the bottom of the extension tube. The 4 shock cords goes through
the top section of the tube and then the holes on this part and are tied together.
When the shock cord pulls hard, this part will move through the tube and hopefully absorve
some of the energy... never tested.
*/
module escapement_ring(od, id)
{
    // r1 should be the rocket body id radius
    r1 = od/2.;
    // r2+1 allows ring to expand without pushing into the paper motor tube
    r2 = id/2.+1; 
    h = 20;
    //echo("EXP RING", od,id);
    difference() {
        union() {
            hcylinder(h, r1, r2);
            // this will leave holders after the gap is cut 
            // for a tool to squeeze the ring
            rotate([0,0,45])
            translate([(r1+r2)/2, 0,h])    
                cube([r1-r2-6,18,9], center=true);
        }
        
        //ridges
        ridges(od, h);
        
        // holes for shock cord
        hole_r = 1.8;
        for (a=[0:90:360-1])
        rotate([0,0,a])
            translate([(r1+r2)/2-1, 0,-0.01])
                cylinder(100,r=hole_r, $fn=fn(hole_r));
        
        // expansion 
        gap = 3.14 * 4; // gap size
        rotate([0,0,45])
        translate([(r1+r2)/2, 0,h/2])
        cube([od/2,gap,h+10], center=true);
        
        
    }
    

}

difference() 
{


union() {
    extension_tube(compartment_height=200, rocket_od=100.069,body_id=92.657, motor_tube_id=58.11, coupler_height=29, $fn=100);

    translate([0,0,145+0.5])
        color("blue", 0.8)
        escapement_ring(od=92.657, id=63.93); 
        //escapement_ring(51.8021, 35.739);
    
}

    translate([0,-60,0])
        cube([60,60, 300]);

}

translate([0,0,-15.6])
male_coupler_threaded(od=92.657-0.2, coupler_height=38);





