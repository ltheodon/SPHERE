% Clear workspace and close all figures
clear all;
close all;

% Metadata - Number of vertices for sphere mesh,
% Gaussian field GA size, Gaussian field GT size
meta = [256, 50, 50];

% Parameters
scale = 1;                   % Scaling factor
E = 0.8;                     % Elongation parameter
L = [15, 2];                 % Correlation lengths for Gaussian fields
c = [20, 5] / 100;           % Deformation coefficients for Gaussian fields

% Aggregate parameters into a single array
params = [scale, E, c(1), L(1), c(2), L(2)];

% Generate 3D object and corresponding RGB image
[geo, imgRGB] = genObj(params, meta);
