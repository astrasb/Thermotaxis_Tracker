function [] = TrackPlotter(xvals,yvals, xvalscm,name, starttemp, gradientmax)
%TrackPlotter.m Modular function for plotting worm tracks.
%  Created Dec 30, 2017 by Astra S. Bryant

colormap(linspecer);

plot(xvals, yvals);
axis([min(floor(starttemp))-1 max(ceil(gradientmax)) -12 1]);
axis([31 41 -12 1]);
%axis([25 27 -12 1]);
%axis([30 41 -12 1]);
ylabel('Distance (cm)'); xlabel('Temperature (C)');
title(name);

global plotflag
if ~isempty(plotflag)
    plot(xvalscm, yvals);
    if min(floor(min(xvalscm)))+12 > max(ceil(max(xvalscm)))
        axis([min(floor(min(xvalscm)))-1 min(floor(min(xvalscm)))+12 -10 3]);
    else
        axis([min(floor(min(xvalscm)))-1 max(ceil(max(xvalscm))) -12 1]);
    end
ylabel('Distance (cm)'); xlabel('Distance (cm)');
end

% figure;
% plot(xvalscm, yvals);
% axis([min(floor(min(xvalscm)))-1 min(floor(min(xvalscm)))+12 -12 1]);
% ylabel('Distance (cm)'); xlabel('Distance (cm)');
% title(name);

end

%% Alternative Figure
% figure
% colormap(linspecer);
% subplot(1,2,1);
% hold on
% for i=1:numworms
%     xx=tracks.CL.temp(:,i)';
%     yy=tracks.CL.yvalscm(:,i)';
%     rainbowplot(xx,yy*-1);
% end
% hold off
% axis([28 34 -10 0]);
% ylabel('Distance (cm)'); xlabel('Temperature (C)');
% subplot(1,2,2);
% plot(tracks.CL.temp, tracks.CL.yvalscm*-1);
% %axis([29 34 min(min(tracks.CL.yvalscm*-1))-2 max(max(tracks.CL.yvalscm*-1))+2])
% axis([28 34 -10 0]);
% ylabel('Distance (cm)'); xlabel('Temperature (C)');
