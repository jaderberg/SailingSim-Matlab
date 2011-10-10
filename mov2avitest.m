nFrames = 20;

% Preallocate movie structure.
mov(1:nFrames) = struct('cdata', [],...
                        'colormap', []);

% Create movie.
Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');
for k = 1:nFrames 
   surf(sin(2*pi*k/20)*Z,Z)
   mov(k) = getframe(gcf);
end

% Create AVI file.
movie2avi(mov, 'myPeaks.avi', 'compression', 'None');
map=colormap;    % Uses the previously defined colormap 
mpgwrite(mov,map,'myPeaks.mpg')

