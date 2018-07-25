function out = app(varargin)
%APP Base application for argument parsing and command invocation

[command, args] = octue.argParser(varargin{:});

switch command
    case 'run'
        
        % Instantiate an analysis, which attaches it to the getter
        octue.Analysis(args);
        
        % Run the analysis code in the application folder
        main();
        
        % Return success code
        out = 0;
        
    case 'version'
        % Print the app version

        % Top Tip:
        % For all Octue internal apps, we simply return the git revision of the 
        % code. Every single commit creates a new version, so we can always 
        % check out the exact version of the code that ran, and we can quickly 
        % look up the version state and history on github when we have to debug
        % an app.
        [out, result] = system('git rev-parse HEAD');
        if out ~= 0
            error(['Non-zero status from system command. Message was: ' result])
        end
        
        % Print to stdout
        disp(result)
        
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

