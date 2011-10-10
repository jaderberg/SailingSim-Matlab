%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wave potential function
% MEJ 22/1/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% define the world
[X Y] = meshgrid(-100:1:100,-100:1:100);
dt = .5;
frames = 1000;
dw = 0.1;
w = dw:dw:2;

%% driving conditions
U = 60; %wind speed @ 19.5m above sea level (knots)
%wind direction
winddir = zeros(size(X));
randwind = winddir;
%wind filter
wf = ones(160/U)/(160/U)^2;
%secondary wind speed
V = 30;
%secondary wind source angles
secWind = 10:10:90;
secWindACoeff1 = -1 + 2*rand(size(secWind));
secWindACoeff2 = -1 + 2*rand(size(secWind));
secWindACoeff = zeros(length(secWindACoeff1),frames+1);
for a = 1:1:length(secWindACoeff1)   
    secWindACoeff(a,:) = ((secWindACoeff2(a)-secWindACoeff1(a))/frames)*(0:1:frames)+secWindACoeff1(a);
end

%% pre computation

%compute frequency spectrum from 
%Pierson-Moskowitz formula
Sw = (8.1e-3*9.81^2./(w.^5)).*exp(-0.74*(9.81*((U*w).^-1)).^4);
Sw2 =(8.1e-3*9.81^2./(w.^5)).*exp(-0.74*(9.81*((V*w).^-1)).^4);

%compute amplitudes of wave spectra
%(http://en.wikipedia.org/wiki/Sea_state)
A = sqrt(2*Sw*dw);
A2 = sqrt(2*Sw2*dw);

%compute wave numbers
k = w.^2/9.81;

%% graph settings
axvec = [min(min(X)) max(max(X)) min(min(Y)) max(max(Y)) -150 150]; %graph axes
az = 0;
el = 20;

%% simulation
t0 = randn*100;
t = t0:dt:t0+frames*dt;
t02 = randn(size(secWind))*100;

for i=1:1:length(t)
    h = figure(1);
    Z = zeros(size(X));
    %generate some smooth random wind
    randwind = (randwind - 10 + (20).*rand(size(winddir)))/2; %average with prev rand wind
    dir = filter2(wf, winddir + randwind); %apply smoothing filter
    %generate main wave source
    Z = generateWaves(w, Z, X, Y, A, k, dir, t(i));
    %now add waves from a different wind source
    for j=1:1:length(secWind)
       t2 = t02(j):dt:t02(j)+frames*dt;
       dir = dir + secWind(j)*ones(size(dir));
       Z = generateWaves(w, Z, X, Y, secWindACoeff(j,i).*A2, k, dir, t2(i));
    end
    %dlmwrite('wavedata.dat', Z, '-append', 'delimiter', ',')
    m = meshz(X,Y,3*Z);
    set(m,'FaceLighting','phong','FaceColor','interp',...
      'AmbientStrength',0.5)
    light('Position',[1 1 0],'Style','infinite');
    set(gcf, 'Position',[0 0 400 400]);
    %set(gcf, 'Renderer', 'painters');  %allows movie making but is slower
    colormap winter
    shading interp
    axis(axvec)
    view(az,el);
    axis off
    axis vis3d
    %axis tight
    M(i) = getframe(h,[30 50 350 350]);
    az = az + 360/length(t);
    i*100/length(t)
end

% % Create mpg
map=colormap;    % Uses the previously defined colormap 
mpgwrite(M,map,'oceanwavesZoomExtraWaves.mpg')

%displaywaves('wavedata.dat',X,Y,t)


