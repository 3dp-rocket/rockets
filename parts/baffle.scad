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

use <Threading.scad>    // https://www.thingiverse.com/thing:1659079


module baffle0(h,d,t=5, male=true)
{
    difference() 
    {
        hull() {
            translate([0,0,-d/2])
                cube([h,h,3], center=true);
            cylinder(h, d=d+t, $fn=100);
            rotate([0,90,0])
                cylinder(h, d=d+t,center=true, $fn=100);
        }
        translate([0,0,-1])
        cylinder(h+2, d=d, $fn=100);
        
        rotate([0,90,0])
            cylinder(h+2, d=d,center=true, $fn=100);


    }
    
    if (male) {
        translate([0,0,h-5])
        difference() {
            color("blue")
                cylinder(30, d=d, $fn=100);
            translate([0,0,-1])
                cylinder(32, d=d*0.90, $fn=100);
        }
    }
    
}


module baffle_thread(d,shoulder_height = 20)
{
    
    difference() {
        union() {
            threading(pitch = 2, d=d, windings=shoulder_height/2, full=true, $fn=150);     
            translate([0,0,shoulder_height])
                color("blue")
                    cylinder(shoulder_height, d=d, $fn=100);
        }
        translate([0,0,-1])
            cylinder(2*shoulder_height+2, d=d*0.90, $fn=100);
    }

}

module baffle(coupler_height, d) {
    
    difference() {
        hull() {
            translate([0,0,d/4])
                Threading(pitch = 2., d=d, windings=coupler_height/2, $fn=150); 
            
            rotate([0,90,0])
            cylinder(d, d=d/2+1, center=true);
            
            rotate([0,90,90])
            cylinder(d, d=d/2+1, center=true);
        }
        translate([0,0,15])
            cylinder(100, d=d, $fn=100);

        translate([0,0,12])
            sphere(d/2, $fn=100);
        
        translate([0,0,2])
        rotate([0,90,0])
            cylinder(2*d, d=d/2, center=true);
        
        translate([0,0,2])
        rotate([0,90,90])
            cylinder(2*d, d=d/2, center=true);
        
    }
    translate([0,0,d/4+2])
    Threading(pitch = 2., d=d, windings=coupler_height/2, $fn=150); 
   

}

translate([0,0,80])
    baffle_thread(38.1); //41.5


baffle(30, 38.1+1);




