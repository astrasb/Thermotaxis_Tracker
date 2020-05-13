function [C1xvalscm, C1yvalscm, pathlength, distanceratio, meanspeed, instantspeed, C1and2xvalscm, C1and2yvalscm] = AnalyzeTracks(C1xvals, C1yvals, C1ppcm, C2xvals, C2yvals, C2ppcm, numworms, tracklength)
% AnalyzeTracks.m Modular function for taking worm tracks, represented as
% x-, y-coordinates in pixels, and turning them in to cm values. Will take
% both a single camera input or a dual camera input
%   Inputs: C1xvals, C1yvals = x- and y- coordinates from a primary camera
%   C1ppcm = pixels per cm for the primary camera Optional Inputs: C2xvals,
%   C2yvals = x- and y- coordinates from a secondary camera C2ppcm = pixels
%   per cm for the secondary camera Outputs: C1xvalscm, C2yvalscm,
%   C1and2xvalscm, C1and2yvalscm, maxdisplacement, displacement,
%   travelpath, pathlength
%
%   Created by Astra S. Bryant, Dec 31, 2017
if isempty(C1xvals)
    C1xvals=NaN(tracklength, numworms);
    C1yvals=NaN(tracklength,numworms);
end

C1xvalscm=C1xvals./C1ppcm;
C1yvalscm=C1yvals./C1ppcm;

if exist('C2xvals')
    C2xvalscm=C2xvals./C2ppcm;
    C2yvalscm=C2yvals./C2ppcm;
    
    %Calculate offset of C2 values. Step 1: Give a fake value if the C2
    %column is empty
    for i=1:numworms
        if all(isnan(C2xvalscm(:,i)))
            C2xvalscm(1:tracklength,i)=0;
            C2yvalscm(1:tracklength,i)=0;
        end
    end
    %Step 2: Find the last NaN value in C2 x values
    B = ~isnan(C2xvalscm);
    Indices = arrayfun(@(x) find(B(:, x), 1, 'last'), 1:size(C2xvalscm, 2));
    lastC2point.xvals = arrayfun(@(x,y) C2xvalscm(x,y), Indices, 1:size(C2xvalscm, 2));
    firstC1point.xvals = C1xvalscm(1,:);
    for i=1:numworms
        if ~isnan(firstC1point.xvals(i))
            C2offset.xvals(i) = firstC1point.xvals(i)-lastC2point.xvals(i);
        else
            C2offset.xvals(i) = 2592/C1ppcm; % The value here is the size of a single image in pixels. Need to add that value to the CR image numbers
        end
    end
    C2offset.xvals = repmat(C2offset.xvals, tracklength, 1);
    C2.xvalscmoffset= C2offset.xvals + C2xvalscm;
    
    %Step 2: Repeat for y values
    B = ~isnan(C2yvalscm);
    Indices = arrayfun(@(x) find(B(:, x), 1, 'last'), 1:size(C2yvalscm, 2));
    lastC2point.yvals = arrayfun(@(x,y) C2yvalscm(x,y), Indices, 1:size(C2yvalscm, 2));
    firstC1point.yvals = C1yvalscm(1,:);
    for i=1:numworms
        if ~isnan(firstC1point.yvals(i))
            C2offset.yvals(i) = firstC1point.yvals(i)-lastC2point.yvals(i); %unlike the x values, i think this doesn't require compensation - it'll just be a smidge offset
        else
             C2offset.yvals(i) =0;
        end
    end
    
    C2offset.yvals = repmat(C2offset.yvals, tracklength, 1);
    C2.yvalscmoffset= C2offset.yvals + C2yvalscm;
    
    C1and2xvalscm = cat(1,C2.xvalscmoffset, C1xvalscm);
    C1and2yvalscm = cat(1,C2.yvalscmoffset, C1yvalscm);
    %Note, these merged files sill have NaN values in them. But they won't
    %get plotted so it doesn't matter.
end

%% Calculate path and max displacement for generating a distance ratio, in combination with the maximum distance moved.
% I currently don't need the travelpath and pathlength data, but it might
% come in handy later.
if exist('C1and2xvalscm')
[maxdisplacement pathlength meanspeed instantspeed]= displace([C1and2xvalscm(1,:);C1and2yvalscm(1,:)], C1and2xvalscm, C1and2yvalscm);
else   
[maxdisplacement pathlength meanspeed instantspeed]= displace([C1xvalscm(1,:);C1yvalscm(1,:)], C1xvalscm, C1yvalscm);
end

distanceratio=pathlength./maxdisplacement; %Calculation of distance ratio, as defined in Castelletto et al 2014. Total distance traveled/maximum displacement.
end




