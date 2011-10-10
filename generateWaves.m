function Z = generateWaves(w, Z, X, Y, A, k, dir, ti)
% w: frequency spectrum, Z: previous height profile
% X,Y: horizontal axis meshgrid, A: amplitude vector
% k: wavenumber vector, dir: direction of waves
% ti: current time value
for n=1:length(w)
    Z = Z + A(n)*cos(k(n)*(cosd(dir).*X + sind(dir).*Y) - w(n)*ti);
end
