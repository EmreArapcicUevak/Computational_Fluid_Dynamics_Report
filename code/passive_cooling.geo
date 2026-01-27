SetFactory("OpenCASCADE");

v() = ShapeFromFile("air_domain.step");

// nema smisla sitnije od ovoga ~1M
lc_fine = 0.7;     // to change number of tets
lc_coarse = 3.5;   // to change number of tets


Field[1] = Distance;
Field[1].SurfacesList = {Surface{:}};
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = lc_fine;
Field[2].SizeMax = lc_coarse;
Field[2].DistMin = 5.0;
Field[2].DistMax = 30.0;
Background Field = 2;


Mesh.Algorithm = 6;
Mesh.Algorithm3D = 10;

Mesh.Optimize = 1;
Mesh.OptimizeNetgen = 1;
Mesh.OptimizeThreshold = 0.4;


// PHYSICAL GROUPS DEFINITIONS

Physical Volume("Air_Fluid") = {1};


all_air_surfaces[] = Boundary{ Volume{1}; };


inlet_surfaces[] = Surface In BoundingBox {-7.76, -12.22, 24.94, 4.3, 11.8, 24.95};
Physical Surface("Inlet_Air") = {inlet_surfaces[]};

outlet_surfaces[] = Surface In BoundingBox {45.1, -12.3, 9.5, 45.2, 12, 20};
Physical Surface("Outlet_Air") = {outlet_surfaces[]};

top_air_wall[] = Surface In BoundingBox {-45, -30, 23.94, 45, 30, 25};
top_air_wall[] -= inlet_surfaces[];
Physical Surface("Top_Air_Wall") = {top_air_wall[]};

front_air_wall[] = Surface In BoundingBox {-45, -30, 3, 45, -29.94, 24};
Physical Surface("Front_Air_Wall") = {front_air_wall[]};

back_air_wall[] = Surface In BoundingBox {-45, 29.25, 3, 45, 30, 24};
Physical Surface("Back_Air_Wall") = {back_air_wall[]};

left_air_wall[] = Surface In BoundingBox {-45, -30, 3, -44.3, 30, 24};
Physical Surface("Left_Air_Wall") = {left_air_wall[]};

right_air_wall[] = Surface In BoundingBox {44.1, -30, 3, 50, 30, 24};
right_air_wall[] -= outlet_surfaces[];
Physical Surface("Right_Air_Wall") = {right_air_wall[]};

cpu_surfaces[] = Surface In BoundingBox {0, -14, 4.5, 19, 3.2, 8.1};
Physical Surface("CPU") = {cpu_surfaces[]};

bottom_air_wall_and_board[] = all_air_surfaces[];
bottom_air_wall_and_board[] -= outlet_surfaces[];
bottom_air_wall_and_board[] -= inlet_surfaces[];
bottom_air_wall_and_board[] -= top_air_wall[];
bottom_air_wall_and_board[] -= front_air_wall[];
bottom_air_wall_and_board[] -= back_air_wall[];
bottom_air_wall_and_board[] -= left_air_wall[];
bottom_air_wall_and_board[] -= right_air_wall[];
bottom_air_wall_and_board[] -= cpu_surfaces[];
Physical Surface("Bottom_Air_Wall_And_Board") = {bottom_air_wall_and_board[]};

// PHYSICAL GROUPS DEFINITIONS END

Mesh 3;
Save "passive_cooling_simulation_mesh.msh";
