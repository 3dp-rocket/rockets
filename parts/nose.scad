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

// This file defines modules used to create rocket nose cones following the 
// design guidleines described in this wikipedia article:
// https://en.wikipedia.org/wiki/Nose_cone_design
//
// Two types of cones implemented are: Haack Series and Power Series.
// These should cover most common low power and high power rocket designs. 

//  Examples:
//    use <nose_cone.scad>
//    nose_cone_haack(l=80, r=20, c=1/3, wall_thickness=2);
//    
//    nose_cone_power(l=80, r=20, n=.6, wall_thickness=1);
//
//  You will have to extend the nose with a tube/coupler/shoulder to connect it with 
//  the rocket body. See janus.scad for examples.
//  
// More about nose cones:
// https://en.wikipedia.org/wiki/Nose_cone_design

function toDeg(rad)=
    rad/PI*180;

function haack_series(x, l, r, c)=
    // calc tetha and convert to radians
    let(tetha = acos(1-2*x/l))
    let (tethaR = tetha/180*PI)
    (r/sqrt(PI))*sqrt(tethaR-sin(2*tetha)/2+c*pow(sin(tetha),3));
     

// uses Haack Series to draw the nose cone
// l = length, r=radius and c typical values are 1/3, 0 or 2/3
// See article:
// https://en.wikipedia.org/wiki/Nose_cone_design
module nose_cone_haack(l, r, c=0, wall_thickness=1)
{
    // create points for the outer curve of the nose cone
    step = l/100;
    V0 = [for (x=[0.0:step:l])  [haack_series(x, l, r, c),x ]];
        
    // create points for the inner curve so the cone is hollow
    V1 = [for (x=[l:-step:0.00])  [x< wall_thickness ? 0 : max(haack_series(x, l, r, c)-wall_thickness,0),x ]];

    // adding ep ensures we have a perfect flat/height cone
    ep = [[r, l], [r-wall_thickness, l]];
    V2 = concat(concat(V0, ep), V1);
    

    translate([0,0,l])
    rotate([0,180,0])
    rotate_extrude($fn = 100) 
      polygon(V2);
    
}

function power_series(x, l, r, n)=
    let(xl = pow(x/l, n))
    r*pow(x/l,n);

module nose_cone_power(l, r, n=0.6, wall_thickness=1)
{
    // create points for the outer side of the polygon of the nose cone
    step = l/100;
    V0 = [for (x=[0.0:step:l])  [power_series(x, l, r, n),x ]];
        
    // create points for the inner curve so the cone is hollow
    V1 = [for (x=[l:-step:0.0])  [x<wall_thickness ? 0 : max(power_series(x, l, r, n)-wall_thickness,0),x ]];
        
    ep = [[r, l], [r-wall_thickness, l]];
    V2 = concat(concat(V0, ep),V1);
    
    translate([0,0,l])
    rotate([0,180,0])
    rotate_extrude($fn = 100) 
        polygon(V2);
        
}


// This nose cone has a smoother/continuos transition to the rocket body
module nose_cone_eliptical(od, id, h=4)
{
    V0 = [for (a=[0:1:90])  [cos(a), h*sin(a)]];
    V1 = [for(i=[len(V0)-1:-1:0]) V0[i] ];
    // create inside perimeter and outside perimeter series
    V2 = concat(od*V0, id*V1);

    rotate_extrude($fn = 100) {
        polygon(V2);
    }
    
}



/*
 * Examples 
 */

/*
Try with c=1/3 or 2/3 - This cone should work for most cases
See janus.scad for more examples
*/
translate([-50,0,0]) {
    translate([0,0,10])
        !nose_cone_haack(l=100, r=20, c=1/3, wall_thickness=1, $fn=100);
    color("red", 0.6) difference() {
        cylinder(10,20,20, $fn=100);
        translate([0,0,-1])
        cylinder(12,19,19, $fn=100);
    }
}

translate([50,0,0]) 
    nose_cone_power(l=100, r=20, n=.6, wall_thickness=1, $fn=100);


translate([50,50,0]) 
    nose_cone_eliptical(od=20, id=18, h=5, $fn=100);



