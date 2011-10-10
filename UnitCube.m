function cube=UnitCube
%unit cube in a format consistent with hieracrhical 
%modeler
 
%Define a cube
cube.vertices=[ 0 0 0; 1 0 0; 1 1 0; 0 1 0; ...
      0 0 1; 1 0 1; 1 1 1; 0 1 1;] ;
cube.faces=[ 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; ...
      1 2 3 4; 5 6 7 8; ] ;

cube.vertices = cube.vertices * 2 - 1;