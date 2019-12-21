// designed to dissipate some of the energy that acts on the cord and rocket 
// when the parachute deploys or ejection charge deploys at high speed
// Useage:
// Mount the brake over the long concial rod.
// Thread a small cord through the top hole of the rod and another trhough the brake.
// Tie the top cord to a loop on the shock cord.
// Tie the bottom cord to a another loop on the shock cord.
// enusre the distance between loops is slighlty longer than the rod. 
// If the pole brakes apart, the main shock cord should work as normally does.

$fn=100;

h=100;
d1 = 20;
d2 = 10;

hook1 = 3;

difference() {
    cylinder(h,d1=d1,d2=d2);

    translate([0,0,h-10])
    rotate([0,90,90])
    cylinder(200,d=hook1, center=true);
}

    
translate([100,10,0])
difference() {
    bh = 20;
    cylinder(bh,d=2*d1);
    translate([0,0,-.5])

    cylinder(bh+1,d1=d1+(bh+1)*(d1-d2)/100, d2=d1);
    translate([d1/2,0,0])
    cube([20,0.5,3*bh], center=true);
    
    
    translate([0,d1/2+4,0])
    cylinder(3*bh+1,d=hook1, center=true);

    translate([0,-d1/2-4,0])
    cylinder(3*bh+1,d=hook1, center=true);


}


