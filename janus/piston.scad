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

use <BOSL/threading.scad>    
use <hcylinder.scad>
use <couplers.scad>
use <autofn.scad>

// Designed for this cord:
// https://www.amazon.com/gp/product/B00OVI9XE6/ref=ppx_yo_dt_b_search_asin_image?ie=UTF8&psc=1
module piston(od)
{
    thread_size = 1.5;
    difference()
    {
        union() {
            piston_height = od*.75;
            
            wall_thickness = 0.05 * od;
            w1 = od/2-0.1; // -0.1 to ensure it rides smoothly
            difference() {
                cylinder(piston_height, w1, w1, $fn=fn(od));
                
                w2 = w1 - wall_thickness;
                translate([0,0,0])
                cylinder(piston_height+1, w2, w2, $fn=fn(od));
            }
        
            cylinder(2*wall_thickness, w1, w1, $fn=fn(od));
            cylinder(10, 2*thread_size, 2*thread_size, $fn=fn(od));
        }
        
        translate([0,0,-.1])
        cylinder(100, thread_size, thread_size, $fn=fn(od));
    }
}

// designed for this cord:
// https://the-rocketman.com/kevlar-nylon-shock-cords/
module piston_with_screw(od)
{
    thread_size = .1 * od;
    w1 = od/2;

    difference()
    {
        union() {
            piston_height = od*.75;
            
            wall_thickness = 0.05 * od;
            difference() {
                cylinder(piston_height, w1, w1, $fn=fn(od));
                
                w2 = w1 - wall_thickness;
                translate([0,0,0])
                cylinder(piston_height+1, w2, w2, $fn=fn(od));
            }
        
            cylinder(2*wall_thickness, w1, w1, $fn=fn(od));
        }
        
        translate([0,0,-.1])
            cylinder(100, thread_size, thread_size);

        // groove for seal
        //translate([0,0,5])
        //rotate_extrude() {
        //    translate([w1+.2,0,0])
        //        circle(0.5);
        //}

        
    }
    
    translate([0,0,0])
    //Threading(pitch = 2., d=2.*thread_size, windings=10);
    hcylinder(20, thread_size+2, thread_size);
    female_coupler(2.*thread_size, 20);

}

module thread_lock_screw(od)
{
    
    thread_size = .1 * od - 0.2;
    pitch=2;
    starts=1;
    difference() {
        union() {
            cylinder(4, 2*thread_size, 2*thread_size, $fn=12);
            cylinder(22, 0.8*thread_size, 0.8*thread_size, $fn=100);
            
            trapezoidal_threaded_rod(
                d=2*thread_size, 
                l=20, 
                internal=false,
                thread_angle=30,
                thread_depth=pitch/2,
                pitch=pitch, 
                left_handed=false, 
                bevel=true, 
                starts=starts,
                align= [0,0,1], 
                $fa=1, $fs=1);
            
        }
        translate([0,5,0])
        cube([2,thread_size+10,100], center=true);
    }
    
    
}




piston_with_screw(65);
//translate([65/2,0,5])
//color("red") cube(1);

translate([100,0,0])
thread_lock_screw(65);

