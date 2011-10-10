function square=UnitSquare
%unit square in the x-y plane
%in a format consistent with hieracrhical 
%modeler
 
 %Define a square
square.vertices= ...
   [-1, -1, 0;
    -1, 1, 0;
     1, 1 ,0;
     1, -1, 0];
square.faces=[1 2 3 4];