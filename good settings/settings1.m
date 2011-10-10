%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Float a 2d boat in water
% MEJ 1/2/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = floatboat()

%% define world
world.g = 9.81;
world.rho = 1000;
world.dt = 0.01;


%% set simulation
t0 = randn*100;
frames = 5000;
M = [];
world.t = t0:world.dt:t0+frames*world.dt;
world.dx = 0.01;
world.x = -5:world.dx:5;
world.water.dw = 0.1;
world.water.w = world.water.dw:world.water.dw:2;


%% water and wind
world.water.y = zeros(size(world.x));
world.wind.speed = 40; %wind speed @19.5m (knots?)
world.wind.dir = zeros(size(world.x));
%compute frequency spectrum from 
%Pierson-Moskowitz formula
world.water.Sw = (8.1e-3*world.g^2./(world.water.w.^5)).*exp(-0.74*(world.g*((world.wind.speed*world.water.w).^-1)).^4);
%compute amplitudes of wave spectra
%(http://en.wikipedia.org/wiki/Sea_states
world.water.A = 0.05*sqrt(2*world.water.Sw*world.water.dw);
%compute wave numbers
world.water.k = 200*world.water.w.^2/world.g;
world.water.w = 10*world.water.w;

%% wave plots
% plot(world.water.w,world.water.Sw)
% plot(world.water.w,world.water.A)
% plot(world.water.k,world.water.A)
% plot(2*pi./world.water.k,world.water.A)
% plot(2*pi./world.water.k,world.water.w./world.water.k)


%% define boat
boat.x = -1; %initial xpos
boat.y = 0; %initial ypos
boat.thetaz = 00; %initial rotation
vertex = 2*[-0.8 -0.1; -1.2 0.1; 1 0.1; 0.8 -0.1]; %boat shape relative to CofM
boat.CofM = zeros(size(vertex));
boat.CofM(:,1) = 0.1;
boat.hull.vertex = vertex - boat.CofM;
for i=1:1:length(boat.hull.vertex(:,1))
   if boat.hull.vertex(i,1) < 0
      boat.hull.vertexAngle(i) = atand(boat.hull.vertex(i,2)/boat.hull.vertex(i,1));
      boat.hull.vertexDistance(i) = -1*norm(boat.hull.vertex(i,:));
   else
      boat.hull.vertexAngle(i) = atand(boat.hull.vertex(i,2)/boat.hull.vertex(i,1));
      boat.hull.vertexDistance(i) = norm(boat.hull.vertex(i,:));
   end
end
[boat.hull.worldVertex boat.hull.worldVertexExact] = getBoatVertex(boat.hull,world,boat);
boat.submergedArea = submergedArea(boat, world);
boat.m = 120;
boat.v = 0;
boat.J = 10;
boat.omega = 0;
% draw boat sail
boat.sail.vertex = 2*[-0.8 0.1; -0.8 1.7; -0.7 1.7; -0.7 1.6; 0.5 0.4; -0.7 0.4; -0.7 0.1];
for i=1:1:length(boat.sail.vertex(:,1))
    if boat.sail.vertex(i,1) < 0
        boat.sail.vertexAngle(i) = atand(boat.sail.vertex(i,2)/boat.sail.vertex(i,1));
        boat.sail.vertexDistance(i) = -1*norm(boat.sail.vertex(i,:));
    else
        boat.sail.vertexAngle(i) = atand(boat.sail.vertex(i,2)/boat.sail.vertex(i,1));
        boat.sail.vertexDistance(i) = norm(boat.sail.vertex(i,:));
    end
end
[boat.sail.worldVertex boat.sail.worldVertexExact] = getBoatVertex(boat.sail,world,boat);

%% simulation
for frame=1:1:length(world.t)
    
    % force due to gravity
    F = [-boat.m*world.g 0];
    
    [boat.submergedArea boat.momentArea] = submergedArea(boat, world);
    F = F + buoyancyForce(boat,world);
    F = F + waterDragForce(boat,world);
    
    
    
    % update boat state
    boat = updateBoatState(F, boat, world);
    
    % update water state
    world.water = updateWaterState(world, frame);
    
    % animate
    drawFrame(boat, world);
    %pause(world.dt);
    M = recordFrame(M,frame,25,world.dt); % save a movie
    100*round2(frame/frames,0.01)  % output percent complete
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% simulate water
    function water = updateWaterState(world, frame)
        world.water.y = 0.1*generateWaves(world.water.w,world.water.y,world.x,zeros(size(world.x)),world.water.A,world.water.k,world.wind.dir,world.t(frame));
        water = world.water;

    %% buoyancy force
    function F = buoyancyForce(boat, world)
        % force due to buoyancy
        F = [world.rho*world.g*boat.submergedArea world.rho*world.g*boat.momentArea];

    %% work out area and first moment of area submerged
    function [Asubmerged momentArea] = submergedArea(boat,world)
        minBoatValues = min(boat.hull.worldVertex);
        maxBoatValues = max(boat.hull.worldVertex);
        bottomOfBoat = minBoatValues(2);
        topOfBoat = maxBoatValues(2);
        leftOfBoat = minBoatValues(1);
        rightOfBoat = maxBoatValues(1);
        waterMax = max(world.water.y);
        % work out volume beneath water
        if topOfBoat < waterMax
            % boat is completely submerged
            Asubmerged = polyarea(boat.hull.worldVertex(:,1),boat.hull.worldVertex(:,2));
            momentArea = boat.momentArea;
        else
            sortedVertex = sortrows(boat.hull.worldVertex);
            xToSearch = leftOfBoat:world.dx:rightOfBoat;
            submergedDepth = zeros(size(xToSearch));
            nextVertex = 1;
            for n=1:1:length(xToSearch)
                first = 1;
                while xToSearch(n) >= sortedVertex(nextVertex,1) && nextVertex < length(sortedVertex)
                    if first
                        first = 0;
                        prevVertex = nextVertex;
                    end
                    nextVertex = nextVertex + 1;
                end
                %create line between the vertices
                if sortedVertex(prevVertex,1)~= sortedVertex(nextVertex,1)
                    yi = interp1([sortedVertex(prevVertex,1) sortedVertex(nextVertex,1)],[sortedVertex(prevVertex,2) sortedVertex(nextVertex,2)],xToSearch(n));
                end
                submergedDepth(n) = world.water.y(abs(world.x-xToSearch(n))<world.dx/2) - yi;
            end
            submergedX = xToSearch(submergedDepth>0);
            submergedDepth = submergedDepth(submergedDepth>0);
            if length(submergedX) > 1
                Asubmerged = trapz(submergedX,submergedDepth);
                adjustedX = submergedX - boat.x;
                momentArea = trapz(submergedX,submergedDepth.*adjustedX);
            else
                Asubmerged = 0;
                momentArea = 0;
            end
        end

    %% water drag on boat
    function F = waterDragForce(boat, world)
        F = [-5000*boat.submergedArea*boat.v -300*boat.submergedArea*boat.omega];

    %% update boat state
    function boat = updateBoatState(F, boat, world)
        boat.a = F(1)/boat.m;
        boat.v = boat.v + boat.a*world.dt;
        boat.y = boat.y + boat.v*world.dt;
        boat.omegadot = F(2)/boat.J;
        boat.omega = boat.omega + boat.omegadot*world.dt;
        boat.thetaz = boat.thetaz + boat.omega*world.dt;

        [boat.hull.worldVertex boat.hull.worldVertexExact] = getBoatVertex(boat.hull,world, boat);
        [boat.sail.worldVertex boat.sail.worldVertexExact] = getBoatVertex(boat.sail,world,boat);
    
    %% display simulation
    function drawFrame(boat, world)

        %draw boat
        fill(boat.hull.worldVertexExact(:,1), boat.hull.worldVertexExact(:,2), 'r' )
        hold on;
        fill(boat.sail.worldVertexExact(:,1), boat.sail.worldVertexExact(:,2), [0 0 0] )
        hold on;

        
        %plot(world.x,world.water.y)
        fill([min(world.x) world.x max(world.x)], [-2 world.water.y -2],'b');
        % display
        axis([min(world.x) max(world.x) -2 8]);
        %axis equal
        set(gca,'XTickLabel','','YTickLabel','','XTick',[],'YTick',[])
        hold off;
    
    %% transform vertices
    function [worldVertex worldVertexExact] = getBoatVertex(polygonObject, world, boat)
        % transforms to get true position of boat verticies
        worldVertexExact = zeros(size(polygonObject.vertex));
        worldVertex = zeros(size(polygonObject.vertex));
        for i=1:1:length(polygonObject.vertex(:,1))
            worldVertexExact(i,1) = boat.x + polygonObject.vertexDistance(i)*cosd(polygonObject.vertexAngle(i) + boat.thetaz);
            worldVertexExact(i,2) = boat.y + polygonObject.vertexDistance(i)*sind(polygonObject.vertexAngle(i) + boat.thetaz);
            worldVertex(i,1) = round2(worldVertexExact(i,1), world.dx);
            worldVertex(i,2) = round2(worldVertexExact(i,2), world.dx);
        end
        
    %% record movie
    function M = recordFrame(M,i,fps,dt)
        if mod(i,(1/fps)/dt) == 0
            set(gca,'nextplot','replacechildren')
            if isempty(M)
                P(1) = getframe(gcf);
                M = P;
            else
                M(end + 1) = getframe(gcf);
            end
        end