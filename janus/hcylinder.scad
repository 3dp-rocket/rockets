use <autofn.scad>

module hcylinder(h,D,d)
{
    difference()
    {
        cylinder(h, D, D, $fn=fn(2*D));
        translate([0,0,-.05])
        cylinder(h+0.1, d, d, $fn=fn(2*d));
    }
}