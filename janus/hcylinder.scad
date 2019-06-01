module hcylinder(h,D,d)
{
    difference()
    {
        cylinder(h, D, D);
        translate([0,0,-.05])
        cylinder(h+0.1, d, d);
    }
}