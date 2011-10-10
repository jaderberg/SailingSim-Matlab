% test actuator model
Ts = 0.01;
t = 0:Ts:60;

% control signal
u = zeros(size(t));
u(t>2) = 1;
u(t>3) = 0.5;
u(t>4) = 0.5*cos(0.1*t(t>4));

y = zeros(size(t));

for k = 1:1:length(t)
    if k < 3
        y(k) = 0;
    else
        y(k) = actuatorModel(y,u,k);
    end
end

plot(t, u, 'blue', t, y, 'red'); hold on;

params = estimateActuatorParams(y,u);

actualParams = [200*4.5e-5 200*4.1e-5 1.721 -0.7558]
estimatedParams = params

ymodel = zeros(size(t));
for k = 1:1:length(t)
    if k < 3
        ymodel(k) = 0;
    else
        ymodel(k) = estimatedParams*[u(k-1); u(k-2); ymodel(k-1); ymodel(k-2)];
    end
end

plot(t,ymodel,'green'); hold on;

% now control it with controller

ucontrolled = zeros(size(t));
ycontrolled = zeros(size(t));
K = 10;
for k=1:1:length(t)
   if k < 3
       ucontrolled(k) = 0;  
       ycontrolled(k) = 0;
   else
       ucontrolled(k) = K*Ts*(u(k-1)-ycontrolled(k-1)) + ucontrolled(k-1); %this is the control signal
       ycontrolled(k) = estimatedParams*[ucontrolled(k-1); ucontrolled(k-2); ycontrolled(k-1); ycontrolled(k-2)];
   end
end

plot(t,ycontrolled,'black'); hold off;

