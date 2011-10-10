function sphere=UnitSphere(res)
%unit sphere in a format consistent with hieracrhical 
%modeler
%The input paramenter is related to the sphere resolution.
%Range 1-10. Higher number is better approximation
%1=>octahedron
%1.5=> 44 faces
%2=> 100 faces
%2.5 => 188 faces
%3=> 296 faces
%5=> 900 faces
%10=>3600 faces

%range check
if (res>10)
   res=10;
elseif (res<1)
   res=1;
end

res=1/res;
[x,y,z]=meshgrid(-1-res:res:1+res, ...
   -1-res:res:1+res, -1-res:res:1+res);
w=sqrt(x.^2+y.^2+z.^2);
sphere=isosurface(x,y,z,w,1);

