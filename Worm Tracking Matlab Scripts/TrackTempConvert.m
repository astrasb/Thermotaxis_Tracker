function [tempxvals, plotyvals, plotxvalscm, starttemp, finaltemp, finaltempdiff, finaldistdiff] = TrackTempConvert(xvalscm, yvalscm, cmperdeg, gradientmax, gradientmaxAU)
%TrackTempConvert.m Modular function that relates x/y coordinates of
%tracked worms (in cm) to movement within a given thermal gradient
% This function also calculates useful data, like the final temperature
% reached by each worm, and the total temperature distance moved
%   Inputs:
%   xvalscm: tracks in cm
%   cmperdeg: number of cm that make up 1 degree Celcius
%   gradientmax: maximum temperature on the gradient
%   gradientmaxAU: a "fudge factor" that accounts for the physical location
%       of the edge of the worm arena

%   Outputs:
%   tempxvals = movement of the worm along the x-axis of the plate,
%   translated into degrees Celcius.
%   plotyvals, starttemp, finaltemp finaltempdiff, finaldist, 
%   totaldist = % total cm distance traveled by the worm
%
%   Created by Astra S. Bryant, Dec 31, 2017
clear global plotflag

tracklength=size(xvalscm,1);

if isempty(cmperdeg)
    cmperdeg= ones(1, size(gradientmax,2))*-1;
    gradientmaxAU = zeros(1,size(gradientmax,2));
    gradientmax = zeros(1,size(gradientmaxAU,2));
    global plotflag
    plotflag=1; %triggers a flag so when it comes time to plot, the axis will be labeled in cm, not degrees
end
   
   cmperdeg=repmat(cmperdeg, tracklength,1);
   gradientmax=repmat(gradientmax,tracklength,1);
   gradientmaxAU=repmat(gradientmaxAU,tracklength,1);

   tempxvals=((gradientmaxAU -(xvalscm./cmperdeg))+gradientmax);
   plotyvals= yvalscm*-1;
    plotxvalscm=xvalscm*-1;
   
   %Calculate Total/Final Temperature and Total/Final Distance Reached by the Worm
   B = ~isnan(tempxvals);
    Indices = arrayfun(@(x) find(B(:, x), 1, 'last'), 1:size(tempxvals, 2));
    finaldist = arrayfun(@(x,y) xvalscm(x,y), Indices, 1:size(xvalscm,2));
    finaldistdiff = abs(xvalscm(1,:)-finaldist); % difference between the final worm position and the starting postition - normalized movement along the x-axis
    
    
    finaltemp = arrayfun(@(x,y) tempxvals(x,y), Indices, 1:size(tempxvals, 2));
    starttemp=tempxvals(1,:);
    finaltempdiff=finaltemp-starttemp;
    
   
end



