function [ ctc_val] = cal_ctc(P,mtt,CBF)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
resf =  exp ( - (P.timevec-P.resD)/mtt); % impulse response.
resf(P.timevec<P.resD)=0;
ctc_val = (CBF * ( (P.samplTime/P.upSamptime) * conv(resf,P.aifV)));
end

