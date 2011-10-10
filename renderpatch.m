function count = renderpatch(objIn)
%hierarchical render function for structs and cell arrays
%Takes either a cell array or a single struct as input.
%For each struct, can set:
%  facecolor: default=cyan
%  edgecolor: default='none'
%  ambientstrength: default=.6
%  specularstrength: default=.2
%  specularexponent: default=10
%  facelighting: default='phong'
%  diffusestrength: default=.5
%  visible: default='on'

if (iscell(objIn)) %a list of structs
   
   for i=1:length(objIn)

      obj=patch(objIn{i});
      
      if (isfield(objIn{i},'facecolor'))
         fcolor=objIn{i}.facecolor;
      else
         fcolor=[0,1,1];
      end
      
      if (isfield(objIn{i},'edgecolor'))
         ecolor=objIn{i}.edgecolor;
      else
         ecolor='none';
      end
      
      if (isfield(objIn{i},'ambientstrength'))
         ambstr=objIn{i}.ambientstrength;
      else
         ambstr=.6;
      end
      
      if (isfield(objIn{i},'specularstrength'))
         spcstr=objIn{i}.specularstrength;
      else
         spcstr=.2;
      end
      
      if (isfield(objIn{i},'specularexponent'))
         spcexp=objIn{i}.specularexponent;
      else
         spcexp=10;
      end
      
      if (isfield(objIn{i},'facelighting'))
         facelight=objIn{i}.facelighting;
      else
         facelight='phong';
      end
      
      if (isfield(objIn{i},'diffusestrength'))
         difstr=objIn{i}.diffusestrength;
      else
         difstr=.5;
      end
  
      if (isfield(objIn{i},'visible'))
         vis=objIn{i}.visible;
      else
         vis='on';
      end


      set(obj, 'FaceColor', fcolor, ...
               'EdgeColor', ecolor, ...
               'AmbientStrength',ambstr,...
               'SpecularStrength',spcstr, ...
               'SpecularExponent', spcexp, ...
               'FaceLighting', facelight, ...
               'DiffuseStrength', difstr, ...
               'Visible',vis);
   end  
   count=i;
   
 elseif (isstruct(objIn)) %must be a single struct   
    obj=patch(objIn);
    
    if (isfield(objIn,'facecolor'))
         fcolor=objIn.facecolor;
      else
         fcolor=[0,1,1];
      end
      
      if (isfield(objIn,'edgecolor'))
         ecolor=objIn.edgecolor;
      else
         ecolor='none';
      end
      
      if (isfield(objIn,'ambientstrength'))
         ambstr=objIn.ambientstrength;
      else
         ambstr=.6;
      end
      
      if (isfield(objIn,'specularstrength'))
         spcstr=objIn.specularstrength;
      else
         spcstr=.2;
      end
      
      if (isfield(objIn,'specularexponent'))
         spcexp=objIn.specularexponent;
      else
         spcexp=10;
      end
      
      if (isfield(objIn,'facelighting'))
         facelight=objIn.facelighting;
      else
         facelight='phong';
      end
      
      if (isfield(objIn,'diffusestrength'))
         difstr=objIn.diffusestrength;
      else
         difstr=.5;
      end
  
      if (isfield(objIn,'visible'))
         vis=objIn.visible;
      else
         vis='on';
      end

      set(obj, 'FaceColor', fcolor, ...
               'EdgeColor', ecolor, ...
               'AmbientStrength',ambstr,...
               'SpecularStrength',spcstr, ...
               'SpecularExponent', spcexp, ...
               'FaceLighting', facelight, ...
               'DiffuseStrength', difstr, ...
               'Visible',vis);
      count=1;   
 end %if   