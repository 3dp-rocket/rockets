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

use <../parts/nose.scad>
use <couplers.scad>

module rocket_nose(h, body_id) {
    
    wall_thickness = body_id * 0.05;
    w1 = body_id/2 + wall_thickness;
    w2 = body_id/2;
    
    // straight section serves as base of cone an coupling
    cone_base = h/3;
    
    // cone
    translate([0,0,cone_base ]) 
    nose_cone_haack(l=h-cone_base, r=w1, c=1/3, wall_thickness=wall_thickness);
    //nose_cone_power(h/2, w1, n=.6);
    //nose_cone_eliptical(w1, 0.90*w1, 1);
    
    // base
    difference() {
        cylinder(cone_base+.001, w1, w1); // +.001 so they overlap, got separated on slicer
        translate([0,0,-0.01])
        cylinder(cone_base+0.1, w2, w2);
    }
    
    // threaded coupler bottom
    coupler_height = body_id/4.0;
    
    color("purple", 0.75)
    translate([0,0,2])
    female_coupler(body_id, coupler_height);
    
}

rocket_nose(100,30, $fn=100);