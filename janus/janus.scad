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
D38 = 7;

// Paper tube liner thickness
BLUE_TUBE_THICKNESS = 1.6;   // https://alwaysreadyrocketry.com/?product=1-15-29mm-x-062-wall-x-48-airframe-mmt
STD_TUB_THICKNESS = 0.4;

// fin types
FIN_CLIPPED_DELTA=0;
FIN_ELLIPSOID=1;

//*********************************************
// Set these variables.
model = D38;  // a,A,B,C....F
add_thrust_stopper = model < F ? true : false;
paper_tube_wall_thickness = BLUE_TUBE_THICKNESS; //STD_TUB_THICKNESS,BLUE_TUBE_THICKNESS
motor_ring_height = 10.; // height of ring around composite motor (0 for estes, 10 aerotech)
fin_type = FIN_CLIPPED_DELTA; // FIN_CLIPPED_DELTA or FIN_ELLIPSOID
//*********************************************

MOTOR_OD = 0;
MOTOR_LENGTH = 1;

rocket_parameters = [
    [ 13.3, 44.2],  // a*
    [ 13.3, 70.00],  // A
    [ 13.3, 70.00],  // B
    [ 18.0, 70.00],  // C*
    [ 24.0, 100.00],  // D**
    [ 29.0, 114.00],  // E
    [ 29.0, 114.00],  // F
    [ 38.37, 135,00] // 38mm  38+0.37 because that's the blue tube inner diameter!
    

];

printer_max_height = 200.0;

p = rocket_parameters[model];

motor_od = p[MOTOR_OD]; // * (1 + 0.15); // + tube
motor_height = p[MOTOR_LENGTH];
motor_tube_height = min(2.0 * motor_height ,printer_max_height);

motor_tube_id = motor_od + 2.0*paper_tube_wall_thickness;
motor_tube_od = motor_tube_id * 1.1;

rocket_id = 1.5675 * motor_tube_id; //1.5038
rocket_od = rocket_id + 2*0.05*rocket_id;

// fin and fin slot dimensions
fin_height = 2.0 * rocket_id;
fin_length = fin_height;
fin_slot_width=0.25 * motor_tube_id;
fin_slot_height = (rocket_od-motor_tube_od)/2;

body_height = min(7.5188 * motor_od ,printer_max_height);

nose_tube_height = min(6 * motor_od, printer_max_height);
// add extra length to trimed from body_height exceedeing printer_max_height
instrument_compartment_height = rocket_id * 1.4; //70

//http://www.perfectflite.com/Downloads/StratoLoggerCF%20manual.pdf
vent_hole_od = instrument_compartment_height * rocket_id* .00037;

parachute_compartment_height = min(100 + 3*motor_od + (7.5188 * motor_od-body_height), printer_max_height);

extension_tube_height = parachute_compartment_height; 

shoulder_height= (model==D38)? 30 : 0;

pitch = 2.0; 

retainer_male_od = (rocket_id + motor_tube_od) /2.0; // see motor_mount.scad
motor_retainer_height = motor_ring_height + (add_thrust_stopper?2:0.6*motor_tube_id);


LUG_ROD_1_8 = 1;
LUG_ROD_3_16 = 2;
LUG_RAIL_8010 =3;

launch_lug_type = motor_od < 14 ? LUG_ROD_1_8 : motor_od < 25 ? LUG_ROD_3_16 : LUG_RAIL_8010;

echo("part:", part);
echo("rocket OD:", rocket_od);
echo("rocket ID:", rocket_id);

echo("motor tube OD:", motor_tube_od);
echo("motor tube ID:", motor_tube_id);
echo("motor tube height:", motor_tube_height);

echo("motor od    :", motor_od);
echo("motor height:", motor_height);

echo("body height      :", body_height);

echo("fin height       :", fin_height);
echo("fin length       :", fin_length);
echo("fin slot width   :", fin_slot_width);
echo("fin slot height  :", fin_slot_height);


echo("parachute_compartment_height:", parachute_compartment_height);
echo("instrument_compartment_height:", instrument_compartment_height);

echo("nose cone total height", nose_tube_height);
echo("nose cone height", nose_tube_height * 2/3);
echo("nose base", nose_tube_height * 1/3);


// define heigth of each layer
coupler_height = rocket_od * 0.8; 

layers = [30,motor_tube_height,coupler_height,200,coupler_height,parachute_compartment_height, coupler_height*1.5, instrument_compartment_height, coupler_height, 300];

