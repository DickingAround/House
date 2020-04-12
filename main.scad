main_x = 80;
main_z =  10;
main_roofPitch = 1.5; //How many lengths of run per one of climb
main_roofPanelLength = 15;
main_roofAngle = atan(1/main_roofPitch);
main_y = main_roofPanelLength*cos(main_roofAngle)*2;
//main_lower_z
main_upper_z = main_roofPanelLength*sin(main_roofAngle);
main_structure_slice_x = 4; //Distance between slices
main_lilBedRoom_x=10;
main_lilBedRoom_y=12;
main_bigBedRoom_x=15;
main_bigBedRoom_y=15;
main_bathRoom_x=8;
main_bathRoom_y=main_bigBedRoom_y;
garage_x = 20;
garage_y = 30;
garage_z = 10;
garage_overlap_x = 8;
pool_x = 20;
pool_y = 20;
pool_z = 10;
pool_overlap_x = 8;


//Printing specs:
echo("Roof Angle =",main_roofAngle);
echo("Roof Height =",main_upper_z);
echo("Building width =",main_y);
//----------------
//-- Primatives --
//----------------
module room(x,y,z,c)
{
color(c)
difference()
{
cube([x,y,z],center=true);
translate([0,0,1])
cube([x-1,y-1,z],center=true);
}    
}

module angleSteel(thickness,width,length)
{
    cube([thickness,width,length]);
    cube([width,thickness,length]);
}

module tubeSteel(thickness,width,length)
{
    translate([0,0,length/2.0])
    difference()
    {
        cube([width,width,length],center=true);
        cube([width-thickness*2,width-thickness*2,length+1],center=true);
    }
}
module angleSteelTruss(angleThick,angleWidth,rodR,space_z,length)
{
    rotate([90,0,0])
    translate([0,0,-length/2.0])
    angleSteel(angleThick,angleWidth,length);
    translate([0,0,-space_z])
    rotate([90,0,0])
    translate([0,0,-length/2.0])
    angleSteel(angleThick,angleWidth,length);
}

//-------------------
//-- Main building --
//-------------------
// Structure
//http://personales.upv.es/~jmasia/Libro_ANSYS/2_EV-04-en.html
//https://www.mathalino.com/reviewer/engineering-mechanics/problem-mj-01-method-joints
//https://valdivia.staff.jade-hs.de/fachwerk_en.html

//angleSteel(10,30,50);
module main_structure_slice()
{
    beam_w = 3*1/12;
    beam_t = 1/12*1/8;
    translate([0,main_y/2.0,0])
    tubeSteel(beam_t,beam_w,main_z);
    translate([0,-main_y/2.0,0])
    tubeSteel(beam_t,beam_w,main_z);
    
    //angleSteelTruss(beam_t,beam_w,3/8*1/12*1/5,8*1/12,main_y);
    //truss horizontal
    translate([0,0,main_z])
    rotate([90,0,0])
    translate([0,0,-main_y/2.0])
    tubeSteel(beam_t,beam_w,main_y);
    
    //Truss verticals
    translate([0,main_y/4,main_z])
    tubeSteel(beam_t,beam_w,main_upper_z/2.0);
    translate([0,-main_y/4,main_z])
    tubeSteel(beam_t,beam_w,main_upper_z/2.0);
    
    //Truss angles
    trussCrossAngle = 90-atan(main_upper_z/(main_y/4));
    trussCrossLen = sqrt(main_upper_z*main_upper_z+(main_y/4)*(main_y/4));
    translate([0,main_y/4,main_z])
    rotate([trussCrossAngle,0,0])
    tubeSteel(beam_t,beam_w,trussCrossLen);
    translate([0,-main_y/4,main_z])
    rotate([-trussCrossAngle,0,0])
    tubeSteel(beam_t,beam_w,trussCrossLen);
    
    //Roof supports
    translate([0,-main_y/4,main_z+main_upper_z/2])
    rotate([main_roofAngle,0,0])
    translate([0,main_roofPanelLength/2.0])
    rotate([90,0,0])
    tubeSteel(beam_t,beam_w,main_roofPanelLength);
    
