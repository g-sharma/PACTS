% create a handle for all the parameters.
% 

clear
P.TA_rows = 256;
P.TA_col = 256;
P.TA_slices = 4;
P.TAtP = 51;
P.samplTime = 1.8; 
P.upSamptime = 10;
P.aifscaleF = 1;
P.curvS = 5;
P.aifR = 1.5;
P.aifb = 3;
P.timevec = (0:(P.samplTime/P.upSamptime):50);
P.aifCBV=7; %have to use variable
P.MTT = 7;
P.resD = 3;
P.aifScale=1;
% [t1,t2] = Convfun(P);
tP = size(P.timevec,2);

nR = 256; %number of rows in array
nC = 256; %number of rows in column
nZ = 4;   %number of slices



tileArray = double(zeros(nR,nC,nZ,P.TAtP));
tileArray(:,:,:,:)= -8;
tRC = 7; 

% if its
hpadding=8/2;

%lets call the tile create function
P.aifV = phantom_aif(P);
[ctc_array,cbv_map,cbf_map,delay_map,mtt_map] = tile_create(tileArray,tRC,hpadding,P);

%converting signal to intesity.

Sbase = 1;
AIFpeak = max(P.aifV);
k = ((40 * Sbase)/100  / exp(- AIFpeak));


signal_data = double(zeros(size(ctc_array)));

signal_data(ctc_array ~= -8) = Sbase * exp(- ctc_array(ctc_array~=-8)./k);
signal_data(ctc_array == -8) = 0;
ctc_array(ctc_array == -8) = 0;

% surfer4d(permute(aif_array,[1 2 4 3]));

% surfer4d(permute(cbv_map,[1 2 3]));
% surfer4d(permute(cbf_map,[1 2 3]));
% surfer4d(permute(delay_map,[1 2 3]));


% surfer4d(permute(signal_data,[1 2 4 3]));
signal_data = uint16(round(signal_data .* 65535)); %what if I change my base. 
write_to_dcm(signal_data);









