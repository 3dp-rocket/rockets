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

/*
    Altimeter holder
    Keeps the jolly logic altimeter in vertical position centered 
    inside the instrument bay.
*/



// diameter of instrument bay
bay_id = 54.2;

// altimeter dimensions  14.5 x 18 x 49
altimeter_w = 15;
altimeter_d = 18.5;
altimeter_h = 55;

// wall thickness
wall = 2;


translate([0,0,altimeter_h/2])
{
    // draw the box that holds the altimeter
    difference() {
        cube([altimeter_w+wall, altimeter_d+wall, altimeter_h], center=true);
        cube([altimeter_w, altimeter_d, altimeter_h+1], center=true);
    }

    // draw arms that reach to the outer edge of the bay
    difference() {
        union () {
            cube([bay_id, wall ,altimeter_h], center=true);
            cube([wall, bay_id, altimeter_h], center=true);
        }
        cube([altimeter_w, altimeter_d, altimeter_h+1], center=true);
        
        // make slits
        for(x=[altimeter_w:2*wall:bay_id/2]) {
            translate([x-wall,0,0])
            cube([wall, wall+1, altimeter_h-4*wall], center=true);
            translate([-x+wall,0,0])
            cube([wall, wall+1, altimeter_h-4*wall], center=true);
        }

        // make slits
        for(x=[altimeter_d:2*wall:bay_id/2]) {
            translate([0,x-wall, 0])
            cube([wall+1, wall, altimeter_h-4*wall], center=true);
            translate([0,-x+wall, 0])
            #cube([wall+1, wall, altimeter_h-4*wall], center=true);
        }
    }

}

bigredbee_id = 22;
bigredbee_h = 40;
shoulder_h = 10;

translate([100,0, shoulder_h/2])
{
    color("blue")
    difference() {
        cube([altimeter_w, altimeter_d, 10], center=true);
        cube([altimeter_w-wall, altimeter_d-wall, 10+1], center=true);
    }
}

translate([100,0,shoulder_h+bigredbee_h/2])
{
    color("red")
    difference() {
        cube([bigredbee_id+wall, bigredbee_id+wall, bigredbee_h], center=true);
        translate([0,0,1])
        cube([bigredbee_id, bigredbee_id, bigredbee_h+1], center=true);
    }
}




