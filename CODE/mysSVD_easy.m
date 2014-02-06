function [cbf,delay,cbv]=mysSVD_easy(cmatrix,AIF,threshold,delt,dosmooth)
%impresp=mySVD(cmap,AIF,threshold,bolusarrivalsample,delt,viewmode)
%assumes cmatrix to be an MxN matrix where M is the curve number dimension
%and N is the sample number dimension

if isempty(AIF)
    return
end



AIFmatrix=aifm_sim(AIF,delt,dosmooth);    %make matrix

[U,S,V]=svd(AIFmatrix);      %SVD

%figure
%dd=diag(S);
%plot(dd);
%maxval=S(1,1)*threshold;

%legals=find(dd>=maxval);

%hold on

%plot(legals(end),dd(legals(end)),'bx','markersize',10);


Slogic=(S>=S(1,1)*threshold);   %mask of all values above threshold



for n=1:length(S)
    S(n,n)=1/S(n,n);             %invert diagonal
    if isinf(S(n,n))
        S(n,n)=0;
    end
end

S=Slogic.*S;          %keep masked values




invAIF=V*S*U';         %matrix SVD truncated inverse


impresp=zeros(size(cmatrix));

%plot(AIF);
%hold on
for n=1:size(cmatrix,1)
    %if rem(n,50)==0
    %    disp(num2str(n))
    %end
    impresp(n,:)=invAIF*cmatrix(n,:)'; 

end


        
[cbf,delay]=max(impresp,[],2);
delay=(delay-1)*delt;
cbv=trapz( impresp,2)*delt;