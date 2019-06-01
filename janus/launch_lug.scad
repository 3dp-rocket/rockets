$fn=100;
// launch lug for 8010 and 20 rails
//
// https://8020.net/1010.html

LUG_ROD_1_8 = 1;
LUG_ROD_3_16 = 2;
LUG_RAIL_8010 =3;

module rail_launch_lug(lug_length=10)
{
    inch_to_mm = 25.4;
    fit = 0.70; // 1==tight fit <1 loose fit
    fit2 = 0.95;
    lug_stem_width = 0.256 * inch_to_mm*fit2;
    lug_stem_height = (0.087)  * inch_to_mm + 2;
    
    lug_top_width = 0.256 * inch_to_mm * fit;
    lug_base_width = 0.584 * inch_to_mm * fit;
    lug_height = (0.5 - .087-.356/2) * inch_to_mm * fit;
    lug_x1 = (lug_base_width - lug_top_width)/2;
    lug_x2 = (lug_base_width - lug_x1);

    //echo("lug_top_width  :", lug_top_width);
    //echo("lug_base_width :", lug_base_width);
    //echo("lug_height     :", lug_height);
    //echo("lug_stem_width :", lug_stem_width);
    //echo("lug_stem_height:", lug_stem_height);
    
    
    r = 0.5;

    difference()
    {
        translate([-lug_base_width/2,0,0])
        {
            // hull around 4 cylinders of radius r
            hull() {
                
            translate([r,r,0]) 
                cylinder(lug_length,r,r);

            translate([lug_x1, lug_height-1*r,0]) 
                cylinder(lug_length,r,r);

            translate([lug_x2,lug_height-1*r,0]) 
                cylinder(lug_length,r,r);

            translate([lug_base_width-r,r,0]) 
                cylinder(lug_length,r,r);

            };

            translate([lug_base_width/2,-lug_stem_height/2,lug_length/2]) 
                cube([lug_stem_width,lug_stem_height,lug_length],center=true);

        }
    
        // slanted bottom
        rotate([-55,0,0])
        cube([20,10,30], center=true);

        // slanted top
        translate([0,0,lug_length])
        rotate([55,0,0])
        cube([20,10,40], center=true);
        
        // hollowed core?
        translate([0,2.5,0])
        cylinder(lug_length+1,1.1,1.1);
        

    }
    

}

module lug(lug_od, lug_id, lug_height, block_width)
{
    difference() {
        hull() {
            difference() {
                union() {
                    cylinder(lug_height/2, lug_od/2, lug_od/2);
                    translate([-lug_od/2-block_width/2,0,lug_height/4])
                        cube([block_width,block_width,lug_height],center=true);
                }
                // slanted bottom
                //rotate([0,-55,0])
                //translate([+lug_od/2-block_width/2,0,lug_od/2-4])
                //cube([20,10,10], center=true);
                
                // slanted top
                //rotate([0,25,0])
                //translate([-10,0,lug_height+1])
                //cube([20,10,10], center=true);

            }
        }
        translate([0,0,-lug_height/2])
        cylinder(lug_height*2, lug_id/2, lug_id/2);
        

        
    }
}


module rail_launch_lug_glue(od, lug_length=10)
{
    rocket_r = od/2;
    support_r = rocket_r*0.6;
    sh = 3;

    translate([0,6.6,0])
    rotate([0,0,90])
    translate([-rocket_r-rocket_r/1.8,0,0])
    difference() {
        translate([rocket_r/2.3,0,0])
        cylinder(lug_length, support_r, support_r);

        // rocket body diameter
        translate([0,0,-.1])
        cylinder(lug_length+1, rocket_r, rocket_r);
    }

    rail_launch_lug(od);
}


rail_launch_lug(39);



