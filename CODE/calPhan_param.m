
function [ ] = calPhan_param(P)

    % creating a tiled array
    % further I am putting a value of -8 in all of the initialized tile
    % array
    % AIF is calculated by function Soren provided me
    % Questions related to this is
    % What way is this to calculate AIF, is there any other way as Brad was
    % discussing.Should we use it. Needs to discuss this little thing with
    % soren
    
    
% P is structure, which contains 
%       TA_rows:  Tiled Array row size
%         TA_col: Tile Array column size
%      TA_slices: Tile Array how many slices in each frame
%           TAtp: Total number of Time points
%      samplTime: Sampling time for phantom data
%     upSamptime: Upsampling time
%      aifscaleF: Scale factor for AIF
%          curvS: Curve shift value for AIF
%           aifR: AIF R factor (needs to understand it)
%           aifb: AIF b factor (needs to undestand it)
%        timevec: Time length for total time points
%            CBV: Cerebral blood volume
%            MTT: Mean transist time
%           resD: residual function
%           hpad: Total padding between two conszective tiles, row and
%           column wise
%            tRC: Number of rows and columns.
%       baseline: baseline value(round(P.curvS/P.samplTime)-1)
%       map: 1 is for sSVD, 2 is for oSVD.
    



%-----------------------------------------
% ONLY FOR TESTING to have minimized change of code.
global writeDicom writeMaps
writeDicom=1;
writeMaps=1;


%------------------------------------------
    tileArray = double(zeros(P.TA_rows,P.TA_col,P.TA_slices,P.TAtp));
    tileArray(:,:,:,:)= -8;
    P.aifV = phantom_aif(P);
    [ctc_array,cbv_map,cbf_map,delay_map,mtt_map,P,codeArray] = tile_create(tileArray,P.tRC,P.hpad/2,P);

    % at this point, we have
    % 1. Tissue concentration , cbv values (.04 .02 simulated one)
    % cbf, mtt and and update P structure.

    %--------------------------------------------------------------------
    %converting concetration values in to Signal
    % Why we are using codeArray
    % Tile consist of padded/empty space, AIF , concentration values
    % code Array has the code for 
    % 1. is Tissue concentration
    % 2. is AIF value
    % 3. empty/padded space

    Sbase = 1;
    AIFpeak = max(P.aifV);
    Tpeak = max(ctc_array(codeArray==1));

    %   k = ((40 * Sbase)/100  / exp(- AIFpeak));
    
    if P.Modal == 1
        k_aif = log(0.3)/-AIFpeak;
        k_tissue = log(0.6)/-Tpeak;
    elseif P.Modal == 2
        vessel_HU=30;
        tissue_HU=30;
    end
    
    
    signal_data = double(zeros(size(ctc_array)));
    %----------------------------------------------------------------------
    %   Multiplaying correct data with the correct peak.

    %   signal_data(ctc_array ~= -8) = Sbase * exp(- ctc_array(ctc_array~=-8)*k);
   
    
   %signal_data(ctc_array == -8) = 0;
   ctc_array(ctc_array == -8) = 0; 
   
   if P.Modal == 1 
        signal_data(codeArray == 1) = Sbase * exp(- ctc_array(codeArray==1)*k_tissue);
        signal_data(codeArray ==2) = Sbase * exp(- ctc_array(codeArray==2)*k_aif);
        signal_data = uint16(round(signal_data .* 4090)); %Soren told me to have this.
        % should I put round or not
        
   elseif P.Modal ==2 
       AIF_PARAMS = [1 5 3 1.5];
       vofDISP=2;   % MTT=X s disp with exponential
       vofMTT=vofDISP;
       vofCBF=1/vofMTT;
       vofDELAY=4;
       
       VOF_value =resgenerator('exponential',P.timevec,AIF_PARAMS,vofMTT,vofCBF,vofDELAY,0);
       VOF_value = VOF_value(1:P.upSamptime:size(VOF_value,2))
       VOF_value = VOF_value(1:P.TAtp);
      
       VOF=VOF_value(1,:);
       
       VOF_peak = max(VOF);
       scale_fac = 200 / VOF_peak;
       
