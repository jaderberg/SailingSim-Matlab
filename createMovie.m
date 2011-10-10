function createMovie(M, name)

%%% Create mpg
map=M.colormap;    % Uses the previously defined colormap 
movie2avi(M, strcat(name,'.avi'),'compression','Cinepak','fps',25,'quality',100)
mpgwrite(M,map, strcat(name,'.mpg'))