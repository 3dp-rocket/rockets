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
use <couplers.scad>

module parachute_compartment(compartment_height, body_id)
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
    translate([0,0,2])
    color("purple", 0.75)
    female_coupler(body_id-0.5, coupler_height);
    
}

    
parachute_compartment(200, 50, $fn=100);
