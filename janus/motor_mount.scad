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
use <hcylinder.scad>
use <couplers.scad>
use <launch_lug.scad>

LUG_ROD_1_8 = 1;
LUG_ROD_3_16 = 2;
LUG_RAIL_8010 =3;

module fin_motor_mount(rocket_od, rocket_id, motor_tube_od, motor_tube_id, motor_height, motor_tube_height, fin_height, fin_slot_width, fin_slot_height, launch_lug_type, add_thrust_stopper=false)
{
    motor_support_thickness = 0.1 * motor_tube_id;
    motor_tube_od = (motor_tube_id + motor_support_thickness) ;

    // rocket outer shell
    w1 = rocket_od/2.;
    ring_height = 0.6 * motor_tube_id; 
    echo(rocket_od);
    difference() {
        union() {
            translate([0,0,ring_height])
                // outer shell
                hcylinder(motor_tube_height-ring_height, w1, rocket_id/2.0);
            
            // motor mount
            motor_mount(motor_tube_od, motor_tube_id, rocket_id, motor_height,  fin_height, fin_slot_width, ring_height, add_thrust_stopper);
        }
        
        fin_slots(motor_tube_od, fin_height,fin_slot_width, motor_tube_height, ring_height, fin_slot_height);

    }
    
    // threaded coupler top
    coupler_height = rocket_id/4.0;
    color("purple", 0.75)
    translate([0,0,motor_tube_height-1])
    rotate([0,180,0])
    female_coupler(rocket_id, coupler_height);  // ?-1
    
    // launch lugs
    if (launch_lug_type>0)
    {
        if (launch_lug_type <3) 
        {
            lug_id = launch_lug_type == LUG_ROD_1_8 ? 4 : 5.75;
            lug_od = 1.3 * lug_id;
            block_width = 0.05 * rocket_id;
            lug_length = max(rocket_od/1.5, 16); //body_id/2;
            rocket_wall_width = rocket_od-rocket_id;
        
            rotate([0,0,60+15])
            {
                lug_x = 0.99*(rocket_id)/2 + lug_od/2 + rocket_wall_width + block_width/2;
                translate([lug_x,0,ring_height + lug_length/2 ])
                {
                    lug(lug_od, lug_id, lug_length, block_width);
                }
            
                translate([lug_x,0,motor_tube_height-lug_length])
                {
                    lug(lug_od, lug_id, lug_length, block_width);
                }

            }
        }
        else
        {
            lug_heigth = 0.75 * rocket_id;
            rotate(60+15)
            translate([rocket_id/2+6,0,ring_height])
            rotate(-90)
            rail_launch_lug(lug_heigth);
            
            translate([0,0, motor_tube_height - lug_heigth ])
            {
                rotate(60+15)
                translate([rocket_id/2+6,0,0])
                rotate(-90)
                rail_launch_lug(lug_heigth);
            }
        }

    }
    
    
}

module motor_mount(motor_tube_od, motor_tube_id, rocket_id, motor_height, fin_height, fin_slot_width, ring_height, add_thrust_stopper)
{
    // motor mount
   

    difference() {
        union()
        {
            w2 = motor_tube_id / 2.0;
            translate([0,0,ring_height])
                color("yellow", 0.6)
                hcylinder(motor_height, motor_tube_od/2., w2);
            
            if (add_thrust_stopper)
                color("blue")
                translate([0,0,motor_height])
                    hcylinder(10, w2, 0.7*w2);
            
            // thread for motor retainer
            thread_od = (rocket_id+motor_tube_od)/2.;
            pitch = 1.5;
            color("blue")
            difference() {
                threading(pitch = pitch, d=thread_od, windings=ring_height/pitch, full=true); 
                translate([0,0,-.1])
                    cylinder(ring_height+10, motor_tube_id / 2.0, motor_tube_id / 2.0);
            }
                
            color("green", 0.8)
            {
                
                for(a=[0:360/3:360]) {
                    rotate([0,0,a])
                    {
                        translate([0,0,ring_height])
                        {
                            t = (rocket_id-motor_tube_od)/2.;
                            rotate_extrude(angle=30, convexity=10)
                            translate([motor_tube_od/2.-0.1, 0, 0])  // manifold error =>
                            square([t+.2,motor_height], center=false); //mandifold error+.2
                        }
                    }
                }
                
                translate([0, 0, ring_height])
                    hcylinder(5, rocket_id/2.0, motor_tube_od/2.0);
                translate([0, 0, motor_height/2.])
                    hcylinder(5, rocket_id/2.0, motor_tube_od/2.0);
                translate([0, 0, motor_height+10])
                    hcylinder(15, rocket_id/2.0, motor_tube_od/2.0);
                
                
            }
            
        }

        // this section removes a conical space 
        // so the top edge won't need to use supporters when printed
        // the engine mount should be printed upside-down
        //if (add_thrust_stopper)
        translate([0,0,motor_height-rocket_id/2+5])
        cylinder(rocket_id, 0, rocket_id/2);
        
        //translate([0,0,motor_height-rocket_id/2+5])
        //cube([100,100,100]);
     }
   
}

module fin_slots(motor_tube_od, fin_height, fin_slot_width, motor_tube_height, ring_height, fin_slot_height)
{
    // slots
    for(a=[0:360/3:360]) {
        rotate([0,0,a])
        {
           translate([0,0,0])
           {
                rotate([0,0,15])
                translate([motor_tube_od/2-0*fin_slot_height/4, 0, 0]) {
                   rotate([0,0,-90]) {
                    key_h = .04 * fin_height;
                    h =fin_height + ring_height + key_h;
                       difference() {
                            linear_extrude(h)
                                polygon(polygon_slot(fin_slot_height, fin_slot_width));
                           // remove tiny top section of slot to make room for the  "key"
                           // under the body shell. 
                           translate([0, fin_slot_height/1.0, h-key_h/2.])
                            cube([fin_slot_width,fin_slot_height/2,key_h], center=true);
                       }
                       
                   }
                    
                }

            }
        }
    }
    
}

function polygon_slot(fin_slot_height,fin_slot_width) = 
[[-fin_slot_width/2.,0],[-fin_slot_width/3.,fin_slot_height],[fin_slot_width/3.,fin_slot_height],[fin_slot_width/2.,0] ];


fin_motor_mount(rocket_od=55.52, rocket_id=50.47, motor_tube_od=35.42, motor_tube_id=32.2, motor_height=114, motor_tube_height=190, fin_slot_width=4.84211, fin_slot_height=10.05, fin_height=70, launch_lug_type=3, add_thrust_stopper=false, $fn = 100);