    translate([0,main_y/4,main_z+main_upper_z/2])
    rotate([-main_roofAngle,0,0])
    translate([0,-main_roofPanelLength/2.0])
    rotate([-90,0,0])
    tubeSteel(beam_t,beam_w,main_roofPanelLength);

    //cube([main_x,main_roofPanelLength,1],center=true);
}

module main_structure()
{
    for ( i = [-main_x/2 : main_structure_slice_x : main_x/2.0] )
    {
        translate([i,0,-main_z/2])
        main_structure_slice();
    }
}

//Roof
module main_roof()
{
    //Main building
    color("purple")
    {
        translate([0,-main_y/4,main_z/2+main_upper_z/2])
        rotate([main_roofAngle,0,0])
        cube([main_x,main_roofPanelLength,1],center=true);
        translate([0,main_y/4,main_z/2+main_upper_z/2])
        rotate([-main_roofAngle,0,0])
        cube([main_x,main_roofPanelLength,1],center=true);
    }
}

//Person
module person()
{
    height = 5.8;
    headRad = 5/12;
    shoulderWidth = 2;
    //Head
    translate([0,0,height-headRad])
    sphere(r=headRad);
    //Body
    cylinder(r=2/12,h = height);
    //Shoulders
    translate([0,0,height-headRad*2])
    rotate([90,0,0])
    cylinder(r=2/12,h = shoulderWidth,center=true);
    rotate([0,0,90])
    translate([0,0,height-headRad*2])
    rotate([90,0,0])
    cylinder(r=2/12,h = shoulderWidth,center=true);
}
module people()
{
    translate([0,0,-main_z/2])
    person();
    translate([0,0,main_z-main_z/2])
    person();
}

//Rooms
module main_rooms()
{
translate([0,-main_y/2.0+main_lilBedRoom_y/2.0,0])
{
    //Little bedrooms
    translate([main_x/2.0-0.5*main_lilBedRoom_x,0,0])
    room(main_lilBedRoom_x,main_lilBedRoom_y,main_z,"red");
    translate([main_x/2.0-1.5*main_lilBedRoom_x,0,0])
    room(main_lilBedRoom_x,main_lilBedRoom_y,main_z,"red");
    translate([main_x/2.0-2.5*main_lilBedRoom_x,0,0])
    room(main_lilBedRoom_x,main_lilBedRoom_y,main_z,"red");
}
//Big bedrooms
translate([-main_x/2.0+0.5*main_bigBedRoom_x,-main_y/2.0+main_bigBedRoom_y/2.0,0])
    room(main_bigBedRoom_x,main_bigBedRoom_y,main_z,"red");
//Bathrooms
translate([-main_x/2.0+main_bigBedRoom_x+0.5*main_bathRoom_x,-main_y/2.0+main_bathRoom_y/2.0,0])
    room(main_bathRoom_x,main_bathRoom_y,main_z,"yellow");
translate([-main_x/2.0+main_bigBedRoom_x+1.5*main_bathRoom_x,-main_y/2.0+main_bathRoom_y/2.0,0])
    room(main_bathRoom_x,main_bathRoom_y,main_z,"yellow");
}

module main()
{
    //Roofs
    main_roof();
    //Main
    room(main_x,main_y,main_z,"blue");
    //Interior rooms
    main_rooms();
}

//------------
//-- Garage --
//------------
module garage()
{
    translate([-main_x/2.0-garage_x/2.0+garage_overlap_x,main_y/2.0+garage_y/2.0,0])
    room(garage_x,garage_y,garage_z,"blue");
}

//----------
//-- Pool --
//----------
module pool()
{
    translate([main_x/2.0+pool_x/2.0-pool_overlap_x,main_y/2.0+pool_y/2.0,0])
    room(pool_x,pool_y,pool_z,"blue");
}

//---------------
//-- RENDERING --
//---------------
//main();
//garage();
//pool();

main_rooms();
main_structure();
people();