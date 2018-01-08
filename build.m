function build()
%BUILD Builds a standalone executable, suitable for running on octue,
% from a MATLAB application. 
%
% Requirements:
%
%   - Should be run from the root directory of the application.
%   - Requires MATLAB Compiler (mcc) to be installed
%
if exist(fullfile('.','app.m'),'file') ~= 2 
    error('No app.m file found. You need to build from the root directory of the app template.')
end
disp(['Building Octue application in directory: ' pwd])

% Start a diary file from scratch for the build
df = fullfile('build', 'build.log');
if exist(df,'file') == 2
    disp('Removing previous build log')
    delete(df)
end
diary(df)

% Setup paths so the application dependencies can be found.
setup --path

try
    
    % Build the matlab function into an executable
    mcc -e -d build app

    % Get version information from the app
    disp('Built app. Registering application version...')
    try
        mcrRoot = matlabroot;
        if ispc
            % Run the pc script
        else
            % Run the shell script to get the version (could get it directly
            % by calling app.m, but this checks that the app runner works so
            % kills two birds with one stone)
            [~, result] = system(sprintf('. build/octue.sh %s build/app version', mcrRoot));
            result = strrep(result, newline, '');
        end
        fprintf('Application version registered: %s\n', result)
        
    catch
        error('Unable to determine application version. Have you correctly implemented the ''version'' command in file app.m?')
    end

    % Prepare system information and save it to a json file
    info.app_ver = result;
    info.computer = computer;
    info.build_time = posixtime(datetime);
    info.matlab_ver = ver;
    info.matlab_path = path;
    octue.writeConfig(info, fullfile('build','build.info'))
    
    % Add the built files to a manifest
    manifest = octue.Manifest('build');
    manifest.Append(fullfile('build', 'app'), 'build:mcc:exe')
    if ispc
        % TODO what's the equivalent script on windows? A *.bat?
    else
        manifest.Append(fullfile('.','build','run_app.sh'), 'build:mcc:sh')
        % Temporary kludge - use our own script to get around MCC's
        % inflexibility for app name and location
        manifest.Append(fullfile('.','build','octue.sh'), 'app:sh')
    end
    manifest.Append(fullfile('build','build.log'), 'build:log')
    manifest.Append(fullfile('build','build.info'), 'build:info json')
    manifest.Append(fullfile('build','requiredMCRProducts.txt'), 'build:mcc:mcrrequired')
    
    % Save the manifest of build files
    manifest.Save(fullfile('build','manifest.json'))
    
catch me
    setup --revert-path
    diary off
    throw(me)
    
end

setup --revert-path
diary off
