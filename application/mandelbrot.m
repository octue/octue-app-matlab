function [x, y, z, cmap] = mandelbrot(width, height, yMin, yMax, xMin, xMax, maxIterations, cmapName)
%MANDELBROT Creates a mandelbrot set fractal, given input parameters
%
% Author:                   T. H. Clark
% Work address:             Octue Ltd
%                           Hauser Forum
%                           3 Charles Babbage Road
%                           Cambridge
%                           CB3 0GT
% Email:                    tom@octue.com
% Website:                  www.octue.com
%
% Copyright (c) 2017-2018 Octue Ltd, All Rights Reserved.

% Generate linearly spaced points in x and y directions
x = linspace(xMin, xMax, width);
y = linspace(yMin, yMax, height);

% Create a linear 2d grid
[X, Y] = meshgrid(x, y);

% Allocate output array
z = zeros(height, width);
nPoints = width * height;

% Simple and crude loop to render the fractal set
for m = 1:nPoints
    a = X(m);
    b = Y(m);
    xn = 0;
    yn = 0;
    k = 1;
    while (k <= maxIterations) && ((xn^2+yn^2) < 4)
        xnew = xn^2 - yn^2 + a;
        ynew = 2*xn*yn + b;
        xn = xnew;
        yn = ynew;
        k = k+1;
    end
    z(m) = k;
end

% Generate a color map to go with it. MATLAB's maps aren't compatible with
% plotly so we'll just use winter for the moment.
cmap = winter(maxIterations);

end


