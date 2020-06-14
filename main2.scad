foot = 12;

ext_x = 40*foot;
ext_y = 40*foot;
ext_z_high = (24+4)*foot;
ext_z_low = 24*foot;

vert_beams_width = 3;
vert_beams_wall = 0.25;

sf_z = 11*foot; //second floor

module squareTube(length,outer,wall)
{
 difference()
 {
  cube([outer,outer,length],center=true);
  cube([outer-wall*2,outer-wall*2,length+1],center=true);
 }
}

module heavyBeam(length)
{
 rotate([90,0,0])
 squareTube(length,3,0.25);
 translate([0,0,-foot])
 rotate([90,0,0])
 squareTube(length,3,0.25);

}

module verticalPosts(length_z,location_x)
{
 translate([location_x,ext_y/2,length_z/2.0])
 squareTube(length_z,vert_beams_width,vert_beams_wall);
 translate([location_x,-ext_y/2,length_z/2.0])
 squareTube(length_z,vert_beams_width,vert_beams_wall);
 translate([location_x,0,length_z/2.0])
 squareTube(length_z,vert_beams_width,vert_beams_wall);
}

module weightBearingRibs()
{
 // VeritcalRibs
 verticalPosts(ext_z_low,ext_x/2);
 verticalPosts(ext_z_low,-ext_x/2);
 verticalPosts(ext_z_high,0);
 // Horizontal heavies
 translate([0,ext_y/4,sf_z])
 heavyBeam(ext_y/2);
 translate([0,-ext_y/4,sf_z])
 heavyBeam(ext_y/2);
 translate([ext_x/2,ext_y/4,sf_z])
 heavyBeam(ext_y/2);
 translate([ext_x/2,-ext_y/4,sf_z])
 heavyBeam(ext_y/2);
 translate([-ext_x/2,ext_y/4,sf_z])
 heavyBeam(ext_y/2);
 translate([-ext_x/2,-ext_y/4,sf_z])
 heavyBeam(ext_y/2);

}

weightBearingRibs();
