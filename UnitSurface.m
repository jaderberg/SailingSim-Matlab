function surface=UnitSurface(res)
%unit flat surface in a format consistent with hieracrhical 
%modeler
%The input paramenter is related to the sphere resolution.
%Range 1-10. Higher number is better approximation
%1=> 8 triangular faces
%2=> 32 faces
%5=>200 faces
%10=>800 faces
%20=>3200 faces
%50=>20000 faces

%range check
if (res>100)
   res=100;
elseif (res<1)
   res=1;
end

res=1/res;
[x,y,z]=meshgrid(-1:res:1, ...
   -1:res:1, -1:1:1);
w=z;
surface=isosurface(x,y,z,w,0);