// return sum of array elements from i to n
// a[1,2,3] 
// sum(a,0,2) ==> 3   (1+2)
function sum(a, i, n) = 
    i<n ? a[i] + sum(a,i+1,n) : 0;


module arrange() 
{
     for ( i=[0:1:$children-1])  { 
        translate([0,0, 10*i + sum(layers,0,i) ]) {children(i);}
    }
}

/*
Arrange() creates an exploded view of all parts. It uses layers[] to calculate the height of each layer.
The variable 'part' can be specified to build (create STL's) for only a specific set of parts. See batch.sh for examples. 

*/
//difference() {
arrange()
    {

        if (part=="retainer" || part=="all") {
            // 0.6 * motor_tube_id currenlty hardcode in motor mount
            //translate([0,0,26.7])
            retainer_nut(rocket_od,retainer_male_od+0.5, motor_retainer_height, pitch=pitch);  
        }


        if (part=="motor_mount" || part=="all" || part == "fin") {
            if (part=="motor_mount" || part=="all")
                rotate([0,part=="motor_mount" ? 180 : 0,0]) // roatate for proper print orientation
            fin_motor_mount(rocket_od, rocket_id, motor_tube_od, motor_tube_id, motor_height, motor_tube_height,  fin_length,fin_slot_width, fin_slot_height, launch_lug_type, add_thrust_stopper);


            if (part=="fin"|| part=="all") {
                // when part is set to 'fin' as in batch.sh the fin is printed
                // on the right orientation for printing
                
                for (a=[0:360/3:part=="all"?360:0]) {
                    translate([0,0,fin_length+20])
                    rotate([0,part == "all" ? 90 : 0,a+15])
                    translate([0,0,rocket_id])
                    fin(fin_height, fin_length, fin_slot_width, fin_slot_height, fin_height*0.1, fin_type=fin_type);
                }
        }
    }

    if (part=="coupler1" || part == "all")
            //male_coupler_threaded(rocket_id-1.0, coupler_height);
            male_coupler_with_hook(rocket_id-1.0, coupler_height);
            //male_coupler_with_motor_tube_lock(rocket_id-1., motor_tube_id, coupler_height);

    if (part=="extension" || part=="all")
        extension_tube(parachute_compartment_height, rocket_id, motor_tube_id); 

    if (part=="coupler2" || part == "all")
        male_coupler_threaded(rocket_id-1.0, coupler_height);

    if (part=="parachute" || part=="all" || part == "piston" || part=="parachute_extension" || part == "parachute_middle_extension") {
        if (part=="parachute" || part == "all") {
            parachute_compartment(total_height=parachute_compartment_height, body_id =rocket_id, shoulder_height=shoulder_height);
        }
        if ((part=="parachute_extension" || part == "all") && shoulder_height>0) {    
            translate([rocket_id,-rocket_id,0])
            parachute_compartment_extension(total_height=parachute_compartment_height, body_id =rocket_id, shoulder_height=shoulder_height);
        }
        if ((part=="parachute_middle_extension" || part == "all") && shoulder_height>0) {    
            translate([-rocket_id,+rocket_id,0])
            parachute_compartment_middle_extension(total_height=parachute_compartment_height, body_id =rocket_id, shoulder_height=shoulder_height);
        }
        
        if (part=="piston" || part == "all")
            translate([rocket_id,rocket_id,0]) {
                piston_with_screw(rocket_id);
                translate([2*rocket_id,rocket_id,0])
                thread_lock_screw(rocket_id);
            }
    }

    if (part=="coupler3" || part == "all")
        male_coupler_with_shock_cord_attachment(od_threaded=rocket_id-1.0, od_smooth=rocket_id, thread_height=coupler_height/2.0, shoulder_heigth=rocket_id/2.0);

    if (part=="instrument" || part=="all") {
            instrument_compartment(instrument_compartment_height, rocket_id, vent_hole_od);
     }

    if (part=="coupler4" || part == "all")
        male_coupler_threaded(rocket_id-1.0, coupler_height);
 
       if (part=="nose" || part == "all")
           rocket_nose(h=nose_tube_height, body_id=rocket_id);
        
       
    }

    
    if (part=="male_coupler_with_test_charge")
        male_coupler_with_test_charge(rocket_id-1.0, coupler_height);
    

//    translate([0,0,27])
//    cube([40,40,27]);
//}
