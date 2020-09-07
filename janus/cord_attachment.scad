use <autofn.scad>

module cord_attachment(rocket_od, body_id, motor_tube_id) {
   // cord attachment
    holder_height = body_id * 0.5;

    difference() {
        // fill the space 
        cylinder(holder_height,body_id/2.,body_id/2., $fn=fn(rocket_od));
        
        // hole for motor tube
        color("cyan")
        cylinder(holder_height+1,motor_tube_id/2., motor_tube_id/2., $fn=fn(rocket_od)); // @ +.15
        
        // taper bottom
        translate([0,0,-0.01])
            cylinder(holder_height*.55,body_id/2.,motor_tube_id/2., $fn=fn(rocket_od));

        // taper top
        translate([0,0,holder_height*.75])
            cylinder(holder_height*.25+0.01,motor_tube_id/2., body_id/2., $fn=fn(rocket_od));

        
        // holes for cord
        hole_id = body_id >= 30 ? body_id >= 80 ? 2.5 : 1.6 : 0.8;
        hole_offset = hole_id * 2 + 0.01*body_id;
        translate([body_id/2-hole_offset, 0,-0.01])
            cylinder(100,hole_id,hole_id);
        translate([-body_id/2+hole_offset, 0,-0.01])
            cylinder(100,hole_id,hole_id);
        translate([0, body_id/2-hole_offset,-0.01])
            cylinder(100,hole_id,hole_id);
        translate([0, -body_id/2+hole_offset,-0.01])
            cylinder(100,hole_id,hole_id);

        
    } 
}


cord_attachment(100,90, 50);