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

use <couplers.scad>
use <hcylinder.scad>
use <autofn.scad>

module retainer_nut(od,id, height, pitch=2, starts=1) {
    union() {
           base_height = max(4, od/16); // revise
           translate([0,0,base_height]) {
               hcylinder(height, od/2, id/2);
               female_coupler(id, height, pitch, starts);
           }
        
           difference() {
               cylinder(base_height, od/2.,od/2., $fn=fn(od)); //base
               translate([0,0,-.1])
               cylinder(base_height+1.0, id*.3, id*.3, $fn=fn(id*.3)); // hole in base
           }

    }
   
}

retainer_nut(50, 40, 20, 2.0);