function objOut = combine(varargin);

%Takes a list of opjects (structs and cell arrays) and
%returns a cell array

num=length(varargin);

if (num==0)
   error('must have at least one input object');
end

objOut={};

for i=1:num
   if (iscell(varargin{i})) %a list of structs
      objOut=[objOut, varargin{i}];        
   elseif (isstruct(varargin{i})) %must be a single struct         
      objOut=[objOut, {varargin{i}}];    
   else
      error('input must be s struct or cell array')
   end %if (iscell(varargin(i)))   
end %for