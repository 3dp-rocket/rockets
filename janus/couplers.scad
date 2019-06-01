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

use <Threading.scad>    // https://www.thingiverse.com/thing:1659079
use <hooks.scad>

module coupler(od, hook=true)
{
    // coupler
    coupler_height = od;
    wall_thickness = 0.05 * od;
    w1 = od/2;
    difference() {
        cylinder(coupler_height, w1, w1, $fn=50);
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+1, w2, w2);
    }
    if(hook)
        hook(od, od*0.25);

}

module coupler_eject(od, hook=true)
{
    // coupler
    coupler_height = od;
    wall_thickness = 0.05 * od;
    w1 = od/2;
    difference() {
        union() {
            cylinder(coupler_height/2, w1-.2, w1-.1, $fn=100);  // conical -don't glue this end 
            translate([0,0,coupler_height/2])
                cylinder(coupler_height/2, w1, w1, $fn=50); // fn=50 provides space for superglue
        }
        
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+1, w2, w2);
    }
    
    if(hook)
        hook(od-.6, od*0.25);

}

module male_coupler_threaded(od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2;
    difference() {
        translate([0,0,0])   
        threading(pitch = 2, d=2*w1, windings=coupler_height/2, full=true); 

        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+3, w2, w2);

    }
 
}

module mcoupler_closed(od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2;
    difference() {
        translate([0,0,0])   
        threading(pitch = 2, d=2*w1, windings=coupler_height/2, full=true); 

        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+3, w2, w2);

    }
    translate([0,0,0])   
        cylinder(5, w1-wall_thickness+.1, w1-wall_thickness+.1);

 
}

module m2coupler(od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2;
    difference() {
        translate([0,0,0])   
        union() {
            threading(pitch = 2, d=2*w1, windings=coupler_height/4, full=true); 
            translate([0,0,coupler_height/2])   
            cylinder(coupler_height/2, w1, w1);
        }
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+3, w2, w2);

    }
 
}

module male_coupler_with_shock_cord_attachment(od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2;
    color(alpha=0.5)
    difference() {
        translate([0,0,0])   
        union() {
            threading(pitch = 2, d=2*w1, windings=coupler_height/4, full=true); 
            translate([0,0,coupler_height/2])   
            cylinder(coupler_height/2, w1, w1);
        }
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+3, w2, w2);
    }
 
    // cap
    translate([0,0,0])   
        cylinder(5, w1-wall_thickness+.1, w1-wall_thickness+.1);
    
    difference() {
        // cord mount
        mh = coupler_height;
        translate([0,0,mh/2])
        cube([od/4,od-2*wall_thickness,mh], center=true);
        for(d = [5,-5]) {
            translate([-od/2,d,coupler_height/2])
            rotate([0,90,0])
                cylinder(od,2,2);
        }
        
    }
    
}
module female_coupler(od, coupler_height)
{
    Threading(pitch = 2, d=od, windings=coupler_height); 
}



module male_coupler_with_motor_tube_lock(od, motor_tube_od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2.;
    w2 = w1 - wall_thickness;
    
    difference() {
        translate([0,0,0])   
        threading(pitch = 2, d=2*w1, windings=coupler_height/2, full=true); 
        translate([0,0,-.1])
        cylinder(coupler_height+3, w2, w2);

    }

    tube_support_od = motor_tube_od/2.0 * 1.1;
    tube_support_id = motor_tube_od/2.0;
    
    difference() {
        cylinder(coupler_height, tube_support_od, tube_support_od);
        translate([0,0,-.1])
            cylinder(coupler_height+1, tube_support_id, tube_support_id);
    }
    
    // attach inner and outer couplers
    for(a = [0:36:360]) {
        echo(a);
        rotate([0,0,a])
            translate([(w2+tube_support_od)/2,0,coupler_height/2.0])
                cube([w2-tube_support_od+0.01,1,coupler_height], center=true);
    }
}


difference()
{
   union() {
     translate([0,0,4])
       //m2coupler_closed(30.5, 20);
     female_coupler(31, 10, $fn=100);
   }
   cube([41,41,41]); 
}
    
translate([100,0,0])
    male_coupler_with_motor_tube_lock(50, 29, 20, $fn=100);

translate([200,0,0])
    male_coupler_with_shock_cord_attachment(od=50, coupler_height=40, $fn=100);


