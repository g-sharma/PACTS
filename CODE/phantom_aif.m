function [ aif ] = phantom_aif(P)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
aif = P.aifscaleF * power((P.timevec-P.curvS),P.aifR).*exp(-(P.timevec-P.curvS)/P.aifb);
aif(P.curvS > P.timevec)=0;
end

