function [xvals,yvals] = ImportTracks(file, wormUIDs, tracklength, numworms, altcamxvals)
%ImportTracks - Modular function that will import the x and y coordinates
%of individual worm tracking data from an excel spreadsheet.
%   Required Inputs:
%       file = name of excel spreadsheet containing the tracking data in
%       tabs
%       sheet = names of the tabs containing the tracking data for import
%       tracklength = expected number of images, usually 300 for a 10 min
%           tracking session and 450 for a 15 min session.
%       numworms = number of tracks (i.e. individual worm data) to import
%   Optional Inputs:
%       altcamxvals = x-coordinates from tracks previously imported from another camera.
%   Outputs:
%       xvals = x-coordinates of the worm location, in pixels
%       yvals = y-coordinates of the worm location, in pixels

%   Created Dec 30, 2017 by Astra S. Bryant

xvals=NaN(tracklength,numworms);
yvals=NaN(tracklength,numworms);

if exist('altcamxvals')
    %% Dual Camera Import, assumes an initial import has already occured.
    B = ~isnan(altcamxvals);
    Indices = arrayfun(@(x) find(B(:, x), 1, 'last'), 1:size(altcamxvals, 2),'UniformOutput',false);
    
    for i=1:numworms
        sheet = [wormUIDs{i}];
        testexists = importfileXLS(file, sheet, strcat('D1:D',num2str(tracklength)));
        if ~isempty(testexists)
            if isempty(Indices{i}) || Indices{i}<tracklength
                sheet = [wormUIDs{i}];
                tempx(:,1) = importfileXLS(file, sheet, strcat('D1:D',num2str(tracklength)));
                tempy(:,1)= importfileXLS(file, sheet, strcat('E1:E',num2str(tracklength)));
                xvals(1:length(tempx),i)=tempx;
                yvals(1:length(tempy),i)=tempy;
                
                clear tempx tempy
                
            end
        end
    end
    
else
    %% Single Camera Import
    for i=1:numworms
        
        sheet = [wormUIDs{i}];
        testexists = importfileXLS(file, sheet, strcat('D1:D',num2str(tracklength)));
        if ~isempty(testexists)
        tempx(:,1) = importfileXLS(file, sheet, strcat('D1:D',num2str(tracklength)));
        tempy(:,1)= importfileXLS(file, sheet, strcat('E1:E',num2str(tracklength)));
        xvals(1:length(tempx),i)=tempx;
        yvals(1:length(tempy),i)=tempy;
        end
        clear tempx tempy
        
    end
end


end


