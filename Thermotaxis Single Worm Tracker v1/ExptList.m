function [file, analyze] = ExptList(datasetfile)
%Generates a GUI for selecting worm tracks for anaylsis by Manual_WormTracks.m


[num, txt]=xlsread(datasetfile);
fileIDs = txt(2:end,1);
[S, V]= listdlg('PromptString','Select a Dataset:','SelectionMode', 'single', 'ListString', fileIDs);
S=S+1; %account for column headers in xlsx file

file.CL=txt{S,2};

if ~isempty(txt{S,2})
    analyze.CL=1;
    file.CL=txt{S,2};
else
    analyze.CL=0;
end

if ~isempty(txt{S,3})
    analyze.CR=1;
    file.CR=txt{S,3};
else
    analyze.CR=0;
end


end

