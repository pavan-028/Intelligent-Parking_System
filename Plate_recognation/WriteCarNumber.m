%%
% This software allows to detect license plates of the cars in Israel 
% The software performs three main operations: 
% 1.detect Yellow license plate recognition 
% 2.Identification of the numbers on the plate  
% 3.And implementation of the  correlation between 
%    the numbers on the plate and those stored licensing area

% Software were written by Oren Berkovich 
% August 2014 
%Email:orenber@hotmail.com



close all
clear all
clc

quest = questdlg('Open .*xls File or New .*xls Data File? ','Save Plate Number Data','Open File','New File','New File');
 switch quest
     case 'Open File'
         [FileName] = uigetfile('*.xls','Select the xls File to open data plate numbers');
         
         fprintf('Open %s  file\n Please wait...\n',FileName)
         [num,HistoryData]  =  xlsread(FileName);
          
         fprintf('Done!...\n')
     case 'New File'
         [FileName] = uiputfile('*.xls','Save new xls file','Cardata.xls');
         headline={'Date','Image Process duration','Plate Number'};
         
         fprintf('Write to %s  file\n Please wait...\n',FileName)
          xlswrite(FileName, headline, 1, 'A1')
         [num,HistoryData]  =  xlsread(FileName);
         fprintf('Done!...\n')
 end
clc
fprintf('Start \n Select image file to locate car plate\n')
%%
e=1;
n=0;
 
while isnumeric(e)==1
    pause(5)
    try
        close all;
        
    [plat_number]=Recar;
    if ischar(plat_number)==1
    n=n+1;
    stamp(n)=toc;%#ok<SAGROW>
    p(n,:)= datestr(clock);%#ok<SAGROW>
    q(n,:)=plat_number; %#ok<SAGROW>
    else
        break
    end
 
    catch err
        err.message
        break
   end
end

%% update xls file
try
datetime=cellstr(cast(p,'char'));
car=cellstr(cast(q,'char'));
st=cellstr(num2str(stamp'));
 
D =cat(2,datetime,st,car);
hisize=size(HistoryData);

fprintf('\nUpdate  %s  file\n Please wait...\n',FileName)
xlswrite(FileName, D, 1, ['A' num2str(hisize(1)+1)])
catch err
     err.message
end
fprintf('Good by...\n')