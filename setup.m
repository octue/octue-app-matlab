function setup(cmd)
%SETUP Sets up or tears down paths for a MATLAB application build
%
%   setup --path saves the current path and generates a path for the current app
%   setup --revert-path reverts the current path to the saved one
%

persistent originalPath

switch cmd
    case '--path'
        
        % Save the current path setup
        originalPath = path;
        
        % Include the +octue package in the SDK (no subfolder recursion to avoid
        % adding .git folders to the path)
        addpath(fullfile(pwd, '..', 'octue-sdk-matlab'))
        
        % Include the third party modules as required
        addpath(genpath(fullfile(pwd, '..', 'octue-sdk-matlab', 'thirdparty', 'logging')))
        addpath(genpath(fullfile(pwd, '..', 'octue-sdk-matlab', 'thirdparty', 'plotly')))
        if verLessThan('matlab', '9.2')
            % R2016b introduced the jsonencode functions
            addpath(genpath(fullfile(pwd, '..', 'octue-sdk-matlab', 'thirdparty', 'r2016a_patch')))
        end
        
        % -------------------------   EDIT HERE   ------------------------------
        
        % Ensure that the application paths are added.
        %
        % Note, this step is strictly optional. If your app and the necessary
        % subfolders are already on your user path, no modification is needed
        % here and you can proceed with build and local running.
        %
        % However, it is best to specify everything that needs to be added for 
        % your app to run. - remember that third party installations are
        % unlikely to have the same userpath as you do. This helps prevent build
        % errors and helps debugging (by reducing potential for path ambiguity).
        %
        % Normally, all your app code will sit in the applications folder of
        % this repository and its subfolders. So the following is typically all
        % that needs to be here:
        
        addpath(genpath(fullfile(pwd, 'application')))  % Recursively include 
                                                        % anything in the 
                                                        % ./application folder
                                                        
        % For any extra requirements, you'll need to add (for example):
        % addpath('any_folder/that_you/want_to_add')
        % addpath(genpath('any_folder_and_all_its_subfolders'))
        
        % Best practice: We actually don't recommend adding anything here.
        % It's usually best, if you have other dependencies not on this source
        % tree, to use the git submodule package to add them in subfolders of
        % the application directory. If the dependencies are private, include 
        % them in your Octue App installation on GitHub to automatically manage
        % credentials securely.
        
        % ----------------------------------------------------------------------
        
    case '--revert-path'
        
        % Reset the path to pre-build state
        if ~isempty(originalPath)
            path(originalPath)
        else
            error('Could not reset original path; path has not been modified by setup.m since MATLAB was started.')
        end
        
    otherwise
        error('Unknown command. Try setup --path or setup --revert-path')
        
end
