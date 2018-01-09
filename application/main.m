function main()
%MAIN An example main function for a new app
%#ok<*NASGU>

% You can get the current analysis from anywhere in your code:
analysis = octue.get('analysis');


% From which important properties and your configuration can be pulled:
inputDir  = analysis.InputDir;         % All the input data files are here 
outputDir = analysis.OutputDir;        % Save any results into this directory
tmpDir    = analysis.TmpDir;           % Save any temporary / cache results here
logDir    = analysis.LogDir;           % Logs will get saved here
inputMan  = analysis.InputManifest;    % This manifest object can be used to get names of your input files using the tagging system
outputMan = analysis.OutputManifest;   % Log results files onto this output manifest to create the results dataset


% You can also get the config that an analysis is launched with. 
% This gives you the analysis configuration as a MATLAB structure, validated
% against your schema.json file
cfg = analysis.Config;


% Use the configuration options to run the analysis
[x, y, img, cmap] = mandelbrot(cfg.width, ...
                               cfg.height, ...
                               min(cfg.x_range), ...
                               max(cfg.x_range), ...
                               min(cfg.y_range), ...
                               max(cfg.y_range), ...
                               cfg.max_iterations);

            
% Register a figure on the Octue system
%
%   Figures are a special file type on Octue, which can be 
%   This saves a .json file describing a figure, which will later be rendered.
%   If you're doing a test run of the app with octue.local() the figure is
%   rendered and displayed in your web browser.
%
%   We'll add some tags, which will help to improve searchability and allow
%   other apps, reports, users and analyses to automatically find figures and
%   use them.
%
%   Get descriptive with tags... they are whitespace-delimited and colons can be
%   used to provide subtags. Tags are case insensitive, and accept a-z, 0-9,
%   hyphens and underscores (which can be used literally in search and are also
%   used to separate words in natural language search). Other special characters
%   will be stripped.
data = struct('x', x, 'y', y, 'z', img, 'colorscale', cfg.color_scale, 'type', 'surface');
layout = struct('title', 'Mandelbrot set', 'width', cfg.width, 'height', cfg.height);
tags = 'contents:fractal:mandelbrot type:figure:surface';
octue.addFigure(data, layout, tags);


% Register a results file
%
%   Above, we registered a figure file for plotting scientific data/charts,
%   but we can also register normal files as part of the output dataset. Let's
%   write a normal results file (which in this case is an image file)...
name = fullfile(outputDir, ['mandelbrot.' cfg.type]);
imwrite(img, cmap, name, cfg.type);

%   ...and register it as a results file on Octue (this adds it to the output
%   file manifest)
outputManifest = octue.get('outputmanifest');
tags = 'contents:fractal:mandelbrot type:image';
outputManifest.Append(name, tags)


end
