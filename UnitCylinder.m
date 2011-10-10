function cylinder=UnitCcylinder(res)
%unit sphere in a format consistent with hieracrhical 
%modeler
%The input paramenter is related to the sphere resolution.
%Range 1-10. Higher number is better approximation
%1=> 4-sided tube
%1.5=> 8-sided tube
%2=> 48 faces
%3=> 80 faces
%5=>136 faces
%10=>272 faces

%range check
if (res>10)
   res=10;
elseif (res<1)
   res=1;
end

res=1/res;
[x,y,z]=meshgrid(-1-res:res:1+res, ...
   -1-res:res:1+res, -1:1:1);
w=sqrt(x.^2+y.^2);
cylinder=isosurface(x,y,z,w,1);

