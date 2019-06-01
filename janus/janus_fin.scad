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


use <../parts/fin.scad>

// Renders a fin and the fin support that fits into the motor tube slot
module fin(h, fin_slot_width, fin_slot_height) {
    
    translate([0,0,fin_slot_height*0.99])
        fin_delta_clipped(h, fin_slot_width);
    
    key_h = 0.04 * h;
    color("blue", 0.5) 
        difference() {
            translate([-key_h, 0, 0])
                rotate([90,0,90])
                    linear_extrude(h+2*key_h)
                        polygon(polygon_slot(fin_slot_height, fin_slot_width));
                
                translate([-key_h/2, 0, fin_slot_height])
                    cube([key_h+0.001,fin_slot_width,fin_slot_height], center=true);

                translate([h+key_h/2, 0, fin_slot_height])
                    #cube([key_h+.001,fin_slot_width,4+fin_slot_height], center=true);

            }

    
}

function polygon_slot(fin_slot_height,fin_slot_width) = 
[[-fin_slot_width/2.,0],[-fin_slot_width/3.,fin_slot_height],[fin_slot_width/3.,fin_slot_height],[fin_slot_width/2.,0] ];

fin(100, 5, 4, $fn=100);