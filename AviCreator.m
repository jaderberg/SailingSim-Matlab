% Prepare the new file.
vidObj = VideoWriter('peaks.avi');
open(vidObj);

% Create an animation.
Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');

for k = 1:20 
   surf(sin(2*pi*k/20)*Z,Z)
   set(gcf, 'Renderer', 'painters'); 
   % Write each frame to the file.
   currFrame = getframe;
   writeVideo(vidObj,currFrame);
end

% Close the file.
close(vidObj);