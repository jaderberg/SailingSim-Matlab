function objOut = translate(objIn,x,y,z)
%hierarchical translate function for structs and cell arrays
%Input is:
%  an struct consisting of a vertex and face array
%  or an cell array of structs
%  an x,y,z translation
if (iscell(objIn)) %a list of structs
   for i=1:length(objIn)
      objOut{i}=objIn{i};
      V=objOut{i}.vertices;
      V=[V(:,1)+x, V(:,2)+y, V(:,3)+z];
      objOut{i}.vertices=V;   
   end      
 elseif (isstruct(objIn)) %must be a single struct   
    V=objIn.vertices;
    V=[V(:,1)+x, V(:,2)+y, V(:,3)+z];
    objOut=objIn;
    objOut.vertices=V; 
 else
    error('input must be s struct or cell array')
 end %if   