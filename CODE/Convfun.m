function [aifV,resf] = Convfun(P)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

aifV = phantom_aif(P.timevec,P.aifscaleF,P.curvS,P.aifR,P.aifb)

resf =  exp ( - (P.timevec-P.resD)/P.MTT); % impulse response.
resf(P.timevec<P.resD)=0;
temp = conv(aifV,resf) * (P.samplTime/P.upSamptime)
hold all;
plot(temp(1:P.upSamptime:size(temp,2)));
end

