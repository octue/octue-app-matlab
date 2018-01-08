% Create figures
%
% MATLAB's own figure plotting utilities are extremely outdated, and don't run
% on `headless' servers (i.e. in cloud based applications).
%
% Octue uses the plot.ly engine to render figures. It's similar to MATLAB, and
% we think you'll find the results to be attractive, consistent across different
% users' machines, and much more easily exportable to html, SVG, PDF and
% similar.
%
% This does mean that when you plot figures, they need to be created
% using plot.ly's native syntax rather than plotting figures using MATLAB's
% commands. Scroll to the native section of the following guide for a tutorial:
%   https://plot.ly/matlab/offline/
%
% All of the MATLAB chart types are available in plotly; see their chart types
% reference for how to add data and customise layout of each type:
% https://plot.ly/matlab/reference
%
% Note that plotly is installed with octue-sdk-matlab. Other versions of plotly
% may not work with octue, as we did some work to tidy up the API and prevent
% plotly from using the MATLAB figure renderer as a support framework. So make
% sure that other versions of plotly are not in your MATLAB path!
% TODO - we realise this is a bit annoying, and will be changing it in a future
% release!

% Let's create an example figure, then show you how to register it on Octue.

% Set up the data and layout options
trace1 = struct('x', [1, 2, 3, 4], ...
                'y', [10, 15, 13, 17], ...
                'type', 'scatter');
trace2 = struct('x', [1, 2, 3, 4], ...
                'y', [16, 5, 11, 9], ...
                'type', 'scatter');
data = {trace1, trace2};
layout = struct();
layout.title = 'Example Octue Figure';
layout.width = 800;
layout.height = 650;

% Register this as a plotly figure. Strictly, we don't need to do this (we can
% just use the data and layout, passed to octue.addFigure()) - but it's helpful
% to locally preview figures during app development.
p = plotlyfig('-norender');
p.data = data;
p.layout = layout;
p.PlotOptions.FileName = 'my-first-octue-figure';

% This means we can either write static image files immediately:
pdf(p);

% Or create a standalone HTML file, which we can look at in a browser (nb
% this'll create a junk .html file in your current directory)
html_file = plotlyoffline(p);
web(html_file, '-browser')

% We'll add some tags, which will help to improve searchability and allow other
% apps, reports, users and analyses to automatically find figures and use them.

% Get descriptive with tags... they are whitespace-delimited and colons can be
% used to provide subtags. Tags are case insensitive, and accept a-z, 0-9,
% hyphens and underscores (which can be used literally in search and are also 
% used to separate words in natural language search. Other special characters 
% will be stripped.
tags = 'contents:spectrum:energy type:scatter notes:variation-of-energy-with-frequency notes:linear-axes';

% The most important step is to register the figure on the Octue system
uuid = octue.addFigure(p, tags);

% Our figure is now saved as a .json file, and added to the output file manifest
% with its ID and tags. When the application completes, the figure will be
% uploaded to the permanent store and made available to subsequent apps in the
% pipeline and (of course!) for viewing. There will be a delay (for the pipeline
% to complete), but the figure will be available at:
% https://www.octue.com/<you>/figures/<uuid>
