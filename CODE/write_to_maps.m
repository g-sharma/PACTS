function  write_to_maps(data,text,modal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% understanding zposition is very important in writing to dicom
% Every slice will have the same position at every time point
% Now if we have 51 time point. We need 51 locations for every slice
% of the volume

zposition = [1:size(data,3)] * 0.8;
InstanceNumber=0; %Chronological number when the slice is captured.

dvec_start=now;
starttime_str=datestr(dvec_start,'yyyymmddHHMMSS.FFF');

% %secs_today=s2n(starttime(9:10))*60*60+s2n(starttime(11:12))*60+s2n(starttime(13:end));
dinfo.seriesUID = dicomuid;
dinfo.studyUID= dicomuid;
dinfo.SeriesInstanceUID=dicomuid;
c_datetime=datestr(dvec_start,'yyyymmddHHMMSS.FFF');

cdate=c_datetime(1:8);
ctime=c_datetime(9:end);
 
dinfo.StudyTime=ctime; 
dinfo.StudyDate=cdate;
dinfo.SeriesNumber=1;
dinfo.SeriesTime=ctime;
dinfo.SeriesDate=cdate;
dinfo.SeriesDescription=text;
dinfo.StudyID=text;
dinfo.StudyDescription=text;
dinfo.PatientID='SIMUSET';
dinfo.PatientName='SIMUSET';
dinfo.ReferringPhysicianName='GSHARMA';
dinfo.AcquisitionNumber=1;
dinfo.SliceThickness=5;
dinfo.SliceThickness=5;

if modal == 2
    dinfo.KVP=80;
end



dinfo.AccessionNumber='1';
dinfo.PatientSex='M';
dinfo.PatientBirthDate='20120516';
dinfo.Manufacturer='RMH';
dinfo.RescaleIntercept=0;
dinfo.RescaleSlope=1;
dinfo.PixelSpacing=[0.8 0.8];
dinfo.PatientPosition='HFS';

if modal == 1
    system('mkdir -p ~/PACTS/MR/MAPS/');
    foldername='~/PACTS/MR/MAPS/';
elseif modal ==2
    system('mkdir -p ~/PACTS/CT/MAPS/');
    foldername='~/PACTS/CT/MAPS/';
end


filesepcdate = cdate;
yyyy=str2num(datestr(now,'yyyy') );
MM=str2num( datestr(now,'mm'));
DD=str2num( datestr(now,'DD'));
hh=str2num( datestr(now,'hh'));
mm=str2num( datestr(now,'MM'));
ss=str2num( datestr(now,'SS'));

% c_datetime = datenum(yyyy,MM,DD,hh,mm,ss);
% for everytP = 1:size(intensity_data,4)
%    % This is Dr Christen hardwork, I need to understand the timing thing.
% %    c_datetime=datestr(addtodate(dvec_start,SAMPLINGTIME*1000.0*(everytP-1),'millisecond'),'yyyymmddHHMMSS.FFF');
% %    
% %    
% %    cdate=c_datetime(1:8);
% %    ctime=c_datetime(9:end);
   
   for everyVSlice = 1:size(data,3)
         
         cdate=c_datetime(1:8);
         ctime=c_datetime(9:end);
        
         dinfo.SliceLocation=zposition(everyVSlice);
         InstanceNumber=InstanceNumber+1;
         dinfo.InstanceNumber=InstanceNumber;
         dinfo.ContentTime=ctime;
         dinfo.ContentDate=cdate;
        
         dinfo.AcquisitionTime=ctime;
         dinfo.AcquisitionDate=cdate;
        
         %assuming this is not run crossing midnight..
         %TODO  WE ALSO NEED PIXEL SPACING
         dinfo.ImagePositionPatient=[-100 -100 zposition(everyVSlice)];
         dinfo.ImageOrientationPatient=[1 0 0 0 1 0];
             
         % Once we have all the header info, then we can write in to the dicom file.    
         %dicomwrite(intensity_data(:,:,everyVSlice,everytP),[ foldername filesepcdate '_' num2str( (everyVSlice-1)*size(intensity_data,4)+everytP) '.dcm'],'ObjectType','MR Image Storage',dinfo);
%        dicomwrite(intensity_data(:,:,everyVSlice,everytP),[ foldername filesepcdate '_' num2str( (everyVSlice-1)*size(intensity_data,4)+everytP) '.dcm'],'ObjectType','MR Image Storage',dinfo);
         %dicomwrite(data(:,:,everyVSlice),[ foldername dinfo.SeriesDescription '_' filesepcdate '_' num2str(InstanceNumber) '.dcm'],'ObjectType','MR Image Storage',dinfo);
         
         if modal == 1
            dicomwrite(data(:,:,everyVSlice),[foldername dinfo.SeriesDescription '_' filesepcdate '_' num2str(InstanceNumber) '.dcm'],'ObjectType','MR Image Storage',dinfo);
         elseif modal==2
            dicomwrite(data(:,:,everyVSlice),[foldername dinfo.SeriesDescription '_' filesepcdate '_' num2str(InstanceNumber) '.dcm'],'ObjectType','CT Image Storage',dinfo); 
         end
         
         
         disp(['Wrote ' num2str(InstanceNumber)])
        
   end
% end

end
