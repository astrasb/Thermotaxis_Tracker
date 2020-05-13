function [binnedspeed]= BinnedAnalyses (tempxvals, instantspeed);

%Catch-all function for calculating analyses values based on subsets of the
%data - basically for when we only want to analyze a specific portion of
%the thermal gradient.

%v1.0 written 5/2/18 by A.S.B. to analyze instantaneous speed of iL3s at
%different points along a thermal gradient
answer = inputdlg({'Upper bound:','Lower bound:'}, 'Input boundaries of thermal bin',[1 35],{'27','25'});
hibound = str2num(answer{1});
lobound =str2num(answer{2});
temps=tempxvals(2:end,:);
Index=(temps>hibound | temps<lobound);
tempbin=instantspeed;
tempbin(Index)=NaN;
binnedspeed=mean(tempbin,'omitnan')';
