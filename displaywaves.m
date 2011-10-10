function displaywaves(datafile,X,Y,t)

    %% graph settings
    axvec = [min(min(X)) max(max(X)) min(min(Y)) max(max(Y)) -150 150]; %graph axes
    az = 0;
    
    %Q = dlmread(datafile);
    
    for i=1:1:length(t)
        R1 = size(X,1)*(i-1);
        C1 = 0;
        R2 = size(X,1)*i - 1;
        C2 = size(X,2) - 1;
        Z = dlmread(datafile,',',[R1 C1 R2 C2]);
        %Z = Q(R1+1:R2+1,:);
        meshz(X,Y,Z);
        colormap winter
        shading interp
        axis(axvec)
        view(az,20);
        axis off
        axis vis3d
        az = az + 0.1;
        pause(0.01);
    end

