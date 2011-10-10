function count = renderpatch(objIn)
%hierarchical render function for structs and cell arrays
%as a wire frame image.
%Takes either a cell array or a single struct as input.
%For each struct, can set:
%  maps facecolor to edgecolor
%  edgecolor: default='cyan'
%  visible: default='on'

if (iscell(objIn)) %a list of structs
   
   for i=1:length(objIn)

      obj=patch(objIn{i});
      
      if (isfield(objIn{i},'facecolor'))
         ecolor=objIn{i}.facecolor;
      else
         ecolor=[0,1,1];
      end
      
      if (isfield(objIn{i},'edgecolor'))
         ecolor=objIn{i}.edgecolor;
      end

      if (isfield(objIn{i},'visible'))
         vis=objIn{i}.visible;
      else
         vis='on';
      end
      
      set(obj, 'FaceColor', 'none', ...
               'EdgeColor', ecolor, ...
               'Visible',vis);
   end  
   count=i;
   
 elseif (isstruct(objIn)) %must be a single struct   
    obj=patch(objIn);
    
    if (isfield(objIn,'facecolor'))
         ecolor=objIn.facecolor;
      else
         ecolor=[0,1,1];
      end
      
      if (isfield(objIn,'edgecolor'))
         ecolor=objIn.edgecolor;
      end
      
       
      if (isfield(objIn,'visible'))
         vis=objIn.visible;
      else
         vis='on';
      end

      set(obj, 'FaceColor', 'none', ...
               'EdgeColor', ecolor, ...
               'Visible',vis);
      count=1;   
 end %if   