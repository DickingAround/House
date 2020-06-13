foot = 12;

ext_x = 40*foot;
ext_y = 40*foot;
ext_z_high = (24+4)*foot;
ext_z_low = 24*foot;

vert_beams_width = 3;
vert_beams_wall = 0.25;

module squareTube(length,outer,wall)
{
 difference()
 {
  cube([outer,outer,length],center=true);
  cube([outer-wall*2,outer-wall*2,length+1],center=true);
 }
}

module verticalPosts(length_z,location_x)
{
 translate([location_x,ext_y,length_z/2.0])
 squareTube(length_z,vert_beams_width,vert_beams_wall);
 translate([location_x,-ext_y,length_z/2.0])
 squareTube(length_z,vert_beams_width,vert_beams_wall);
 translate([location_x,0,length_z/2.0])
 squareTube(length_z,vert_beams_width,vert_beams_wall);
}

module weightBearingRibs()
{
 verticalPosts(ext_z_low,ext_x);
 verticalPosts(ext_z_low,-ext_x);
 verticalPosts(ext_z_high,0);
}

weightBearingRibs();