%        simVOF=trapz(VOF)*P.samplTime;
%        VOFarea = 3400;
%        scaling_factor_tissue=VOFarea/simVOF; 
       
       signal_data = ctc_array *scale_fac;
       %signal_data(codeArray ==2) = ctc_array(codeArray == 2) * scale_fac;
       %scale_factor_aif;
       signal_data(codeArray ==1) = signal_data(codeArray ==1) + 30 + 1024;
       signal_data(codeArray ==2) = signal_data(codeArray ==2) + 1024;
       signal_data = uint16((signal_data));
       %signal_data(codeArray == 1) = ctc_array(codeArray == 1) + tissue_HU; % Tissue concentration Area
       %signal_data(codeArray ==2) = ctc_array(codeArray == 2) + vessel_HU;  % AIF value (third slice only one tile)
   end

    %   Removing -8 from the initial value
    
    
    
    

    %% Writing DICOM from raw signal_data
    % 4090 value was decided by me and soren, because DICOM has that value
    % need to discuss again with him: Gagan 28 August 2012

    

    % writing the signal data in to dicoms

    if writeDicom
         write_to_dcm(signal_data,P);
    end


    %% for oSVD (Ona's algorithm)

    %    Now to feed the signal data, we are imitating as third party
    %    Who will read, our DICOM which we have written above.
    %    reading signal data:

    signal_data = cast(signal_data,'double');


    %    reshaping signal_data in to 2d data, to feed it to SVD algorithms
    %    reason: These algorithms are supposed to take 2d input for Tissue
    %    concentration

    signal_data = reshape(signal_data,[],P.TAtp);

    %    Mean Base line
    meanBase = mean(signal_data(:,1:P.baseline),2);

    %    Making meanBase equal to signal_data

    meanBase = repmat(meanBase,[1 P.TAtp]);

    %    Converting signal in to Tissue concentration value
    CTC = -log(signal_data./meanBase);

    CTC =  reshape(CTC,P.TA_rows,P.TA_col,P.TA_slices,P.TAtp);

    %     Calculating AIF from the Tissue concentration.

    exAIF = CTC(19,18,size(CTC,3),:); % calculating AIF from data.
    exAIF = reshape(exAIF,[],size(CTC,4));
    CTC= reshape(CTC,[],size(exAIF,2));

    if P.sSVD == 1
        [sSVD_cbf,sSVD_delay,sSVD_cbv]= mysSVD_easy(CTC,exAIF,0.2,P.samplTime,0);
        create_maps(sSVD_cbf,sSVD_delay,sSVD_cbv,'sSVD_',P)
    end

    if P.oSVD == 1
        [oSVD_cbf,oSVD_delay,oSVD_cbv,rt]= SVD_easy_gagan(CTC,exAIF,0.095,P.samplTime,0);  
        create_maps(oSVD_cbf,oSVD_delay,oSVD_cbv,'oSVD_',P)
    end
    
    CTC =  reshape(CTC,P.TA_rows,P.TA_col,P.TA_slices,P.TAtp); %getting back to 4d from 2d
    
    
    
    
end


function create_maps(cbf,delay,cbv,mname,struc)
    global writeMaps
    cbf = reshape(cbf,struc.TA_rows,struc.TA_col,[]);
    cbv = reshape(cbv,struc.TA_rows,struc.TA_col,[]);
    tmax = reshape(delay,struc.TA_rows,struc.TA_col,[]);
    mtt = cbv./cbf;

    mtt(isnan(mtt))=0;
    tmax(isnan(tmax))=0;
    cbv(isnan(cbv))=0;
    cbf(isnan(cbf))=0;
    
    
%     min_cbf = min(cbf(:));
%     max_cbf = max(cbf(:));
%     cbf = uint16(round(cbf - min_cbf)/(max_cbf - min_cbf)*4090);
% 
%     min_cbv = min(cbv(:));
%     max_cbv = max(cbv(:));
%     cbv = uint16(round(cbv - min_cbv)/(max_cbv - min_cbv)*4090);
% 
%     min_tmax = min(tmax(:));
%     max_tmax = max(tmax(:));
%     tmax = uint16(round(tmax - min_tmax)/(max_tmax - min_tmax)*4090);
%     
%     min_mtt = min(mtt(:));
%     max_mtt = max(mtt(:));
%     mtt = uint16(round(mtt - min_mtt)/(max_mtt - min_mtt)*4090);
    
    
    s1.([mname 'cbf']) = cbf;   %uncomment the lines, If we need to save
    s1.([mname 'cbv'])=cbv;
    s1.([mname 'tmax'])=tmax;
    s1.([mname 'mtt'])=mtt;
    %s1.([mname 'baseline'])=struc.baseline;
    
    %s1.CTC=CTC
    %CTC =  reshape(CTC,P.TA_rows,P.TA_col,P.TA_slices,P.TAtp); %getting back to 4d from 2d
    
    if struc.Modal ==1 
        save(['~/PACTS/MR/MAT/' mname 'maps.mat'],'-struct','s1')
    else
        save(['~/PACTS/CT/MAT/' mname 'maps.mat'],'-struct','s1')
    end
    clear s1

    
    if writeMaps
        write_to_maps(cbv,[mname 'cbv' '_' 'map'],struc.Modal);
        write_to_maps(cbf,[mname 'cbf' '_' 'map'],struc.Modal);
        write_to_maps((mtt),[mname 'mtt' '_' 'map'],struc.Modal);
        write_to_maps(tmax,[mname 'tmax' '_' 'map'],struc.Modal);
    end
  
        
end

%%%%%%%%%%%55

%----------------------------------------------------------------------------
% The below piece of code is written for testing purpose
%  1. Rather than using our method to calculate Concentration time curve
%     I was using Soren's cconverter method.
%     Soren is calculating in different way, which leads to little 
%     deviaton, but insignificant.



%      temp_signal = signal_data;
%      phaseinfo = [1,P.baseline,P.TAtp];
% %    temp_signal = reshape(temp_signal,[],size(temp_signal,4));
%      cmap = cconverter_mat(temp_signal,1,1,phaseinfo,0);
%      cmap = reshape(cmap,P.TA_rows,P.TA_col,P.TA_slices,[]);
%      exAIF_cmap = cmap(19,18,P.TA_slices,:); % calculating AIF from data.
%      exAIF_cmap = reshape(exAIF_cmap,[],P.TAtp);
%      cmap = reshape(cmap,[],size(exAIF_cmap,2));
%      [cbf_cmap,delay_cmap,cbv_cmap]= mysSVD_easy(cmap,exAIF_cmap,0.2,P.samplTime,0);
%      cmap =  reshape(cmap,P.TA_rows,P.TA_col,P.TA_slices,P.TAtp);
%      cbf_cmap = reshape(cbf_cmap,P.TA_rows,P.TA_col,P.TA_slices);
%      cbv_cmap = reshape(cbv_cmap,P.TA_rows,P.TA_col,P.TA_slices);
%      tmax_cmap = reshape(delay_cmap,P.TA_rows,P.TA_col,P.TA_slices);
%      mtt_cmap = cbv_cmap./cbf_cmap;
%      
%      mtt_cmap(isnan(mtt_cmap))=0;
%      tmax_cmap(isnan(tmax_cmap))=0;
%      cbv_cmap(isnan(cbv_cmap))=0;
%      cbf_cmap(isnan(cbf_cmap))=0;
 %--------------------------------------------------------------------------------
 
 %         cbf = reshape(cbf,P.TA_rows,P.TA_col,[]);
%         cbv = reshape(cbv,P.TA_rows,P.TA_col,[]);
%         tmax = reshape(delay,P.TA_rows,P.TA_col,[]);
%         mtt = cbv./cbf;
%      
%         mtt(isnan(sSVD_mtt))=0;
%         tmax(isnan(sSVD_tmax))=0;
%         cbv(isnan(sSVD_cbv))=0;
%         cbf(isnan(sSVD_cbf))=0;
%                 
%         s1.oSVDcbf=cbf
%         s1.oSVDcbv=cbv
%         s1.oSVDtmax=tmax
%         s1.oSVDmtt=mtt
%         s1.oSVDCTC=CTC
%         s1.baseline=P.baseline
%         
%         CTC =  reshape(CTC,P.TA_rows,P.TA_col,P.TA_slices,P.TAtp); %getting back to 4d from 2d
%         save('oSVDmaps.mat','-struct','s1')
%         
%         write_to_maps(cbv,'oSVDcbv_map');
%         write_to_maps(cbf,'oSVDcbf_map');
%         write_to_maps((cbv./cbf),'oSVDMTT_map');
%         write_to_maps(tmax,'oSVDTMAX_map');
