$fn=100;

od = 18.8;
r = od/2.0;

difference() 
{
    cylinder(20,r,r);
    translate([0,0,-.1])
        cylinder(21,r-2.,r-2.);
    
    translate([0,0,5])
        rotate_extrude()
        translate([r, 0, 0])
        circle(r = 0.6);
    
    translate([0,0,10])
        rotate_extrude()
        translate([r, 0, 0])
        circle(r = 0.6);

    translate([0,0,15])
        rotate_extrude()
        translate([r, 0, 0])
        circle(r = 0.6);

    translate([0, 0, -1])
        cube([20,1,25]);

}

