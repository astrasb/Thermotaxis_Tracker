function [] = Manual_WormTracks()
%%Function that takes manual worm tracks from Fiji and makes a figure that
%%overlays the tracks.

% Used to analyze wt worms moving in a gradient. Will take either a single
% camera input (excel file), or 2 excel files with tracks of worms from one
% camera and continuing onto another. This program assumes that could be 2
% cameras, but is happy to analyze data from only a single camera. 

% Input = excel spreadsheet with an Index sheet listing:
%       the number of worms to analyze, 
%       the UIDs associated with the trakcs analyze that are ...
%           ... the names of the tabs in the excel file with the track datas
%       cmperdeg, maxgradient, and maxgradientAU data for each UID
%   A file listing the various datasets that *could* be analyzed by this
%   program.


% Created by Astra S. Bryant on 12/22/17 (or earlier). Made modular on Dec
% 30, 2017. Edited 3/25/18 to add CamR-only functionality
%% Variables
datasetfile='/Users/Batcave/Box Sync/Lab_Hallem/Astra/Writing/Bryant et al 2018/Data Files/Worm Tracking Matlab Scripts/Bryant et al 2018 Manual Worm Tracks Dataset List.xlsx';
%GUI for selecting what experiment to analyze.
[file, analyze] = ExptList(datasetfile);


%Import variables from the Index sheet
if exist(file.CL)
    calledfile=file.CL;
else
    calledfile=file.CR;
end

[pathstr, name, ext] = fileparts(calledfile);

numworms = importfileXLS(calledfile, 'Index', 'A2');
[num, identity] = xlsread(calledfile, 'Index', 'A1');
[num, wormUIDs] = xlsread(calledfile, 'Index', strcat('B2:B', num2str(1+numworms))); 
cmperdeg=xlsread(calledfile, 'Index', strcat('C2:C', num2str(1+numworms)))';
gradientmax=xlsread(calledfile, 'Index', strcat('D2:D', num2str(1+numworms)))';
gradientmaxAU=xlsread(calledfile,'Index',strcat('E2:E', num2str(1+numworms)))';
tracklength = importfileXLS(calledfile, 'Index', 'A5');

pixelspercm.CL=179; 
pixelspercm.CR=209;
% The above values are only for the thermotaxis setup. Eventually could make this not hardwired

%% Import CR tracks
if analyze.CR>0
   [tracks.CR.xvals, tracks.CR.yvals]=ImportTracks(file.CR, wormUIDs, tracklength, numworms);
end

%% Import CL tracks
if analyze.CL>0
    if analyze.CR>0
        [tracks.CL.xvals, tracks.CL.yvals]=ImportTracks(file.CL, wormUIDs, tracklength, numworms, tracks.CR.xvals);
    else
        [tracks.CL.xvals, tracks.CL.yvals]=ImportTracks(file.CL, wormUIDs, tracklength, numworms); 
    end
end



%% Analysis
% Okay, if there are 2 cameras, the pixel values for each worm have been
% imported. The next step is to get those pixel values into a common value
% (b/c both cameras have different pixel-to-cm ratios). After that's done,
% the final CamR value and the first CamL value will be the same point in
% time, so I can use that to stich together the tracks.

if analyze.CL>0 && analyze.CR>0 % Both CamL and CamR
    [tracks.CL.xvalscm, tracks.CL.yvalscm,  pathlength, distanceratio, meanspeed, instantspeed, mergedtracks.xvals, mergedtracks.yvals]=AnalyzeTracks(tracks.CL.xvals, tracks.CL.yvals, pixelspercm.CL, tracks.CR.xvals, tracks.CR.yvals, pixelspercm.CR, numworms, tracklength);
    [tempxvals, plotyvals, plotxvalscm, starttemp, finaltemp, finaltempdiff, finaldistdiff]= TrackTempConvert (mergedtracks.xvals, mergedtracks.yvals, cmperdeg, gradientmax, gradientmaxAU);
elseif analyze.CL>0 && analyze.CR<1 % Only CamL
    [tracks.CL.xvalscm, tracks.CL.yvalscm,  pathlength, distanceratio, meanspeed, instantspeed]=AnalyzeTracks(tracks.CL.xvals, tracks.CL.yvals, pixelspercm.CL);
    [tempxvals, plotyvals, plotxvalscm, starttemp, finaltemp, finaltempdiff, finaldistdiff]= TrackTempConvert (tracks.CL.xvalscm, tracks.CL.yvalscm, cmperdeg, gradientmax, gradientmaxAU);
elseif analyze.CL<1 && analyze.CR>0 % Only CamR
    [tracks.CR.xvalscm, tracks.CR.yvalscm,  pathlength, distanceratio, meanspeed, instantspeed, mergedtracks.xvals, mergedtracks.yvals]=AnalyzeTracks([], [], pixelspercm.CL, tracks.CR.xvals, tracks.CR.yvals, pixelspercm.CR, numworms, tracklength);
    [tempxvals, plotyvals, plotxvalscm, starttemp, finaltemp, finaltempdiff, finaldistdiff]= TrackTempConvert (mergedtracks.xvals, mergedtracks.yvals, cmperdeg, gradientmax, gradientmaxAU);
end

%% Calculate mean speed for specific thermal bins, if desired
answer = questdlg('Do you want to calculate speed over a subset of the track?', 'Optional Analysis: Binned Mean Speed', 'Yes');
binnedspeed = [];
switch answer
    case 'Yes'
        binnedspeed = BinnedAnalyses(tempxvals, instantspeed)';
    case 'No'
    case 'Cancel'
end


%% Plotting and Saving

TrackPlotter(tempxvals, plotyvals, plotxvalscm, name, starttemp, gradientmax);

saveas(gcf, fullfile(pathstr,strcat(name,'.eps')),'epsc');
csvwrite(fullfile(pathstr,strcat(name, '.csv')), [finaltemp; finaltempdiff; finaldistdiff; distanceratio; meanspeed; binnedspeed]');

disp('Finished Analyzing Worm Tracks!');
end


