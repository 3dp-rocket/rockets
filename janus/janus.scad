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


use <janus_nose.scad>
use <janus_fin.scad>
use <couplers.scad>
use <instrument_compartment.scad>
use <parachute_compartment.scad>
use <extension_tube.scad>
use <piston.scad>
use <motor_mount.scad>
use <retainer.scad>

part = "all";

$fn=100;

a = 0;
A = 1;
B = 2;
C = 3;
D = 4;
E = 5;
F = 6;


MOTOR_ESTES_TYPE = 1;   // support inside tube
MOTOR_AEROTECH_TYPE =2; // motor has its own support ring - retainer is larger


//*********************************************
// Set these variables.
model = F;  // a,A,B,C....F
motor_type = MOTOR_AEROTECH_TYPE;  
paper_tube_wall_thickness = 1.6; // mm
//*********************************************

MOTOR_OD = 0;
MOTOR_LENGTH = 1;

rocket_parameters = [
    [ 13.3, 44.2],  // a*
    [ 13.3, 70.00],  // A
    [ 13.3, 70.00],  // B
    [ 18.0, 70.00],  // C*
    [ 24.0, 70.00],  // D**
    [ 29.0, 114.00],  // E
    [ 29.0, 114.00]  // F
    

];

printer_max_height = 200;

p = rocket_parameters[model];

motor_od = p[MOTOR_OD]; // * (1 + 0.15); // + tube
motor_height = p[MOTOR_LENGTH];
motor_tube_height = min(2.0 * motor_height ,printer_max_height);

motor_tube_id = motor_od + 2.0*paper_tube_wall_thickness;
motor_tube_od = motor_tube_id * 1.1;

rocket_id = 1.5675 * motor_tube_id; //1.5038
rocket_od = rocket_id + 2*0.05*rocket_id;

// fin and fin slot dimensions
fin_height = 2.05 * rocket_id;
fin_slot_width=0.15037594 * motor_tube_id;
fin_slot_height = (rocket_od-motor_tube_od)/2;

// the thrust stopper won't be created if motor_type != ESTES
thrust_height = motor_type == MOTOR_ESTES_TYPE?10:0;
body_height = min(7.5188 * motor_od ,printer_max_height);

nose_tube_height = 6 * motor_od;
// add extra length to trimed from body_height exceedeing printer_max_height
instrument_compartment_height = 70;

//http://www.perfectflite.com/Downloads/StratoLoggerCF%20manual.pdf
vent_hole_od = instrument_compartment_height * rocket_id* .00037;

parachute_compartment_height = min(100 + 3*motor_od + (7.5188 * motor_od-body_height), printer_max_height);

extension_tube_height = parachute_compartment_height; 

motor_overhang = (motor_type == MOTOR_AEROTECH_TYPE)?5.5:5; // motor overhang for easier removal

pitch = 1.25;  // retainer screw pitch
windings = 5;  // retainer screw windings


retainer_male_base_h = 2; // base under male screw
retainer_male_height = pitch * (windings +1) + retainer_male_base_h; 
retainer_male_base_od = (rocket_id);

retainer_male_od = (rocket_id + motor_tube_od) /2.0; // see motor_mount.scad


LUG_ROD_1_8 = 1;
LUG_ROD_3_16 = 2;
LUG_RAIL_8010 =3;

launch_lug_type = motor_od < 14 ? LUG_ROD_1_8 : motor_od < 25 ? LUG_ROD_3_16 : LUG_RAIL_8010;

echo("rocket OD:", rocket_od);
echo("rocket ID:", rocket_id);

echo("motor tube OD:", motor_tube_od);
echo("motor tube ID:", motor_tube_id);
echo("motor tube height:", motor_tube_height);

echo("motor od    :", motor_od);
echo("motor height:", motor_height);

echo("body height      :", body_height);

echo("fin height       :", fin_height);
echo("fin slot width   :", fin_slot_width);
echo("fin slot height  :", fin_slot_height);


echo("parachute_compartment_height:", parachute_compartment_height);

echo("nose cone total height", nose_tube_height);
echo("nose cone height", nose_tube_height * 2/3);
echo("nose base", nose_tube_height * 1/3);
echo("wall thickness", rocket_id*0.05);

echo("retainer OD", retainer_male_od);

