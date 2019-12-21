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


module coupler(od, hook=true)
{
    // coupler
    coupler_height = od;
    wall_thickness = 0.05 * od;
    w1 = od/2;
    difference() {
        cylinder(coupler_height, w1, w1, $fn=150);
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+1, w2, w2);
    }
   }

module coupler_eject(od, hook=true)
{
    // coupler
    coupler_height = od;
    wall_thickness = 0.05 * od;
    w1 = od/2;
    difference() {
        union() {
            cylinder(coupler_height/2, w1-.2, w1-.1, $fn=150);  // conical -don't glue this end 
            translate([0,0,coupler_height/2])
                cylinder(coupler_height/2, w1, w1, $fn=50); 
        }
        
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+1, w2, w2);
    }
    
  

}

module male_coupler_threaded(od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2;
    difference() {
        translate([0,0,0])   
        threading(pitch = 2, d=2*w1, windings=coupler_height/2, full=true, $fn=150); 

        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+3, w2, w2, $fn=150);

    }
    
 
}

module male_coupler_with_hook(od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2;
    difference() {
        translate([0,0,0])   
        threading(pitch = 2, d=2*w1, windings=coupler_height/2, full=true); 

        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(coupler_height+3, w2, w2, $fn=150);

    }
    
    difference() {
        sh = coupler_height/2.;
        translate([0,0, sh/2.])
        cube([od-wall_thickness-0.3, w1*0.3,sh], center=true);
        for(h=[0,2,3]) {
            translate([od/4-h*od/4,0, sh/2.])
            rotate([90,0,0])
                cylinder(10,2,2, center=true,$fn=100);
        }
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

module male_coupler_with_shock_cord_attachment(od_threaded, od_smooth, thread_height, shoulder_heigth)
{
    // coupler
    wall_thickness = 0.075 * od_threaded;
    w1 = od_threaded/2.;
    color(alpha=0.5)
    difference() {
        translate([0,0,0])   
        union() {
            pitch=2;
            threading(pitch = pitch, d=2*w1, windings=(thread_height/pitch), full=true); 
            color("blue",0.6)
            translate([0,0,thread_height])   
            cylinder(shoulder_heigth, od_smooth/2, od_smooth/2);
        }
        w2 = w1 - wall_thickness;
        translate([0,0,-.1])
        cylinder(2*shoulder_heigth+3, w2, w2);
    }
 
    // cap
    cap_height = 5;
    translate([0,0,0])   
        cylinder(cap_height, w1-wall_thickness+.1, w1-wall_thickness+.1);
    
    difference() {
        // cord mount
        mh = max(thread_height,20);
        translate([0,0,mh/2])
        #cube([od_threaded/4.,od_threaded-2*wall_thickness,mh], center=true);
        
        for(d = [od_threaded/4,-od_threaded/4]) {
            translate([-od_smooth/2,d,cap_height+ 2*2.5])
            rotate([0,90,0])
                cylinder(od_smooth,2.5,2.5);
        }
        
    }
    
}
module female_coupler(od, coupler_height)
{
    Threading(pitch = 2., d=od, windings=coupler_height/2.+1, $fn=150); 
}



module male_coupler_with_motor_tube_lock(od, motor_tube_od, coupler_height)
{
    // coupler
    wall_thickness = 0.075 * od;
    w1 = od/2.;
    w2 = w1 - wall_thickness;
    
    difference() {
        translate([0,0,0])   
        threading(pitch = 2., d=2*w1, windings=coupler_height/2., full=true); 
        translate([0,0,-.1])
        cylinder(coupler_height+10, w2, w2);

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
        rotate([0,0,a])
            translate([(w2+tube_support_od)/2,0,coupler_height/2.0])
                cube([w2-tube_support_od+0.01,1,coupler_height], center=true);
    }
}


module male_coupler_with_test_charge(od, coupler_height)
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

    difference() {
        cylinder(10, w1+2,w1+2, $fn=12);

        // holes for screws for electric contacts
        translate([w1/2+2,0,-1])
            cylinder(60, d1=2.,d2=2., $fn=100);
        // holes for screws for electric contacts
        translate([-w1/2-2.,0,-1])
            cylinder(60, d1=2.,d2=2., $fn=100);
    
    
    }
    
    difference() {
        cylinder(coupler_height, 10, 10, $fn=100);
        translate([0,0, coupler_height-15+0.001])
            cylinder(15, d1=12.6,d2=12.6, $fn=100);
        translate([0,0, coupler_height-20+0.002])
             cylinder(5, d1=0,d2=12.6, $fn=100);
        
    }
    

    
    //Threading(pitch = 2., d=20.0, windings=10); 
    /*
    difference() {
        cylinder(10, w1+2,w1+2, $fn=12);
        translate([0,0,-.1])
        cylinder(60, d1=20.,d2=20.);

        // holes for screws for electric contacts
        translate([w1/2+2,0,-1])
            cylinder(60, d1=2.,d2=2., $fn=100);
        // holes for screws for electric contacts
        translate([-w1/2-2.,0,-1])
            cylinder(60, d1=2.,d2=2., $fn=100);
        
        cylinder(60, d1=20.,d2=20.);
    }
    */
    
    // powder compartment screw
    //translate([0,0, 100])
    //    difference() {
    //        threading(pitch = 2, d=20-0.5, windings=coupler_height/2, full=true); 
    //        translate([0,0, -1])
    //            #cylinder(20, d1=12.6,d2=12.6, $fn=100);
    //    }

    
}



difference()
{
   union() {
       
     r = 40;
     translate([0,0,4])
        male_coupler_with_shock_cord_attachment(od_threaded=r-1.0, 
                    od_smooth=r,thread_height=30, shoulder_heigth=30, $fn=150);
     /*
       color("red", 0.6)
        female_coupler(r-0.5, 10, $fn=100);
       
     difference() {
       color("blue", 0.6)
        cylinder(25, r/2.0+5, r/2.0+5);
        cylinder(25, r/2.0, r/2.0);
     }
       */
       
   }
   cube([41,41,41]); 
}
    
//translate([100,0,0])
//    male_coupler_with_motor_tube_lock(50, 29, 20, $fn=100);

translate([200,0,0])
    male_coupler_with_shock_cord_attachment(od_threaded=20.5, od_smooth=20,thread_height=20, shoulder_heigth=20, $fn=100);

translate([0,200,0])
male_coupler_with_test_charge(60, 60);