function [] = TrackPlotterCT(xvals,yvals,name)
%TrackPlotterCT.m Modular function for plotting worm tracks in a chemotaxis
%setup.
%  Created Feb 1, 2018 by Astra S. Bryant

colormap(linspecer);
plot(xvals, yvals);
axis([min(min(floor(xvals)))-1 max(max(ceil(xvals)))+1 min(min(floor(yvals)))-1 max(max(ceil(yvals)))+1]);
ylabel('Distance (cm)'); xlabel('Distance (cm)');
title(name);


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
