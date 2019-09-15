$fn=100;

difference() {
    union() {
        difference() {
            cylinder(100, 20,5);
            translate([0,0,-1]) 
               cylinder(110, 15,5);
        }

        translate([0,0,90])
           sphere(10);
    }
    
    //cube([100,100,100]);
}

