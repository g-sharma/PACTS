function A=aifm1_sim(aif,delt,dosmooth)
%function A=aifm1(aif)
%returns AIF matrix for deconvolution
%aif MUST BE ZERO PADDED 
%similar to aifm, but constructs a circular matrix where each row contains the whole AIF curve.
%See reference 5 for details.

%Prepare the matrix notation

%zero pad with lenght+1 (just to be sure...)

aif=reshape(aif,1,[]);



 if dosmooth
AIF=[0 aif 0];   %szero pad for running weighted-average

lengthA=length(AIF);


A=zeros(lengthA-2);

for row=1:lengthA-2
    for column=1:lengthA-2;    
        if (row>=column);
            intoarraypos=row-column+1+1;              %as first entry of AIF will be a zeropadding and index starts at 1 not 0
            A(row,column)=delt*(AIF(intoarraypos-1)+4*AIF(intoarraypos)+AIF(intoarraypos+1))/6;
        else
            intoarraypos=(lengthA-2)-column+row+1+1;
            A(row,column)=delt*(AIF(intoarraypos-1)+4*AIF(intoarraypos)+AIF(intoarraypos+1))/6;
        end
    end
end

else   
      %AIF=[0 aif 0];   %szero pad for running weighted-average
AIF=aif;

lengthA=length(AIF);

A=zeros(lengthA);

for row=1:lengthA
    for column=1:lengthA  
        if (row>=column)
            intoarraypos=row-column+1;             
            A(row,column)=delt*AIF(intoarraypos);
        else
            intoarraypos=(lengthA)-column+row+1;
            A(row,column)=delt*AIF(intoarraypos);
        end
    end
end
    
   
end