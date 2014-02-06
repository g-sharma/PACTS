
function [tileArray,CBV_map,CBF_map,Delay_map,MTT_map,P,codeArray] = tile_create(tileArray,tRC,hpadding,P)


stepsize = (size(tileArray,1) - rem(size(tileArray,1),tRC))/tRC - (2*hpadding);
seP = rem(size(tileArray,1),tRC)/2;

startR = seP+hpadding+1;
endR = stepsize+startR -1 ;

IstartR = seP+hpadding+1;
IendR = stepsize+startR -1 ;

IstartC=startR;
IendC= endR;

startC=startR;
endC= endR;

%%%%%%%%%%%%%%%%5
% We are keeping CBV constant.
% CBF is being calculated.
% MTT is reduced from left to right in the tiled Array
% All the region which is padded region, should have value of -20
% easy to index.
%%%%%%%%%%%%%%%%%

% P.CBV=7;
% P.MTT = tRC; %Please check the value.
% i_MTT = P.MTT;

CBF_map = double(zeros(size(tileArray,1),size(tileArray,2),size(tileArray,3)));
CBV_map = double(zeros(size(tileArray,1),size(tileArray,2),size(tileArray,3)));
Delay_map = double(zeros(size(tileArray,1),size(tileArray,2),size(tileArray,3)));
MTT_map = double(zeros(size(tileArray,1),size(tileArray,2),size(tileArray,3)));


codeArray = zeros(size(tileArray));

for i = 1:tRC %for rows
  for j = 1:tRC %for columns
     for slice =1:size(tileArray,3)-1
         
        CBF = P.CBV(slice)/P.MTT(j);
        mtt = P.MTT(j);
        cValue =  cal_ctc(P,mtt,CBF); % convolving at higher resolution
        cValue = cValue(1:size(P.aifV,2)); %coming back on lower resolution
        cValue = cValue(1:P.upSamptime:size(cValue,2));
        
       for k = 1:size(tileArray,4)  %putting value in each timepoint. is there matlab way of doing this ?
          tileArray(startR:endR,startC:endC,slice,k) = cValue(k); 
          codeArray(startR:endR,startC:endC,slice,k)=1;
       end
         
       CBF_map(startR:endR,startC:endC,slice,:) = CBF;
       CBV_map(startR:endR,startC:endC,slice,:) = P.CBV(slice);
       Delay_map(startR:endR,startC:endC,slice,:) = P.resD;
       MTT_map(startR:endR,startC:endC,slice,:) = mtt;
       
    end    
       
       startC = endC+2*hpadding+1;
       endC = startC+stepsize-1;

       
  end

    P.resD = P.resD+2;
    startR = endR+2 * hpadding+1;
    endR = startR+stepsize -1 ;
    startC = IstartC;
    endC = IendC;
end

P.aifV = (P.aifV(1:P.upSamptime:size(P.aifV,2))); 
P.aifV = P.aifV(1:size(tileArray,4));

% tileArray(IstartR:IendR,IstartC:IendR,:,:)=0;

for i = 1:size(tileArray,4)
 tileArray(IstartR:IendR,IstartC:IendR,size(tileArray,3),i)=P.aifV(i);  %best way to do in matlab.
 codeArray(IstartR:IendR,IstartC:IendR,size(tileArray,3),i)=2;
end

end

