function  write_to_dcm( intensity_data,P)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% understanding zposition is very important in writing to dicom
% Every slice will have the same position at every time point
% Now if we have 51 time point. We need 51 locations for every slice
% of the volume

zposition = [1:size(intensity_data,3)] * 0.8;
InstanceNumber=0; %Chronological number when the slice is captured.

dvec_start=now;
starttime_str=datestr(dvec_start,'yyyymmddHHMMSS.FFF');


% 
% 
% 
% %secs_today=s2n(starttime(9:10))*60*60+s2n(starttime(11:12))*60+s2n(starttime(13:end));

dinfo.seriesUID = dicomuid;
dinfo.studyUID= dicomuid;
dinfo.FrameOfReferenceUID=dicomuid
dinfo.SeriesInstanceUID=dicomuid;
c_datetime=datestr(dvec_start,'yyyymmddHHMMSS.FFF');

cdate=c_datetime(1:8);
ctime=c_datetime(9:end);
 
dinfo.StudyTime=ctime; 
dinfo.StudyDate=cdate;
dinfo.SeriesNumber=1;
dinfo.SeriesTime=ctime;
dinfo.SeriesDate=cdate;
dinfo.SeriesDescription='SIMUPERF';
dinfo.StudyID='SIMUPERF-STUDYID';
dinfo.StudyDescription='SIMUPERFSTUDY';
dinfo.PatientID='SIMUSET';
dinfo.PatientName='SIMUSET';
dinfo.ReferringPhysicianName='GSHARMA';
dinfo.AcquisitionNumber=1;

dinfo.SliceThickness=5;

if P.Modal == 2
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
if P.Modal == 1
    system('mkdir -p ~/PACTS/MR/RAW/');
    foldername='~/PACTS/MR/RAW/';
elseif P.Modal ==2
    system('mkdir -p ~/PACTS/CT/RAW/');
    foldername='~/PACTS/MR/RAW/';
end   
 

filesepcdate = cdate;
SAMPLINGTIME = P.samplTime;

dateS = gen_dateTime(SAMPLINGTIME,size(intensity_data,4),size(intensity_data,3))


for everytP = 1:size(intensity_data,4)
   % This is Dr Christen hardwork, I need to understand the timing thing.
%    c_datetime=datestr(addtodate(dvec_start,SAMPLINGTIME*1000.0*(everytP-1),'millisecond'),'yyyymmddHHMMSS.FFF');
%    
%    
%    cdate=c_datetime(1:8);
%    ctime=c_datetime(9:end);
   
   for everyVSlice = 1:size(intensity_data,3)
         c_datetime=datestr(dateS(everytP,everyVSlice),'yyyymmddHHMMSS.FFF')
         cdate=c_datetime(1:8);
         ctime=c_datetime(9:end);
        
         dinfo.SliceLocation=zposition(everyVSlice);
         InstanceNumber=InstanceNumber+1;
         dinfo.InstanceNumber=InstanceNumber;
         dinfo.ContentTime=ctime;
         dinfo.ContentDate=cdate;
         
         if P.Modal == 1
            dinfo.RepetitionTime=P.samplTime*1000;
            dinfo.EchoTime=40;
         end
         
         dinfo.AcquisitionTime=ctime;
         dinfo.AcquisitionDate=cdate;
        
         %assuming this is not run crossing midnight..
         %TODO  WE ALSO NEED PIXEL SPACING
         dinfo.ImagePositionPatient=[-100 -100 zposition(everyVSlice)];
         dinfo.ImageOrientationPatient=[1 0 0 0 1 0];
             
         % Once we have all the header info, then we can write in to the dicom file.    
         %dicomwrite(intensity_data(:,:,everyVSlice,everytP),[ foldername filesepcdate '_' num2str( (everyVSlice-1)*size(intensity_data,4)+everytP) '.dcm'],'ObjectType','MR Image Storage',dinfo);
%        dicomwrite(intensity_data(:,:,everyVSlice,everytP),[ foldername filesepcdate '_' num2str( (everyVSlice-1)*size(intensity_data,4)+everytP) '.dcm'],'ObjectType','MR Image Storage',dinfo);
         %dicomwrite(intensity_data(:,:,everyVSlice,everytP),[ foldername filesepcdate '_' num2str(InstanceNumber) '.dcm'],'ObjectType','MR Image Storage',dinfo);
         
         
         if P.Modal == 1
             dicomwrite(intensity_data(:,:,everyVSlice,everytP),[ foldername filesepcdate '_' num2str(InstanceNumber) '_' 'MR' '.dcm'],'ObjectType','MR Image Storage',dinfo);
         elseif P.Modal == 2
             dicomwrite(intensity_data(:,:,everyVSlice,everytP),[ foldername filesepcdate '_' num2str(InstanceNumber) '_' 'CT' '.dcm'],'ObjectType','CT Image Storage',dinfo);
         end
         
         disp(['Wrote ' num2str(InstanceNumber)])
        
   end
