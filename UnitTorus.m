function torus=UnitTorus(radius, res)
%unit torus in a format consistent with hieracrhical 
%modeler
%The first parameter is the radius of the cross-section
%The second input paramenter is related to the  resolution.
%Range 1-10. Higher number is better approximation
%Res input of less than 3 makes a very rough torus
%3=> 384 faces
%5=>1230 faces
%10=>5100 faces

%range check
if (res>10)
   res=10;
elseif (res<1)
   res=1;
end

res=1/res;
[x,y,z]=meshgrid(-1-radius-res:res:1+radius+res, ...
   -1-radius-res:res:1+radius+res, -radius-res:res:radius+res);

w=(1-sqrt(x.^2+y.^2)).^2 +z.^2 - radius^2;

torus=isosurface(x,y,z,w,0);