module exploded_view()
{
    top = printer_max_height *5 - 40;
    translate([0,0,top])
    rocket_nose(h=nose_tube_height, body_id=rocket_id);
    
    coupler_height = rocket_id;
    translate([0,0,top-coupler_height])
    male_coupler_threaded(rocket_id-0.5,coupler_height-10);

    translate([0,0,top-coupler_height - instrument_compartment_height - 10])
    instrument_compartment(instrument_compartment_height, rocket_id, vent_hole_od);
    
    translate([0,0,top-1*coupler_height - instrument_compartment_height - 20])
        rotate([0,180,0])
        male_coupler_with_shock_cord_attachment(od=rocket_id-0.5, coupler_height=coupler_height);
    
    translate([0,0,top-2*coupler_height - instrument_compartment_height - 30])
        rotate([0,180,0])
    {
        parachute_compartment(parachute_compartment_height, rocket_id); 
        translate([+rocket_od, rocket_od, +rocket_od])
        piston(rocket_id);
    }

    translate([0,0,top-3*coupler_height - instrument_compartment_height - parachute_compartment_height - 30])
    male_coupler_threaded(rocket_id-0.5,coupler_height-10);

translate([0,0,top-3*coupler_height - instrument_compartment_height - parachute_compartment_height - extension_tube_height- 40]) 
    
    extension_tube(extension_tube_height, rocket_id, motor_tube_id); 

translate([0,0,top-4*coupler_height - instrument_compartment_height - parachute_compartment_height - extension_tube_height- 40])

    male_coupler_threaded(rocket_id-0.5,coupler_height-10);

    translate([0,0,top-4*coupler_height - instrument_compartment_height - parachute_compartment_height - extension_tube_height- motor_tube_height - 50])
    {

        fin_motor_mount(rocket_od, rocket_id, motor_tube_od, motor_tube_id, motor_height, motor_tube_height,  fin_height,fin_slot_width, fin_slot_height, launch_lug_type);

        
        for (a=[0:360/3:360]) {
            translate([0,0,fin_height+20])
            rotate([0,90,a+15])
            translate([0,0,rocket_id])
            fin(fin_height, fin_slot_width, fin_slot_height);
        }
    }

    translate([0,0,0])
    retainer_nut(retainer_male_od*1.2,retainer_male_od+0.5, motor_overhang+0.6*motor_tube_id, pitch);

}

module arrange(dx=40, dy=30) 
{
     for ( i=[0:1:$children-1])  { 
        x = (i%5)*dx;
        y = dy * ceil((i+1) / 5); 
        translate([-100+x,-100+y,0]) {children(i);}
    }
}

if (part == "all")
    exploded_view();
else 
    arrange(dx=rocket_id*1.3, dy=rocket_id*2)
    {
        
        if (part=="engine_mount") 
            fin_motor_mount(rocket_od, rocket_id, motor_tube_od, motor_tube_id, motor_height, motor_tube_height,  fin_height,fin_slot_width, fin_slot_height, launch_lug_type);

        if (part=="parachute")
            parachute_compartment(parachute_compartment_height, rocket_id); 

        if (part=="extension")
            extension_tube(parachute_compartment_height, rocket_id, motor_tube_id); 
        
        if (part=="instrument") {
            instrument_compartment(instrument_compartment_height, rocket_id, vent_hole_od);
        }


        //if (part=="retainer" ||  part=="all")
        //    module_retainer_male(retainer_male_base_h, retainer_male_base_od, pitch,//            retainer_male_od, windings, motor_od/2.0, motor_tube_id/2.0);
        
        if (part=="retainer")
            retainer_nut(retainer_male_od*1.2,retainer_male_od+0.5, motor_overhang+0.6*motor_tube_id, pitch);

        
        if (part=="nose")
            rocket_nose(h=nose_tube_height, body_id=rocket_id);
        
        //if (part=="coupler" ||  part=="all")
        //    coupler_eject(rocket_id);

        if (part=="coupler")
            mcoupler(rocket_id-0.5,rocket_id);

        if (part=="coupler")  // for instrument compartment
            m2coupler_closed(rocket_id-0.5,rocket_id);

        if (part=="coupler")
            male_coupler_with_motor_tube_lock(rocket_id-0.5, motor_tube_id,rocket_id);

        if (part=="piston")
            piston(rocket_id);
       

        if (part=="fin")
            fin(fin_height, fin_slot_width, fin_slot_height);
       
    }