end

end
% Courtsey Dr Christensen..... 
%
% zposs=[1:size(int_data,4)]*(10)-10;
% InstanceNumber=0;
% 
% 
% dvec_start=now;
% starttime_str=datestr(dvec_start,'yyyymmddHHMMSS.FFF');
% 
% 
% 
% %secs_today=s2n(starttime(9:10))*60*60+s2n(starttime(11:12))*60+s2n(starttime(13:end));
% dinfo_c.seriesUID = dicomuid;
% dinfo_c.studyUID= dicomuid;
% dinfo_c.SeriesInstanceUID=dicomuid;
% c_datetime=datestr(dvec_start,'yyyymmddHHMMSS.FFF');
% 
% cdate=c_datetime(1:8);
% ctime=c_datetime(9:end);
% dinfo_c.StudyTime=ctime;
% dinfo_c.StudyDate=cdate;
% dinfo_c.SeriesNumber=1;
% dinfo_c.SeriesTime=ctime;
% dinfo_c.SeriesDate=cdate;
% dinfo_c.SeriesDescription='SIMUPERF';
% dinfo_c.StudyID='SIMUPERF-STUDYID';
% dinfo_c.StudyDescription='SIMUPERFSTUDY';
% dinfo_c.PatientID='SIMUSET';
% dinfo_c.PatientName='SIMUSET';
% dinfo_c.ReferringPhysicianName='SORENC';
% dinfo_c.AcquisitionNumber=1;
% dinfo_c.SliceThickness=10;
% dinfo_c.KVP=80;
% dinfo_c.AccessionNumber='1';
% dinfo_c.PatientSex='M';
% dinfo_c.PatientBirthDate='20120516';
% dinfo_c.Manufacturer='RMH';
% dinfo_c.RescaleIntercept=-1024;
% dinfo_c.RescaleSlope=1;
% dinfo_c.PixelSpacing=[0.8 0.8];
% dinfo_c.PatientPosition='HFS';
% 
% 
% for iphase=1:size(int_data,3)
%    %dinfo.AcquisitionTime='000000'  ;%AcquisitionTime+SAMPLINGTIME*1000;
%    %tt=sprintf('%06.3f',(iphase-1)*SAMPLINGTIME);
%    %dvec_delta=datenum(tt,'MMSS.FFF'   );
% 
% 
%    c_datetime=datestr(addtodate(  dvec_start
% ,SAMPLINGTIME*1000.0*(iphase-1),'millisecond'),'yyyymmddHHMMSS.FFF');
% 
%    cdate=c_datetime(1:8);
%    ctime=c_datetime(9:end);
% 
%    %dinfo.AcquisitionTime=sprintf('%13.6f',str2num(newtime(9:end)));
%    for islice=1:size(int_data,4)
% 
% 
% 
% 
% 
%        dinfo_c.SliceLocation=zposs(islice);
%        InstanceNumber=InstanceNumber+1;
% 
%        dinfo_c.InstanceNumber=InstanceNumber;
% 
%        dinfo_c.ContentTime=cdate;
%        dinfo_c.ContentDate=ctime;
% 
%        dinfo_c.AcquisitionTime=ctime;
%        dinfo_c.AcquisitionDate=cdate;
% 
% 
% 
%        %assuming this is not run crossing midnight..
%        %TODO  WE ALSO NEED PIXEL SPACING
%        dinfo_c.ImagePositionPatient=[-100 -100 zposs(islice)];
%        dinfo_c.ImageOrientationPatient=[1 0 0 0 1 0];
%        dinfo_c.SliceLocation=zposs(islice);
% % 
%        dicomwrite(int_data(:,:,iphase,islice),[ foldername filesep
% cdate '_' num2str( (islice-1)*size(int_data,3)+iphase  ) '.dcm'],
% 'ObjectType','CT Image Storage',dinfo_c);
%        disp(['Wrote ' num2str(InstanceNumber)])
%    end
% 
% 
% end
