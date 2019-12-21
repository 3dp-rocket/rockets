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


use <../parts/fin.scad>

// Renders a fin and the fin support that fits into the motor tube slot
module fin(semi_span, root_chord, fin_slot_width, fin_slot_height, b=0, fin_type=0, brim_size=0) {
    
    difference() 
    {
        fin_shell(semi_span, root_chord, fin_slot_width, fin_slot_height, b, fin_type, brim_size);
    }
    if (brim_size>0)  // required to avoid warping
    {
        // modified from: 
        // https://github.com/slic3r/Slic3r/issues/641#issuecomment-100101745
        linear_extrude (height = 1)
        offset (r = brim_size)
        projection (cut = true)
        fin(semi_span, root_chord, fin_slot_width, fin_slot_height, b=0, fin_type=0, brim_size=0);
    }
    
}

module fin_shell(semi_span, root_chord, fin_slot_width, fin_slot_height, b=0, fin_type=0, brim_size=false) {



    translate([0,0,fin_slot_height*0.99]) {
        if (fin_type==0)
            fin_delta_clipped(semi_span, root_chord, fin_slot_width, b);
        if (fin_type==1)
            fin_ellipsoid(root_chord=root_chord, 
        semi_span=semi_span, base_width=fin_slot_width,fn_x=100);//2.0*fin_slot_width/3.
    }
    
    key_h = 0.04 * root_chord;
    color("blue", 0.5) 
        difference() {
            translate([-key_h, 0, 0])
                rotate([90,0,90])
                    fin_support(root_chord+1.*key_h, fin_slot_height, fin_slot_width);
                
                translate([-key_h/2, 0, fin_slot_height])
                    cube([key_h+0.001,fin_slot_width,fin_slot_height], center=true);
            
     }

     


}


module fin_support(length, fin_slot_height, fin_slot_width)
{
    linear_extrude(length)
        polygon(polygon_slot(fin_slot_height, fin_slot_width));
}

function polygon_slot(fin_slot_height,fin_slot_width) = 
[[-fin_slot_width/2.,0],[-fin_slot_width/3.,fin_slot_height],[fin_slot_width/3.,fin_slot_height],[fin_slot_width/2.,0] ];

/*
module fin_ex(semi_span, root_chord, fin_slot_width, fin_slot_height, b=0, fin_type=0) {
    
    translate([0,0,fin_slot_height*0.99]) {
        if (fin_type==0)
            fin_delta_clipped(semi_span, root_chord, fin_slot_width, b);
        if (fin_type==1)
            fin_ellipsoid(root_chord=root_chord, 
        semi_span=semi_span, base_width=2.0*fin_slot_width/3.);
    }
    key_h = 0.04 * root_chord;
    warp_fix = 2.0;
    color("blue", 0.5) 
        difference() {
            translate([-key_h, 0, 0])
                rotate([90,0,90])
                    fin_support(root_chord+1.*key_h, fin_slot_height, fin_slot_width, warp_fix);
                
                translate([-key_h/2, 0, fin_slot_height])
                    cube([key_h+0.001,fin_slot_width,fin_slot_height], center=true);
            
            }
   // custom support
   translate([-5,0,0]) {
       difference() {         
            cylinder(3, 10,10);
            translate([0,-10,-0.1])
            cube([10,20,10]);
       }
       translate([0,0,.5])
        cube([3,15,1], center=true);
   }
   // custom support
   
   translate([root_chord+1,0,0]) {
       rotate([0,0,180])
       difference() {         
            cylinder(3, 10,10);
            translate([0,-10,-0.1])
            cube([10,20,10]);
       }
       translate([0,0,.5])
        cube([3,15,1], center=true);
   }


    
}

*/


difference() {
    
        fin(60, 60, 5, 4, b=0, fin_type=0, brim_size=5, $fn=100);
    //cube([64, 30,30], center=true);
    
}
/*
module fin_support_ex(length, fin_slot_height, fin_slot_width, warp_fix=0)
{
    segments = 40;
    segment_length = length/segments;
    for(x=[0:segment_length:length]) {
        yt = warp_fix*sin(180*x/(length+1));
        y = yt < 0.4 ? 0 : yt;
        //echo(y);
        translate([0,y,x])
        if (x <= length-segment_length)
        linear_extrude(segment_length+0.01)
            polygon( polygon_slot(fin_slot_height,fin_slot_width));
    }
}
*/
