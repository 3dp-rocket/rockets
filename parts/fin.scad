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

// 
// More about fins:
//  https://www.nakka-rocketry.net/fins.html 

module fin_delta_clipped(h, base_width) {
    
    t= base_width/h;
    
    hull() {
        
        linear_extrude(100*t)
            translate([h/2,0, 0])
               scale([1, t]) circle(r=h/2);
        
        translate([0,0, h*0.98])
        linear_extrude(10*t)
            translate([h*.75,0, 33])
               scale([1, t]) circle(r=h/4);
        
        translate([h/2, 0, h])
            rotate([0,90,0])
                cylinder(h/2, 2*t, 2*t);
        
    }
    
}


module fin_ellipsoid(a, b, base_width) {
    
    //hull() 
    {
        m = b/log(b);
        for (i=[1:b/40.:b]) {
            z = m*log(i);
            echo(z);
            x1 = a-sqrt(1-(z*z)/(b*b)) * a;
            x2 = a+sqrt(1-(z*z)/(b*b)) * a;
            x = x2-x1;

            translate([x1+x/2+a,0, z]) {
                if (x>0)
                    linear_extrude(.1)
                        scale([x,log(b-z+1.001)/log(b)]) circle(r=1, $fn=100);
                    
            }
        
        }
    }
    
}

translate([100,0,0])
    fin_delta_clipped(h=100, base_width=5, $fn=100);

translate([0,0,0])
    fin_ellipsoid(25,100,5);

