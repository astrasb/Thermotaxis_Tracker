function [maxdisplacement pathlength meanspeed instantspeed] = displace(pt,xvals, yvals)
%displace Calculates the euclidean distance between a two sets of x/y
%coordinates. Specifically written to calculate the distance between a series of coordinates and a starting point.
%   Inputs:
%   pt = starting coordinates, in the shape of [x,y]
%   xvals = x-coordinates
%   yvals = y-coordinates
%   Outputs:
%   maxdisplacement = max(displacement)
%   displacement = displacement from starting point for each x/y-coordinate
%   in xvals/yvals.
%   travelpath = distance traveled by the worm on each step
%   pathlength = Total distance (in cm) traveled by each worm

%   Created by Astra S. Bryant, Dec 31, 2017

ptx= repmat(pt(1,:),size(xvals,1),1);
pty= repmat(pt(2,:),size(xvals,1),1);
displacement= sqrt((xvals-ptx).^2+(yvals-pty).^2);
maxdisplacement=max(displacement);

osx = xvals(2:end,:); %x vals offset by one time point
osy = yvals(2:end,:); %y vals offset by one time point
hypotenuses = sqrt((osx - xvals(1:(size(xvals,1)-1),:)).^2+ (osy - yvals(1:(size(yvals,1)-1),:)).^2);
meanspeed = mean((hypotenuses./2)*10, 'omitnan');%mm/second. This assumes that the sampling frequency is 1 frame/2 seconds. 
instantspeed=(hypotenuses./2)*10;%mm/second. This assumes that the sampling frequency is 1 frame/2 seconds. 

tempx=xvals(2:end,:);
tempy=yvals(2:end,:);
travelpath = sqrt((xvals(1:size(tempx,1),:)-tempx).^2+(yvals(1:size(tempy,1),:)-tempy).^2);
pathlength=sum(travelpath, 1, 'omitNan'); %Total distance (in cm) traveled by each worm

end

