function out = app(varargin)
%APP Base application for argument parsing and command invocation

[command, args] = octue.argParser(varargin{:});

switch command
    case 'run'
        % Instantiate an analysis and attach it to the config getter
        octue.get('config', octue.Analysis(args));
        
        % Run the analysis
        %   - edit the run() function (see below) to run your app
        run();
        
        % Return success code
        out = 0;
        
    case 'version'
        % Return the app version to the command line
        out = version();
        
    case 'schema'
        % Return the application schema to the command line
        fid = fopen('schema.json');
        schema = fscanf(fid, '%s');
        fclose(fid);
        out = schema;
        
    otherwise
        error('Invalid command passed to octue app')
end

end

function run()
%RUN Runs an application (locally, or deployed on the octue platform)

dispnow('Running the application...')
my_main_fcn();

end

function out = version()
%VERSION Returns a string containing the version number of the application

% Top Tip:
% For all Octue internal apps, we simply return the git revision of the code.
% Every single commit creates a new version, so we can always check out the
% exact version of the code that ran, and we can quickly look up the version
% state and history on github when we have to debug an app.
out = system('git rev-parse HEAD');

end    