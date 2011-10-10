function objOut = scale(objIn,x,y,z)
%hierarchical scale function for structs and cell arrays

if (iscell(objIn)) %a list of structs
   for i=1:length(objIn)
      objOut{i}=objIn{i};
      V=objIn{i}.vertices;
      V=[V(:,1)*x, V(:,2)*y, V(:,3)*z];
      objOut{i}.vertices=V;
   end      
 elseif (isstruct(objIn)) %must be a single struct   
    V=objIn.vertices;
    V=[V(:,1)*x, V(:,2)*y, V(:,3)*z];
    objOut=objIn;
    objOut.vertices=V; 
 else
    error('input must be s struct or cell array')
 end %if   