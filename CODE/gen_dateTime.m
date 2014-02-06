function dateS = gen_dateTime(sampT,timePoints,nSlices)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%get todays date

mynow=now;

%put it into a serial form where we can


%we will use the datenum command to generate a number for each timepoint
%and then the datestr command to wite it out as we like

yyyy=str2num(datestr(mynow,'yyyy') );
MM=str2num( datestr(mynow,'mm'));
DD=str2num( datestr(mynow,'DD'));
hh=str2num( datestr(mynow,'hh'));
mm=str2num( datestr(mynow,'MM'));
ss=str2num( datestr(mynow,'SS'));

% mydelays=0:sampT/nSlices:sampT*timePoints-(sampT/nSlices);    % 0 to 2 s in 100 ms increments as example
% 
% %we can just add to seconds - the datenum will take care of conversion
% 
% for k=mydelays
%    dnum=datenum(yyyy,MM,DD,hh,mm,ss+k);
%    dstr=datestr(dnum,'yyyyMMDD hhmmss.FFF')
% 
% end

samp_step = sampT / nSlices;



% Stating sampling point from:
arSP = 1;

dateS = zeros(timePoints,nSlices);

% interleaved timing, which we are using.
for i = 1 : timePoints
      for j = 1:2:nSlices
        dnum=datenum(yyyy,MM,DD,hh,mm,ss+arSP)
        dateS(i,j)=dnum;
        arSP = arSP + samp_step;
     end
     
     for j = 2:2:nSlices
         dnum=datenum(yyyy,MM,DD,hh,mm,ss+arSP);
         dateS(i,j)=dnum;
         arSP = arSP + samp_step;
     end
 end

end
      
